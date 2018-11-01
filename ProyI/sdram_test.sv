/*
* |---------------------------------------------------------------|
* | Basic Test                                                    |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_test extends uvm_test;

    sdram_env env;

   `uvm_component_utils(sdram_test)


    function new (string name="test", uvm_component parent=null);
        super.new (name, parent);
        env = new();
    endfunction


    task run_phase(uvm_phase phase);
        phase.raise_objection(.obj(this));
        phase.drop_objection(.obj(this));
    endtask

endclass : sdram_test
