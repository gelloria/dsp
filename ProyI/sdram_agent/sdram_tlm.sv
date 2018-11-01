/*
* |---------------------------------------------------------------|
* | SDRAM tlm                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

typedef enum {
    READ,
    WRITE
} sdram_cmd;

class sdram_tlm extends uvm_sequence_item;

    rand sdram_cmd  cmd;
    rand int        data;
    rand int        addr;

    `uvm_object_utils_begin(sdram_tlm)
        `uvm_field_enum(sdram_cmd, cmd, UVM_DEFAULT)
    `uvm_object_utils_end


    function new (string name = "sdram_seq");
        super.new(name);
    endfunction : new

endclass : sdram_tlm
