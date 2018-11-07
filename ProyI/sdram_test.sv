/*
* |---------------------------------------------------------------|
* | Basic Test                                                    |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_test extends uvm_test;

    sdram_env env;
    sdram_sequence seq;

   `uvm_component_utils(sdram_test)


    function new (string name="test", uvm_component parent=null);
        super.new (name, parent);
        env = new();
    endfunction


    task run_phase(uvm_phase phase);
        bit ok;
        phase.raise_objection(.obj(this));
        #1000ns;
        seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
        ok = seq.randomize() with {
           cmd == RESET;
        };
        assert (ok) else `uvm_fatal("Randomization failed");
        seq.start(env.agent.sequencer);

        #100ns;

        seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
        ok = seq.randomize() with {
            cmd == WRITE;
            addr == 'd1;
        };
        assert (ok) else `uvm_fatal("Randomization failed");
        seq.start(env.agent.sequencer);

        #1000ns;

        seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
        ok = seq.randomize() with {
            cmd == READ;
            addr == 'd1;
        };
        assert (ok) else `uvm_fatal("Randomization failed");
        seq.start(env.agent.sequencer);

        #1000ns;

        seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
        ok = seq.randomize() with {
            cmd == WRITE;
            addr == 'd3;
        };
        assert (ok) else `uvm_fatal("Randomization failed");
        seq.start(env.agent.sequencer);

        #1000ns;

        seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
        ok = seq.randomize() with {
            cmd == READ;
            addr == 'd3;
        };
        assert (ok) else `uvm_fatal("Randomization failed");
        seq.start(env.agent.sequencer);

        #1000ns;
        phase.drop_objection(.obj(this));
    endtask

endclass : sdram_test
