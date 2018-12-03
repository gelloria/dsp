/*
* |---------------------------------------------------------------|
* | Basic Test                                                    |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_test_with_some_resets extends sdram_test_with_eot;

   `uvm_component_utils(sdram_test_with_some_resets)

    function new (string name="test", uvm_component parent=null);
        super.new (name, parent);
    endfunction


    task run_phase(uvm_phase phase);
        phase.raise_objection(.obj(this));

        fork
           begin
               super.run_phase(phase);
           end

           begin
               #100000ns;
               reset();
               #100000ns;
               reset();
           end
        join

        phase.drop_objection(.obj(this));
    endtask

endclass : sdram_test_with_some_resets
