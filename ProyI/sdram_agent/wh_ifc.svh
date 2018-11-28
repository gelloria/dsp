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

    wb300_asrt: assert property (wb300) else $display("[SDRAM_ASSRT] Property wb300 has failed");
    wb300_covr: cover property (wb300) $display("[SDRAM_ASSRT] Property wb300 has passed");


    property wb305;
        @(posedge clk_i) $rose(rst_i) |-> $fell(rst_i);
    endproperty

    wb305_asrt: assert property (wb305) else $display("[SDRAM_ASSRT] Property wb305 has failed");
    wb305_covr: cover property (wb305) $display("[SDRAM_ASSRT] Property wb305 has passed");

endinterface : wh_ifc
