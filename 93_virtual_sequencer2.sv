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

class sequence2 extends uvm_sequence;
  `uvm_object_utils(sequence2)
  function new(string name="sequence2");
    super.new(name);
  endfunction
  task pre_body();
    uvm_test_done.raise_objection(this);
  endtask
  
  task body();
    bit[7:0] b;
    repeat(5)
      begin
        std::randomize(b) with {b%2!=0;};
        `uvm_info(get_full_name,$sformatf("from sequence_2 : b=%0d",b),UVM_LOW);
        #10;
      end
  endtask
  
  task post_body();
    uvm_test_done.drop_objection(this);
  endtask
endclass

class sequence1_sqr extends uvm_sequencer;
  `uvm_component_utils(sequence1_sqr)
  function new(string name="sequence1_sqr",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void display();
    `uvm_info(get_full_name,$psprintf("sequence1 sequncer..!"),UVM_LOW);
  endfunction
  
endclass

class sequence2_sqr extends uvm_sequencer;
   `uvm_component_utils(sequence2_sqr)
  function new(string name="sequence2_sqr",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void display();
    `uvm_info(get_full_name,$psprintf("sequence2 sequncer..!"),UVM_LOW);
  endfunction
  
endclass

class virtual_sqr extends uvm_sequencer;
   `uvm_component_utils(virtual_sqr)
  sequence1_sqr s1;
  sequence2_sqr s2;
  function new(string name="virtual_sqr",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s1=sequence1_sqr::type_id::create("s1",this);
    s2=sequence2_sqr::type_id::create("s2",this);
  endfunction
  
endclass

class virtual_seq extends uvm_sequence;
  `uvm_object_utils(virtual_seq)
  `uvm_declare_p_sequencer(virtual_sqr)
  function new(string name="virtual_seq");
    super.new(name);
  endfunction
  sequence1 seq1;
  sequence2 seq2;
  
  task body();
    seq1=sequence1::type_id::create("seq1");
    seq2=sequence2::type_id::create("seq2");
    
    fork
      p_sequencer.s1.display();
      seq1.start(p_sequencer.s1);
      p_sequencer.s2.display();
      seq2.start(p_sequencer.s2);
    join
  endtask
endclass


class agent1 extends uvm_agent;
   `uvm_component_utils(agent1)
  sequence1_sqr sqr;
  function new(string name="agent1",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr=sequence1_sqr::type_id::create("sqr",this);
  endfunction
endclass

class agent2 extends uvm_agent;
  `uvm_component_utils(agent2)
   sequence2_sqr sqr;
  function new(string name="agent2",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr=sequence2_sqr::type_id::create("sqr",this);
  endfunction
endclass

class env extends uvm_env;
   `uvm_component_utils(env)
  agent1 a1;
  agent2 a2;
  virtual_sqr sqr;
  function new(string name="env",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a1=agent1::type_id::create("a1",this);
    a2=agent2::type_id::create("a2",this);
    sqr=virtual_sqr::type_id::create("sqr",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sqr.s1=a1.sqr;
    sqr.s2=a2.sqr;
  endfunction
  
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  env e;
  virtual_seq seq;
  function new(string name="test",uvm_component parent=null);
    super.new(name,parent);
    e=env::type_id::create("e",this);
    seq=virtual_seq::type_id::create("seq");
  endfunction
  
  task run_phase(uvm_phase phase);
    seq.start(e.sqr);
  endtask
  
endclass

module top;
  initial
    begin
      run_test("test");
    end
endmodule
