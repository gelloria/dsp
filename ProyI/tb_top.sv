/*
* |---------------------------------------------------------------|
* | Testbench                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

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
`include "IS42VM16400K.v"



module tb_top();

   //Clock periods
   parameter      P_SYS  = 10;     //    200MHz
   parameter      P_SDR  = 20;     //    100MHz

   //reg            RESETN;
   reg            sdram_clk;
   reg            sys_clk;

   initial        sys_clk = 0;
   initial        sdram_clk = 0;

   always #(P_SYS/2) sys_clk = !sys_clk;
   always #(P_SDR/2) sdram_clk = !sdram_clk;

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
   // SDRAM Controller
   //--------------------------------------------
   sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
      .cfg_sdr_width      (2'b01              ),
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
      .sdr_dqm            (sdram.dqm          ),
      .sdr_ba             (sdram.ba           ),
      .sdr_addr           (sdram.addr         ),
      .sdr_dq             (sdram.dq           ),

      /* Parameters */
      .sdr_init_done      (sdram.init_done    ),
      .cfg_req_depth      (2'h3               ), //how many req. buffer should hold
      .cfg_sdr_en         (1'b1               ),
      .cfg_sdr_mode_reg   (13'h033            ),
      .cfg_sdr_tras_d     (4'h4               ),
      .cfg_sdr_trp_d      (4'h2               ),
      .cfg_sdr_trcd_d     (4'h2               ),
      .cfg_sdr_cas        (3'h3               ),
      .cfg_sdr_trcar_d    (4'h7               ),
      .cfg_sdr_twr_d      (4'h1               ),
      .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
      .cfg_sdr_rfmax      (3'h6               )
   );

   //SDRAM
   IS42VM16400K u_sdram16 (
      .clk                (clk_d              ),
      .cke                (sdram.cke          ),
      .csb                (sdram.cs_n         ),
      .rasb               (sdram.ras_n        ),
      .casb               (sdram.cas_n        ),
      .web                (sdram.we_n         ),
      .dqm                (sdram.dqm          ),
      .ba                 (sdram.ba           ),
      .addr               (sdram.addr[11:0]   ),
      .dq                 (sdram.dq           )
   );

   initial begin
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
