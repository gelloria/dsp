/*
* |---------------------------------------------------------------|
* | SDRAM Monitor                                                 |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_monitor extends uvm_monitor;

    virtual sdram_ifc vif_sdram;
    virtual wb_ifc vif_wb;

    uvm_analysis_port#(sdram_tlm) ch_out;

    `uvm_component_utils(sdram_monitor)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(virtual sdram_ifc)::read_by_name(.scope("*"), .name("sdram_ifc"), .val(vif_sdram)));
        if( vif_sdram==null )
            `uvm_fatal("SDRAM_MON","Cannot get vifsdram");

        void'(uvm_resource_db#(virtual wb_ifc)::read_by_name(.scope("*"), .name("wb_ifc"), .val(vif_wb)));
        if( vif_wb==null )
            `uvm_fatal("SDRAM_MON","Cannot get vif_wb");

        ch_out = new(.name("ch_out"), .parent(this));
    endfunction


    task run_phase(uvm_phase phase);
        fork
            mon_reset();
            mon_write();
            mon_read();
        join
    endtask

    task mon_reset();
        sdram_tlm tlm;
        forever begin
            @(posedge vif_wb.reset)
            tlm = new();
            tlm.cmd = RESET;
            @(negedge vif_wb.reset)
            ch_out.write(tlm);
        end
    endtask

    task mon_write();
        sdram_tlm tlm;
        forever begin
            @(posedge vif_wb.clk)
            if (vif_wb.we_i == 1 && vif_wb.stb_i == 1) begin
                tlm = new();
                tlm.cmd = WRITE;
                tlm.addr = vif_wb.addr_i;
                tlm.data = vif_wb.dat_i;
                do
                    @(posedge vif_wb.clk);
                while(vif_wb.ack_o!='d0);
                `uvm_info("SDRAM_MON", $psprintf("Detected: %s", tlm.print()), UVM_LOW);
                ch_out.write(tlm);
            end
        end
    endtask

    logic [31:0] counter;
    task mon_read();
        sdram_tlm tlm;
        forever begin
            @(posedge vif_wb.clk)
            if (vif_wb.we_i == 0 && vif_wb.stb_i == 1) begin
                tlm = new();
                tlm.cmd = READ;
                tlm.addr = vif_wb.addr_i;
                do
                    @(posedge vif_wb.clk);
                while(vif_wb.ack_o!='d0);

                counter = 0;
                do begin
                    counter += 1;
                    @(posedge vif_wb.clk);
                end while(counter < 26);
                tlm.data = vif_wb.dat_o;
                `uvm_info("SDRAM_MON", $psprintf("Detected: %s", tlm.print()), UVM_LOW);
                ch_out.write(tlm);
            end
        end
    endtask

endclass : sdram_monitor
