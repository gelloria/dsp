/*
* |---------------------------------------------------------------|
* | SDRAM tlm                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

typedef enum {
    RESET,
    READ,
    WRITE
} sdram_cmd;

class sdram_tlm extends uvm_sequence_item;

    rand sdram_cmd  cmd;
    rand integer    data;
    rand int        addr;

    `uvm_object_utils_begin(sdram_tlm)
        `uvm_field_enum(sdram_cmd, cmd, UVM_DEFAULT)
    `uvm_object_utils_end


    function new (string name = "sdram_seq");
        super.new(name);
    endfunction : new

    function string print();
        return $psprintf("%s, addr: 0x%0h, data: 0x%0h", cmd.name, addr, data);
    endfunction

endclass : sdram_tlm
