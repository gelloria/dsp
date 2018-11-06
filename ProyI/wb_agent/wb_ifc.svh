/*
* |---------------------------------------------------------------|
* | wb ifc                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

`timescale 1ns/1ps
interface wb_ifc#(
    parameter DATA_SZ_P  = 32,
    parameter ADDR_SZ_P  = 10
);

    logic clk;
    logic reset;

    logic                   cmd;
    logic [ADDR_SZ_P-1:0]   addr;
    logic [DATA_SZ_P-1:0]   data;

endinterface : wb_ifc
