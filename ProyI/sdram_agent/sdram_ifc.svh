/*
* |---------------------------------------------------------------|
* | SDRAM ifc                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

`timescale 1ns/1ps
interface sdram_ifc();
    logic clk;
    logic reset_n;

    wire  [31:0]           dq; // SDRAM Read/Write Data Bus
    logic [3:0]            dqm; // SDRAM DATA Mask
    logic [1:0]            ba; // SDRAM Bank Select
    logic [12:0]           addr; // SDRAM ADRESS
    logic                  init_done; // SDRAM Init Done

    logic we_n;
    logic cas_n;
    logic ras_n;
    logic cke;
    logic cs_n;

endinterface : sdram_ifc
