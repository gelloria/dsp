/*
* |---------------------------------------------------------------|
* | SDRAM tlm                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

class CAS_tlm extends uvm_sequence_item;

    rand integer    cfg_sdr_cas;
    rand int        cycles;

    `uvm_object_utils_begin(CAS_tlm)
    `uvm_object_utils_end


    function new (string name = "CAS_seq");
        super.new(name);
    endfunction : new

    function string print();
        return $psprintf("CAS config: 0x%0d", cfg_sdr_cas);
    endfunction

endclass : CAS_tlm
