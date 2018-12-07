/*
* |---------------------------------------------------------------|
* | Testbench                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

`include "CAS_ifc.svh"
`include "sdram_ifc.svh"
`include "wb_ifc.svh"
`include "wh_ifc.svh"

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "sdram_pkg.sv"
import sdram_pkg::*;

`define S50

`include "sdrc_top.v"
`include "wb2sdrc.v"
`include "async_fifo.v"
`include "sdrc_core.v"
`include "sdrc_req_gen.v"
`include "sdrc_bank_ctl.v"
`include "sdrc_bank_fsm.v"
`include "sdrc_xfr_ctl.v"
`include "sdrc_bs_convert.v"

`ifdef SDRAM_16BIT
   `include "IS42VM16400K.v"
`endif

`ifdef SDRAM_8BIT
   `include "mt48lc8m8a2.v"
`endif

`ifdef SDRAM_32BIT
   `include "mt48lc2m32b2.v"
`endif



module tb_top();

   `ifdef SDRAM_8BIT
      `define SDRAM_DW 8
      `define SDRAM_BW 1
      `define SDRAM_WIDTH 2'b10
   `endif

   `ifdef SDRAM_16BIT
      `define SDRAM_DW 16
      `define SDRAM_BW 2
      `define SDRAM_WIDTH 2'b01
   `endif

   `ifdef SDRAM_32BIT
      `define SDRAM_DW 32
      `define SDRAM_BW 4
      `define SDRAM_WIDTH 2'b00
   `endif

   //Clock periods
   parameter      P_SYS  = 10;     //    200MHz
   parameter      P_SDR  = 20;     //    100MHz

   //reg            RESETN;
   reg            sdram_clk;
   reg            sys_clk;

   int unsigned phase;

   covergroup async_clocks_c;
      option.per_instance = 1;
      coverpoint phase {
         bins b00 = {00};
         bins b01 = {01};
         bins b02 = {02};
         bins b03 = {03};
         bins b04 = {04};
         bins b05 = {05};
         bins b06 = {06};
         bins b07 = {07};
         bins b08 = {08};
         bins b09 = {09};
         bins b11 = {11};
         bins b12 = {12};
         bins b13 = {13};
         bins b14 = {14};
         bins b15 = {15};
         bins b16 = {16};
         bins b17 = {17};
         bins b18 = {18};
         bins b19 = {19};
         bins b20 = {20};
         ignore_bins out_of_range = {[21:'hFFFF_FFFF]};
      }
   endgroup

   initial begin
      sys_clk = 0;
      while (1) begin
         sys_clk = !sys_clk;
         #(P_SYS/2);
      end
   end

   initial begin
      async_clocks_c async_clocks = new();
      async_clocks.set_inst_name("asyn_clocks_c");
      sdram_clk = 0;
      phase = $urandom_range(0, 20);
      #(phase * 1ns);
      async_clocks.sample();
      while (1) begin
         sdram_clk = !sdram_clk;
         #(P_SDR/2);
      end
   end


   // to fix the sdram interface timing issue
   wire #(2.0) clk_d = sdram_clk;

   assign sdram.clk = sdram_clk;
   assign wb.clk = sys_clk;

   //assign sdram.reset_n = RESETN;
   //assign wb.reset = ~RESETN;

   //--------------------------------------
   // Wish Bone Interface
   // -------------------------------------
   wb_ifc wb();

   //--------------------------------------
   // Whitebox Interface
   // -------------------------------------
   wh_ifc wh();

   //--------------------------------------------
   // SDRAM I/F
   //--------------------------------------------
   sdram_ifc sdram();

   //--------------------------------------------
   // CAS I/F
   //--------------------------------------------
   CAS_ifc cas();

   //--------------------------------------------
   // Whitebox connections
   //--------------------------------------------
   assign wh.clk_i = u_dut.u_wb2sdrc.wb_clk_i;
   assign wh.rst_i = u_dut.u_wb2sdrc.wb_rst_i;
   assign wh.cyc_i = u_dut.u_wb2sdrc.wb_cyc_i;
   assign wh.stb_i = u_dut.u_wb2sdrc.wb_stb_i;
   assign wh.ack_o = u_dut.u_wb2sdrc.wb_ack_o;

   assign wh.ifc_stb_i  = wb.stb_i;
   assign wh.ifc_ack_o  = wb.ack_o;
   assign wh.ifc_addr_i = wb.addr_i;
   assign wh.ifc_we_i   = wb.we_i;
   assign wh.ifc_dat_i  = wb.dat_i;
   assign wh.ifc_sel_i  = wb.sel_i;
   assign wh.ifc_dat_o  = 0; //FIXME
   assign wh.ifc_cyc_i  = wb.cyc_i;
   assign wh.ifc_cti_i  = 0; //FIXME

   //--------------------------------------------
   // CAS connections
   //--------------------------------------------
   assign cas.dq = sdram.dq;
   assign cas.stb = wb.stb_i;
   assign cas.read = ~wb.we_i;
   assign cas.clk = sdram.clk;
   assign cas.cas_n = sdram.cas_n;
   assign cas.ras_n = sdram.ras_n;
   assign cas.we_n = sdram.we_n;

   //--------------------------------------------
   // SDRAM Controller
   //--------------------------------------------
   sdrc_top #(.SDR_DW(`SDRAM_DW),.SDR_BW(`SDRAM_BW)) u_dut(
      .cfg_sdr_width      (`SDRAM_WIDTH       ),
      .cfg_colbits        (2'b00              ), // 8 Bit Column Address

      /* WISH BONE */
      .wb_clk_i           (wb.clk             ),
      .wb_rst_i           (wb.reset           ),

      .wb_addr_i          (wb.addr_i          ),
      .wb_dat_i           (wb.dat_i           ),
      .wb_dat_o           (wb.dat_o           ),
      .wb_sel_i           (wb.sel_i           ),
      .wb_we_i            (wb.we_i            ),
      .wb_stb_i           (wb.stb_i           ),
      .wb_cyc_i           (wb.cyc_i           ),
      .wb_ack_o           (wb.ack_o           ),
      .wb_cti_i           (wb.cti_i           ),

      /* Interface to SDRAMs */
      .sdram_clk          (sdram.clk          ),
      .sdram_resetn       (sdram.reset_n      ),

      .sdr_cke            (sdram.cke          ),
      .sdr_cs_n           (sdram.cs_n         ),
      .sdr_ras_n          (sdram.ras_n        ),
      .sdr_cas_n          (sdram.cas_n        ),
      .sdr_we_n           (sdram.we_n         ),
      .sdr_dqm            (sdram.dqm[`SDRAM_BW-1:0]   ),
      .sdr_ba             (sdram.ba           ),
      .sdr_addr           (sdram.addr         ),
      .sdr_dq             (sdram.dq[`SDRAM_DW-1:0]    ),

      /* Parameters */
      .sdr_init_done      (sdram.init_done    ),
      .cfg_req_depth      (2'h3               ), //how many req. buffer should hold
      .cfg_sdr_en         (1'b1               ),
      .cfg_sdr_mode_reg   ({6'h0,cas.cfg_sdr_cas,4'd3}),
      .cfg_sdr_tras_d     (4'h4               ),
      .cfg_sdr_trp_d      (4'h2               ),
      .cfg_sdr_trcd_d     (4'h2               ),
      .cfg_sdr_cas        (cas.cfg_sdr_cas    ),
      .cfg_sdr_trcar_d    (4'h7               ),
      .cfg_sdr_twr_d      (4'h1               ),
      .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
      .cfg_sdr_rfmax      (3'h6               )
   );

   int unsigned data_width; // =`SDRAM_DW;
   covergroup sdram_data_width_c;
      option.per_instance = 1;
      data_width : coverpoint data_width {
         bins DW_8BITS  = {8};
         bins DW_16BITS = {16};
         bins DW_32BITS = {32};
        //ignore_bins out_of_range = {8, 16, 32};
      }
   endgroup

   initial begin
      sdram_data_width_c sdram_data_width = new();
      data_width = `SDRAM_DW;
      sdram_data_width.set_inst_name("sdram_data_width");
      sdram_data_width.sample();
   end

   `ifdef SDRAM_8BIT
      //SDRAM 8BITS
      mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
         .Clk                (clk_d              ),
         .Cke                (sdram.cke          ),
         .Cs_n               (sdram.cs_n         ),
         .Ras_n              (sdram.ras_n         ),
         .Cas_n              (sdram.cas_n        ),
         .We_n               (sdram.we_n         ),
         .Dqm                (sdram.dqm[`SDRAM_BW-1:0]   ),
         .Ba                 (sdram.ba           ),
         .Addr               (sdram.addr[11:0]   ),
         .Dq                 (sdram.dq[`SDRAM_DW-1:0]    )
      );
   `endif

   `ifdef SDRAM_16BIT
      //SDRAM 16BITS
      IS42VM16400K u_sdram16 (
         .clk                (clk_d              ),
         .cke                (sdram.cke          ),
         .csb                (sdram.cs_n         ),
         .rasb               (sdram.ras_n        ),
         .casb               (sdram.cas_n        ),
         .web                (sdram.we_n         ),
         .dqm                (sdram.dqm[`SDRAM_BW-1:0]   ),
         .ba                 (sdram.ba           ),
         .addr               (sdram.addr[11:0]   ),
         .dq                 (sdram.dq[`SDRAM_DW-1:0]    )
      );
   `endif

   `ifdef SDRAM_32BIT
      //SDRAM 32BITS
      mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
         .Clk                (clk_d              ),
         .Cke                (sdram.cke          ),
         .Cs_n               (sdram.cs_n         ),
         .Ras_n              (sdram.ras_n        ),
         .Cas_n              (sdram.cas_n        ),
         .We_n               (sdram.we_n         ),
         .Dqm                (sdram.dqm[`SDRAM_BW-1:0]   ),
         .Ba                 (sdram.ba           ),
         .Addr               (sdram.addr[10:0]   ),
         .Dq                 (sdram.dq[`SDRAM_DW-1:0]    )
      );
   `endif


   initial begin
      uvm_config_db#(virtual CAS_ifc)::set(uvm_root::get(), "*", "cas_ifc", cas);
      uvm_config_db#(virtual sdram_ifc)::set(uvm_root::get(), "*", "sdram_ifc", sdram);
      uvm_config_db#(virtual wb_ifc)::set(uvm_root::get(), "*", "wb_ifc", wb);
      uvm_config_db#(virtual wh_ifc)::set(uvm_root::get(), "*", "wh_ifc", wh);

     `ifdef SV_TEST
        `define STR_TEST(test) `"test`"
        run_test(`STR_TEST(`SV_TEST));
     `endif
   end

   //Assertions
endmodule
