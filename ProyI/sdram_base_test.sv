/*
* |---------------------------------------------------------------|
* | Basic Test                                                    |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_base_test extends uvm_test;

    sdram_env env;
    sdram_sequence seq;

   `uvm_component_utils(sdram_base_test)


    function new (string name="test", uvm_component parent=null);
        super.new (name, parent);
        env = new();
    endfunction


    task run_phase(uvm_phase phase);
        phase.raise_objection(.obj(this));
        `uvm_info("SDRAM_TEST", "Start of test", UVM_LOW);
        #1000ns;
        reset();
        do_writes_and_reads();
        phase.drop_objection(.obj(this));
    endtask

    task reset();
        bit ok;
        seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
        ok = seq.randomize() with {
           cmd == RESET;
        };
        assert (ok) else `uvm_fatal("SDRAM_TEST", "Randomization failed");
        seq.start(env.agent.sequencer);
    endtask

    task do_writes_and_reads();
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

            for (int reads = 0; reads < 10; reads++) begin
                seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
                ok = seq.randomize() with {
                    cmd == READ;
                };
                assert (ok) else `uvm_fatal("SDRAM_TEST", "Randomization failed");
                seq.start(env.agent.sequencer);
            end
        end
    endtask

endclass : sdram_base_test
