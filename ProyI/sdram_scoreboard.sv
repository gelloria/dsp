/*
* |---------------------------------------------------------------|
* | SDRAM Scoreboard                                              |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_scoreboard extends uvm_scoreboard;

    uvm_tlm_analysis_fifo#(sdram_tlm) fifo;
    sdram_tlm tlm;
    int sdram [int];

    `uvm_component_utils(sdram_scoreboard)


    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo = new("fifo", this);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction


    task run_phase(uvm_phase phase);
        forever begin
            fifo.get(tlm);
            case (tlm.cmd)
                WRITE: begin
                   `uvm_info("SDRAM_SCB", $psprintf("Updating virtual SDRAM with WRITE command. sdram[%0h]=0x%0h",tlm.addr,tlm.data), UVM_LOW);
                   sdram [tlm.addr] = tlm.data;
                end
                READ: begin
                    check_sdram_data(tlm.addr,tlm.data);
                end
                RESET: begin
                   foreach (sdram[i]) begin
                     sdram.delete(i);
                   end
                   `uvm_info("SDRAM_SCB", "Reference SDRAM is RESET", UVM_LOW);
               end
            endcase
        end
    endtask


    function void check_sdram_data(int addr, int tlm_data);
        `uvm_info("SDRAM_SCB", $psprintf("Checking READ data with virtual SDRAM. sdram[%0h]=0x%0h",tlm.addr,tlm.data), UVM_LOW);
        if (sdram.exists(addr)) begin
            if (sdram[addr]==tlm_data) begin
                `uvm_info("SDRAM_SCB", "READ PASS: Read match with virtual SDRAM value", UVM_LOW);
            end
            else begin
               `uvm_error("SDRAM_SCB", $psprintf("READ doesn't match with stored value --> Addr:0x%0h, Model_data:0x%0h, Read_data:0x%0h",addr,sdram[addr],tlm_data));
            end
        end
        else
            `uvm_info("SDRAM_SCB", $psprintf("The read address:0x%0h isn't initialized",addr), UVM_LOW);
    endfunction

endclass : sdram_scoreboard
