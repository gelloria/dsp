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

    property wb300;
        @(posedge clk_i) $rose(rst_i) |-> $fell(rst_i);
    endproperty

    aP: assert property (wb300) else `uvm_error("SDRAM_ASSRT", "Property wb300 has failed");
    cP: cover property (wb300) else `uvm_info("SDRAM_ASSRT", "Property wb300 has failed");

endinterface : wh_ifc
