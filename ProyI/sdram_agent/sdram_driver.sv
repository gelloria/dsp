/*
* |---------------------------------------------------------------|
* | SDRAM Driver                                                   |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_driver extends uvm_driver#(sdram_tlm);

    virtual sdram_ifc vif_sdram;
    virtual wb_ifc vif_wb;
    virtual wh_ifc vif_wh;

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

        void'(uvm_resource_db#(virtual wh_ifc)::read_by_name(.scope("*"), .name("wh_ifc"), .val(vif_wh)));
        if( vif_wh==null )
            `uvm_fatal("SDRAM_DRV","Cannot get vif_wh");
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
                    #100ns;
                end

                WRITE: begin
                    do_write(tlm);
                    #1000ns;
                end

                READ: begin
                    do_read(tlm);
                    #1000ns;
                end
            endcase
            seq_item_port.item_done();
        end
    endtask

    task do_reset();
       `uvm_info("SDRAM_DRV", "Applying RESET.", UVM_LOW);
        vif_sdram.reset_n  <= 1'b0;
        vif_wb.reset       <= 1'b1;
        #10000ns;
       `uvm_info("SDRAM_DRV", "Releasing RESET.", UVM_LOW);
        vif_sdram.reset_n  <= 1'b1;
        vif_wb.reset       <= 1'b0;
        #1000ns;
        wait(vif_sdram.init_done);
       `uvm_info("SDRAM_DRV", "SDRAM Initialized.", UVM_LOW);
    endtask

    task do_write(sdram_tlm tlm);
        logic [31:0] write_counter;

        `uvm_info("SDRAM_DRV", "Doing WRITE.", UVM_LOW);
        @(negedge vif_wb.clk)

        vif_wb.sel_i       <= 4'hF;
        vif_wb.we_i        <= 1;
        vif_wb.stb_i       <= 1;
        vif_wb.cyc_i       <= 1;

        vif_wb.addr_i      <= tlm.addr;
        vif_wb.dat_i       <= tlm.data;

        write_counter = 0;
        do begin
            write_counter += 1;
            @(posedge vif_wb.clk);
        end while(vif_wb.ack_o!='d0);
        if (write_counter < 2) `uvm_error("SDRAM_DRV", "No ack detected for write operation");
        `uvm_info("SDRAM_DRV", $psprintf("WRITE Addr:0x%0h Data:0x%0h completed.",tlm.addr,tlm.data), UVM_LOW);

        vif_wb.sel_i       <= 4'h0;
        vif_wb.we_i        <= 0;
        vif_wb.stb_i       <= 0;
        vif_wb.cyc_i       <= 0;

        vif_wb.addr_i      <= 0;
        vif_wb.dat_i       <= 0;
    endtask

    task do_read(sdram_tlm tlm);
        logic [31:0] read_counter;

        `uvm_info("SDRAM_DRV", "Doing READ.", UVM_LOW);
        @(negedge vif_wb.clk)

        vif_wb.we_i        <= 0;
        vif_wb.stb_i       <= 1;
        vif_wb.cyc_i       <= 1;

        vif_wb.addr_i      <= tlm.addr;

        read_counter = 0;
        do begin
            read_counter += 1;
            @(posedge vif_wb.clk);
        end while(vif_wb.ack_o!='d0);
        if (read_counter < 2) `uvm_error("SDRAM_DRV", "No ack detected for read operation");

        vif_wb.stb_i       <= 0;
        vif_wb.cyc_i       <= 0;

        vif_wb.addr_i      <= 0;

        read_counter = 0;
        do begin
            read_counter += 1;
            @(posedge vif_wb.clk);
        end while(read_counter < 85);
        `uvm_info("SDRAM_DRV", $psprintf("READ Addr:0x%0h Data:0x%0h completed.", tlm.addr, vif_wb.dat_o), UVM_LOW);
    endtask

endclass : sdram_driver
