//sequence library class
/*
1.sequence library is the collection of reusable sequences that can be managed,selected,and executed in a controlled manner to create diverse and comprehensive test scenarios.
2.Methods and variables is uvm_sequence_library class
  1. function new(string  	name 	 =  	"")
  2. uvm_sequence_lib_mode selection_mode; -> Specifies the mode used to select sequences for execution
    modes available are:-
    1. UVM_SEQ_LIB_RAND
    2. UVM_SEQ_LIB_RANDC 
  3. int unsigned min_random_count; -> Sets the minimum number of items to execute
  4. int unsigned max_random_count; -> Sets the maximum number of items to execute.
  5. sequence registeration methods:-
    1. static function void add_typewide_sequence(uvm_object_wrapper  	seq_type) 
    -> Registers the provided sequence type with this sequence library type
    -> Scope:- typ-wide,sequence can be used with any sequencer of the specified type
    2. function void add_sequence(uvm_object_wrapper  	seq_type) 
    -> Registers the provided sequence type with this sequence library type
    -> Scope:- instance-specific,the sequence is available for designated sequencer
  6. `uvm_sequence_library_utils(TYPE) :- Registers sequences with a library
    
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class trans extends uvm_sequence_item;
  `uvm_object_utils(trans)
  function new(string n="trans");
    super.new(n);
  endfunction
  rand bit[7:0] data1,data2;
endclass

class seq1 extends uvm_sequence #(trans);
  `uvm_object_utils(seq1)
  function new(string n="seq1");
    super.new(n);
  endfunction
  trans tr;
  task body();
    tr=trans::type_id::create("tr");
    start_item(tr);
    tr.randomize with {tr.data1==2*tr.data2;};
    finish_item(tr);
  endtask
endclass

class seq2 extends uvm_sequence #(trans);
  `uvm_object_utils(seq2)
  function new(string n="seq2");
    super.new(n);
  endfunction
   trans tr;
  task body();
    tr=trans::type_id::create("tr");
    start_item(tr);
    tr.randomize with {tr.data1==3*tr.data2;};
    finish_item(tr);
  endtask
endclass

class seq3 extends uvm_sequence #(trans);
  `uvm_object_utils(seq3)
  function new(string n="seq3");
    super.new(n);
  endfunction
   trans tr;
  task body();
    tr=trans::type_id::create("tr");
    start_item(tr);
    tr.randomize with {tr.data1==4*tr.data2;};
    finish_item(tr);
  endtask
endclass

class driver extends uvm_driver #(trans);
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  trans tr;
  task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(tr);
        if(tr.data1==2*tr.data2)
          begin
          $display("[Driver], ","value from sequence1 is : data1 = %0d and data2 = %0d",tr.data1,tr.data2); end
        else if(tr.data1==3*tr.data2) begin
          $display("[Driver], ","value from sequence2 is : data1 = %0d and data2 = %0d",tr.data1,tr.data2); end
        else begin
          $display("[Driver], ","value from sequence3 is : data1 = %0d and data2 = %0d",tr.data1,tr.data2); end
        #10;
        seq_item_port.item_done();
      end
  endtask
endclass

class agent extends uvm_agent;
   `uvm_component_utils(agent)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  driver drv;
  uvm_sequencer #(trans) sqr;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=driver::type_id::create("drv",this);
    sqr=uvm_sequencer #(trans)::type_id::create("sqr",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass

class env extends uvm_env;
   `uvm_component_utils(env )
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  agent agt;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt=agent::type_id::create("agt",this);
  endfunction
endclass

class uvm_seq_lib extends uvm_sequence_library;
  `uvm_object_utils(uvm_seq_lib)
  `uvm_sequence_library_utils(uvm_seq_lib)
  function new(string n="lib");
    super.new(n);
    add_sequence(seq1::get_type());
    add_sequence(seq2::get_type());
    add_sequence(seq3::get_type());
  endfunction
  
endclass

class test extends uvm_test;
   `uvm_component_utils(test )
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  env e;
  uvm_seq_lib lib;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e=env::type_id::create("e",this);
    lib=uvm_seq_lib::type_id::create("lib");
    lib.selection_mode = UVM_SEQ_LIB_RANDC;
    lib.min_random_count=5;
    lib.max_random_count=10;
    void'(lib.randomize());
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    lib.start(e.agt.sqr);
    phase.drop_objection(this);
  endtask
endclass

module top;
  initial run_test("test");
endmodule
