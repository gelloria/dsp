/*
* |---------------------------------------------------------------|
* | Testbench                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

`include "sdram_ifc.svh"


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

    sdram_ifc sdram();

    initial begin
        uvm_config_db#(virtual sdram_ifc)::set(uvm_root::get(), "*", "sdram_ifc", sdram);

        run_test("sdram_test");
    end

    // Instantiate DUT
    reg RESETN;
    reg sdram_clk;
    reg sys_clk;

    //--------------------------------------
    // Wish Bone Interface
    // -------------------------------------
    reg             wb_stb_i;
    wire            wb_ack_o;
    reg  [25:0]     wb_addr_i;
    reg             wb_we_i; // 1 - Write, 0 - Read
    reg  [32-1:0]   wb_dat_i;
    reg  [32/8-1:0] wb_sel_i; // Byte enable
    wire  [32-1:0]  wb_dat_o;
    reg             wb_cyc_i;
    reg   [2:0]     wb_cti_i;

    //--------------------------------------------
    // SDRAM I/F
    //--------------------------------------------
    wire [15:0]           Dq; // SDRAM Read/Write Data Bus
    wire [1:0]            sdr_dqm; // SDRAM DATA Mask
    wire [1:0]            sdr_ba; // SDRAM Bank Select
    wire [12:0]           sdr_addr; // SDRAM ADRESS
    wire                  sdr_init_done; // SDRAM Init Done

    // to fix the sdram interface timing issue
    wire #(2.0) sdram_clk_d = sdram_clk;

    sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
        .cfg_sdr_width      (2'b01              ),
        .cfg_colbits        (2'b00              ), // 8 Bit Column Address

        /* WISH BONE */
        .wb_rst_i           (!RESETN            ),
        .wb_clk_i           (sys_clk            ),

        .wb_stb_i           (wb_stb_i           ),
        .wb_ack_o           (wb_ack_o           ),
        .wb_addr_i          (wb_addr_i          ),
        .wb_we_i            (wb_we_i            ),
        .wb_dat_i           (wb_dat_i           ),
        .wb_sel_i           (wb_sel_i           ),
        .wb_dat_o           (wb_dat_o           ),
        .wb_cyc_i           (wb_cyc_i           ),
        .wb_cti_i           (wb_cti_i           ),

        /* Interface to SDRAMs */
        .sdram_clk          (sdram_clk          ),
        .sdram_resetn       (RESETN             ),
        .sdr_cs_n           (sdr_cs_n           ),
        .sdr_cke            (sdr_cke            ),
        .sdr_ras_n          (sdr_ras_n          ),
        .sdr_cas_n          (sdr_cas_n          ),
        .sdr_we_n           (sdr_we_n           ),
        .sdr_dqm            (sdr_dqm            ),
        .sdr_ba             (sdr_ba             ),
        .sdr_addr           (sdr_addr           ),
        .sdr_dq             (Dq                 ),

        /* Parameters */
        .sdr_init_done      (sdr_init_done      ),
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

   IS42VM16400K u_sdram16 (
          .dq                 (Dq                 ),
          .addr               (sdr_addr[11:0]     ),
          .ba                 (sdr_ba             ),
          .clk                (sdram_clk_d        ),
          .cke                (sdr_cke            ),
          .csb                (sdr_cs_n           ),
          .rasb               (sdr_ras_n          ),
          .casb               (sdr_cas_n          ),
          .web                (sdr_we_n           ),
          .dqm                (sdr_dqm            )
    );
endmodule
