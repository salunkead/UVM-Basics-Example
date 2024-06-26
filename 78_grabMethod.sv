//grab() and ungrab() method of uvm_sequence_base class
/*
1.task grab(uvm_sequencer_base  	sequencer 	 =  	null)
 -> Requests a lock on the specified sequencer. 
 -> If no argument is supplied, the lock will be requested on the current default sequencer.
2.function void ungrab(uvm_sequencer_base  	sequencer 	 =  	null)
 -> Removes any locks or grabs obtained by this sequence on the specified sequencer.  
 -> If sequencer is null, then the unlock will be done on the current default sequencer.
3.Difference in lock and grab method:-
  1.the lock method puts a lock request at the back of the sequencer queue
  2.the grab method is similar to lock,but puts a grab request at the front of the arbitration queue,it immediately takes control
  by overriding other sequence priority
  3.the grab request is serviced more quickly compoared to lock
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class trans extends uvm_sequence_item;
  `uvm_object_utils(trans)
  function new(string n="tr");
    super.new(n);
  endfunction
  rand bit[7:0]in;
endclass

class seq1 extends uvm_sequence #(trans);
  `uvm_object_utils(seq1)
  function new(string n="sq1");
    super.new(n);
  endfunction
  trans tr;
  task body();
    this.grab();
    tr=trans::type_id::create("tr");
    repeat(5)
      begin
        start_item(tr);
        tr.randomize with {in%2==0;};
        finish_item(tr);
      end
    this.ungrab();
  endtask
endclass

class seq2 extends uvm_sequence #(trans);
  `uvm_object_utils(seq2)
  function new(string n="sq2");
    super.new(n);
  endfunction
  trans tr;
  task body();   
    tr=trans::type_id::create("tr");
     this.grab();
    repeat(5)
      begin
        start_item(tr);
        tr.randomize with {in%2!=0;};
        finish_item(tr);
      end
    this.ungrab();
  endtask
endclass

class driver extends uvm_driver #(trans);
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  trans tr;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr=trans::type_id::create("tr");
  endfunction
  task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(tr);
        if(tr.in%2==0)
          begin
            `uvm_info(get_type_name(),$sformatf("data from sequence1 -> in: %0d",tr.in),UVM_NONE);
          end
        else
          begin
            `uvm_info(get_type_name(),$sformatf("data from sequence2 -> in: %0d",tr.in),UVM_NONE);
          end
        seq_item_port.item_done();
      end
  endtask
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  function new(string n="agt",uvm_component p=null);
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
  `uvm_component_utils(env)
  function new(string n="e",uvm_component p=null);
    super.new(n,p);
  endfunction
  agent agt;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt=agent::type_id::create("agt",this);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  env e;
  seq1 sq1;
  seq2 sq2;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e=env::type_id::create("e",this);
    sq1=seq1::type_id::create("sq1");
    sq2=seq2::type_id::create("sq2");
  endfunction
  task run_phase(uvm_phase phase);
    fork
      sq1.start(e.agt.sqr);
      sq2.start(e.agt.sqr);
    join
  endtask
endclass

module top;
  initial run_test("test");
endmodule
