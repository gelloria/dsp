/*
* |---------------------------------------------------------------|
* | SDRAM Driver                                                   |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_driver extends uvm_driver#(sdram_tlm);

    virtual sdram_ifc vif_sdram;
    virtual wb_ifc vif_wb;

    `uvm_component_utils(sdram_driver)


    function new (string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(virtual sdram_ifc)::read_by_name(.scope("*"), .name("sdram_ifc"), .val(vif_sdram)));
        if( vif_sdram==null )
            `uvm_fatal("SDRAM_DRV","Cannot get vif_sdram");

        void'(uvm_resource_db#(virtual wb_ifc)::read_by_name(.scope("*"), .name("wb_ifc"), .val(vif_wb)));
        if( vif_wb==null )
            `uvm_fatal("SDRAM_DRV","Cannot get vif_wb");
   endfunction


    task run_phase(uvm_phase phase);
        vif_sdram.reset_n  <= 1'b1;
        vif_wb.reset       <= 1'b0;

        vif_wb.addr_i      <= 0;
        vif_wb.dat_i       <= 0;
        vif_wb.sel_i       <= 4'h0;
        vif_wb.we_i        <= 0;
        vif_wb.stb_i       <= 0;
        vif_wb.cyc_i       <= 0;

        forever begin
            sdram_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            case (tlm.cmd)
               RESET: begin
                  do_reset();
               end

               WRITE: begin
                  do_write();
               end
            endcase
            seq_item_port.item_done();
        end
    endtask


    task drv();
        `uvm_info("SDRAM DRV", "Function to drive the DUT pins.", UVM_LOW);
    endtask

    task do_reset();
       `uvm_info("SDRAM DRV", "Applying RESET.", UVM_LOW);
        vif_sdram.reset_n  <= 1'b0;
        vif_wb.reset       <= 1'b1;
        #10000ns;
       `uvm_info("SDRAM DRV", "Releasing RESET.", UVM_LOW);
        vif_sdram.reset_n  <= 1'b1;
        vif_wb.reset       <= 1'b0;
        #1000ns;
        wait(vif_sdram.init_done);
       `uvm_info("SDRAM DRV", "SDRAM Initialized.", UVM_LOW);
    endtask

    task do_write();
        `uvm_info("SDRAM DRV", "Doing WRITE.", UVM_LOW);
    endtask

endclass : sdram_driver
