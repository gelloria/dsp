/*
* |---------------------------------------------------------------|
* | Basic Test                                                    |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_write_test extends sdram_base_test;

   `uvm_component_utils(sdram_write_test)

    function new (string name="test", uvm_component parent=null);
        super.new (name, parent);
    endfunction

    task main_phase(uvm_phase phase);
       phase.raise_objection(.obj(this));
       do_writes();
       phase.drop_objection(.obj(this));
    endtask

    task do_writes();
        bit ok;
        for(int loops = 0; loops < 10; loops++) begin
            for (int writes = 0; writes < 10; writes++) begin
                seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
                ok = seq.randomize() with {
                    cmd == WRITE;
                };
                assert (ok) else `uvm_fatal("SDRAM_TEST", "Randomization failed");
                seq.start(env.agent.sequencer);
            end
        end
    endtask

endclass : sdram_write_test
