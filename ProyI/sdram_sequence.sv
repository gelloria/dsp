class sdram_sequence extends uvm_sequence #(sdram_tlm);

    rand sdram_cmd  cmd;
    rand int        data;
    rand int        addr;

    constraint memspace {
        addr inside {[0:12'hFFF]};
    }

    `uvm_object_utils(sdram_sequence)

    function new(string name = "");
        super.new(name);
    endfunction: new

    task body();
        req = sdram_tlm::type_id::create(.name("req"), .contxt(get_full_name()));
        req.cmd = cmd;
        req.data = data;
        req.addr = addr;
        start_item(req);
        finish_item(req);
    endtask

endclass
