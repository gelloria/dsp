/*
* |---------------------------------------------------------------|
* | wb ifc                                                        |
* |                                                               |
* |---------------------------------------------------------------|
*/

`timescale 1ns/1ps
interface wb_ifc;
    logic clk;
    logic reset;

    logic            stb_i;
    logic            ack_o;
    logic [25:0]     addr_i;
    logic            we_i; // 1 - Write, 0 - Read
    logic [32-1:0]   dat_i;
    logic [32/8-1:0] sel_i; // Byte enable
    logic [32-1:0]   dat_o;
    logic            cyc_i;
    logic  [2:0]     cti_i;

endinterface : wb_ifc
