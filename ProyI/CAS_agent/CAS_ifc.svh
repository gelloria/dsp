/*
* |---------------------------------------------------------------|
* | SDRAM ifc                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

`timescale 1ns/1ps
interface CAS_ifc();

    logic clk;
    logic reset_n;

    logic [2:0] cfg_sdr_cas;

endinterface : CAS_ifc
