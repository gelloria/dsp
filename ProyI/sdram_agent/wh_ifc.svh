/*
* |---------------------------------------------------------------|
* | wh ifc                                                        |
* |                                                               |
* |---------------------------------------------------------------|
*/

`timescale 1ns/1ps
interface wh_ifc;
    logic clk_i;
    logic rst_i;
    logic cyc_i;
    logic stb_i;
    logic ack_o;

endinterface : wh_ifc
