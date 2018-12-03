/*
* |---------------------------------------------------------------|
* | Basic Test                                                    |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_rw_reset_test extends sdram_read_write_test;

   `uvm_component_utils(sdram_rw_reset_test)

    function new (string name="test", uvm_component parent=null);
        super.new (name, parent);
    endfunction

    task main_phase(uvm_phase phase);
       phase.raise_objection(.obj(this));
       fork
           begin
               super.main_phase(phase);
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

endclass : sdram_rw_reset_test
