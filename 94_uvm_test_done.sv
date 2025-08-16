//uvm_test_done handle

/*
uvm_test_done is a global objection handle provided by UVM.
1. It is of type uvm_objection and defined in the uvm_root class.
By default, when you raise/drop objections using uvm_test_done, it controls the end_of_test phase (so the test will not end until all objections are dropped).

How it is used in a sequence
In a sequence, you don’t directly have access to the phase objections (like in components with phase.raise_objection(this)).
So, UVM provides uvm_test_done as a shortcut handle for sequences.

Key points to remember
1. uvm_test_done is global, so you can use it anywhere (sequence, test, etc.).
2. In components (like env, test), you typically use phase.raise_objection(this) → more structured.
3. In sequences, use uvm_test_done.raise_objection(this) → since sequences are not components and don’t have phase arguments.

If you forget to drop an objection → test will hang forever.
👉 So in summary:

phase.raise_objection() → used inside UVM components.
uvm_test_done.raise_objection() → used inside UVM sequences.

// from uvm_pkg.sv
uvm_objection uvm_test_done = new("global_test_done");

*/
//Example:

`include "uvm_macros.svh"
import uvm_pkg::*;

class sequence1 extends uvm_sequence;
  `uvm_object_utils(sequence1)
  function new(string name="sequence1");
    super.new(name);
  endfunction
  task pre_body();
    uvm_test_done.raise_objection(this);
  endtask
  
  task body();
    bit[7:0] a;
    repeat(5)
      begin
        std::randomize(a) with {a%2==0;};
        `uvm_info(get_full_name,$sformatf("from sequence_1 : a=%0d",a),UVM_LOW);
        #10;
      end
  endtask
  
  task post_body();
    uvm_test_done.drop_objection(this);
  endtask
endclass



module top;
  sequence1 seq;
  uvm_sequencer sqr;
  initial
    begin
      seq=new("seq");
      sqr=new("sqr",null);
      seq.start(sqr);
    end
endmodule
