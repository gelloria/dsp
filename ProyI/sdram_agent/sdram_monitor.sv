/*
* |---------------------------------------------------------------|
* | SDRAM Monitor                                                 |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_monitor extends uvm_monitor;

    virtual sdram_ifc vif_sdram;
    virtual wb_ifc vif_wb;
    sdram_tlm tlm;

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
            mon_write();
            mon_read();
        join
    endtask


    task mon_write();
        forever begin
            @(negedge vif_wb.clk)
            if (vif_wb.we_i == 1 && vif_wb.stb_i == 1) begin
                `uvm_info("SDRAM MON", "Write start detected", UVM_LOW);
                do
                    @(posedge vif_wb.clk);
                while(vif_wb.ack_o!='d0);
                `uvm_info("SDRAM MON", "Write end detected", UVM_LOW);
            end
        end
    endtask

    logic [31:0] prev_data;
    task mon_read();
        forever begin
            @(negedge vif_wb.clk)
            if (vif_wb.we_i == 0 && vif_wb.stb_i == 1) begin
                `uvm_info("SDRAM MON", "Read start detected", UVM_LOW);
                do
                    @(posedge vif_wb.clk);
                while(vif_wb.ack_o!='d0);
                `uvm_info("SDRAM MON", "Read ackded", UVM_LOW);
                do begin
                    prev_data = vif_wb.dat_o;
                    @(posedge vif_wb.clk);
                end while(vif_wb.dat_o === prev_data);
                `uvm_info("SDRAM MON", "Read end detected", UVM_LOW);
            end
        end
    endtask

endclass : sdram_monitor
