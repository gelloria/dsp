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
        @(posedge clk_i) $rose(rst_i) |-> $fell(rst_i); //What does it mean by INITIALIZED STATE?
    endproperty
    wb300_asrt: assert property (wb300) else $display("[SDRAM_ASSRT] Property wb300 has failed");
    wb300_covr: cover property (wb300) $display("[SDRAM_ASSRT] Property wb300 has passed");

    property wb305;
        @(posedge clk_i) $rose(rst_i) |-> ##[1:$] $fell(rst_i); //Done. At least one clock or infinity
    endproperty
    wb305_asrt: assert property (wb305) else $display("[SDRAM_ASSRT] Property wb305 has failed");
    wb305_covr: cover property (wb305) $display("[SDRAM_ASSRT] Property wb305 has passed");

    property wb310;
        @(posedge clk_i) $rose(rst_i) |-> ##[1:$] $fell(rst_i); //What does it mean by reacting?
    endproperty
    wb310_asrt: assert property (wb310) else $display("[SDRAM_ASSRT] Property wb310 has failed");
    wb310_covr: cover property (wb310) $display("[SDRAM_ASSRT] Property wb310 has passed");

    property wb325;
        @(posedge clk_i) $rose(stb_i) |-> $rose(cyc_i) |-> ##[1:$] $fell(stb_i) |-> $fell(cyc_i); //Done. Same-clock rising and falling
    endproperty
    wb325_asrt: assert property (wb325) else $display("[SDRAM_ASSRT] Property wb325 has failed");
    wb325_covr: cover property (wb325) $display("[SDRAM_ASSRT] Property wb325 has passed");

    property wb335;
        @(posedge clk_i) $rose(stb_i) & $rose(cyc_i) |-> $rose(ack_o); //Done. ACK response to and of stb and cyc.
    endproperty
    wb335_asrt: assert property (wb335) else $display("[SDRAM_ASSRT] Property wb335 has failed");
    wb335_covr: cover property (wb335) $display("[SDRAM_ASSRT] Property wb335 has passed");

endinterface : wh_ifc
