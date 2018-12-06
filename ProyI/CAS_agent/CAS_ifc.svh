/*
* |---------------------------------------------------------------|
* | SDRAM ifc                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

`timescale 1ns/1ps
interface CAS_ifc#(parameter DQ_WIDTH = 16);

    logic                   clk;
    logic                   reset_n;

    logic [2:0]             cfg_sdr_cas;

    logic                   read;
    logic                   stb;

    logic                   cas_n;
    logic                   ras_n;
    logic                   we_n;
    logic [DQ_WIDTH-1:0]    dq;

endinterface : CAS_ifc
