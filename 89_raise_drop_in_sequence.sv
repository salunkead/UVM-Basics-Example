//raise and drop objection in uvm_sequence class

`include "uvm_macros.svh"
import uvm_pkg::*;

class seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(seq)
  function new(string name="test_seq");
    super.new(name);
  endfunction
  
  task pre_body();
    uvm_test_done.raise_objection(this);
  endtask
  
  task body;
    //code to be ececuted
    
    $display("In body task...!");
  endtask
  
  task post_body;
    uvm_test_done.drop_objection(this);
  endtask
endclass

module top;
  seq seq_handle;
  uvm_sequencer #(uvm_sequence_item) sqr;
  
  initial
    begin
      seq_handle=new("seq_handle");
      sqr=new("sqr");
      seq_handle.start(sqr);
    end
endmodule
