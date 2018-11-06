/*
* |---------------------------------------------------------------|
* | wb tlm                                                     |
* |                                                               |
* |---------------------------------------------------------------|
*/

typedef enum {
    WBREAD,
    WBWRITE
} wb_cmd;

class wb_tlm extends uvm_sequence_item;

    rand wb_cmd     cmd;
    rand int        data;
    rand int        addr;

    `uvm_object_utils_begin(wb_tlm)
        `uvm_field_enum(wb_cmd, cmd, UVM_DEFAULT)
    `uvm_object_utils_end


    function new (string name = "wb_seq");
        super.new(name);
    endfunction : new

endclass : wb_tlm
