class CAS_sequence extends uvm_sequence #(CAS_tlm);

    rand int    cfg_sdr_cas;

    constraint memspace {
        cfg_sdr_cas inside {[1:2]};
    }

    `uvm_object_utils(CAS_sequence)

    function new(string name = "");
        super.new(name);
    endfunction: new

    task body();
        req = CAS_tlm::type_id::create(.name("req"), .contxt(get_full_name()));
        req.cfg_sdr_cas = cfg_sdr_cas;
        start_item(req);
        finish_item(req);
    endtask

endclass
