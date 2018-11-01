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


module tb_top();

    sdram_ifc sdram();

    initial begin
        uvm_config_db#(virtual sdram_ifc)::set(uvm_root::get(), "*", "sdram_ifc", sdram);

        run_test("sdram_test");
    end


    // Instantiate DUT

endmodule
