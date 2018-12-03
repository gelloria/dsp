/*
* |---------------------------------------------------------------|
* | Basic Test                                                    |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_test_with_eot extends sdram_base_test;

   `uvm_component_utils(sdram_test_with_eot)

    function new (string name="test", uvm_component parent=null);
        super.new (name, parent);
    endfunction


    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(.obj(this));
        eot_check();
        phase.drop_objection(.obj(this));
    endtask

    task eot_check();
        bit ok;
        `uvm_info("SDRAM_TEST", "EOT check", UVM_LOW);

        assert(env.scb.sdram.num() != 0) else `uvm_error("EOT_CHECK", "Scoreboard saw no activity during test");
        foreach (env.scb.sdram[i]) begin
            seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
            ok = seq.randomize() with {
                cmd == READ;
                addr == i;
            };
            assert (ok) else `uvm_fatal("SDRAM_TEST", "Randomization failed");
            seq.start(env.agent.sequencer);
        end

        `uvm_info("SDRAM_TEST", "End of test", UVM_LOW);

    endtask

endclass : sdram_test_with_eot
