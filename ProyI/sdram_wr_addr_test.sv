/*
* |---------------------------------------------------------------|
* | Basic Test                                                    |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_wr_addr_test extends sdram_base_test;

   `uvm_component_utils(sdram_wr_addr_test)

    function new (string name="test", uvm_component parent=null);
        super.new (name, parent);
    endfunction

    task main_phase(uvm_phase phase);
       phase.raise_objection(.obj(this));
       do_wr();
       phase.drop_objection(.obj(this));
    endtask

    task do_wr();
       bit ok;
       int addr_i;

       for(int loops = 0; loops < 10; loops++) begin
           addr_i = $urandom_range(0,12'hFFF);
           seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
           ok = seq.randomize() with {
               addr == addr_i;
               cmd  == WRITE;
           };
           assert (ok) else `uvm_fatal("SDRAM_TEST", "Randomization failed");
           seq.start(env.agent.sequencer);

           #1000ns;

           seq = sdram_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
           ok = seq.randomize() with {
               addr == addr_i;
               cmd  == READ;
           };
           assert (ok) else `uvm_fatal("SDRAM_TEST", "Randomization failed");
           seq.start(env.agent.sequencer);
       end
    endtask

endclass : sdram_wr_addr_test
