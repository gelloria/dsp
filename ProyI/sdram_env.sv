/*
* |---------------------------------------------------------------|
* | SDRAM Environment                                             |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_env extends uvm_env;

    CAS_agent           cas;
    sdram_agent         agent;
    sdram_scoreboard    scb;


    function new (string name = "env");
        super.new(name);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cas = CAS_agent::type_id::create("cas", this);
        agent = sdram_agent::type_id::create("agent", this);
        scb = sdram_scoreboard::type_id::create("scb", this);
    endfunction


    function void connect_phase(uvm_phase phase);
        agent.monitor.ch_out.connect(scb.fifo.analysis_export);
    endfunction


    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        phase.drop_objection(this);
    endtask

endclass: sdram_env
