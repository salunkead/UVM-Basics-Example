//Sequence -> sequencer -> driver communication
/*
1.uvm_sequence_base class:-
  1.sequence item execution methods:-
    1.virtual task wait_for_grant(int item_priority 	 =-1 ,bit lock_request = 0) 
      -> sequence initiates request to current sequencer by calling this method
      -> typically it blocks until the grant come from sequencer
      -> item_priority- purpose:- assigns priority level to the sequence item(higher the value,higher will be the priority)
      -> lock_request- purpose:- signals a request to exclusively lock the driver (1 - to lock,0 to unlock)
  2.virtual function void send_request(uvm_sequence_item  request,bit  	rerandomize 	 =  	0)
      -> This call will send the request item to the sequencer, which will forward it to the driver.
      -> it can be called after wait_for_grant method i.e after obtaining grant from the sequencer.
      -> it typically blocks until the sequencer forwards the item to the driver,ensuring synchronization
      -> If the rerandomize bit is set, the item will be randomized before being sent to the driver.
  3.virtual task wait_for_item_done( 	int  	transaction_id 	 =  	-1 	)
      -> it is called after the send_request method.
      -> it blocks the sequence execution until the driver signals completion of previously sent transaction item.
      -> ensures orderly progress:- this synchronization prevents the sequence from prematurly generating the new item.
      -> blocking nature:- the sequence remain idle within wait_for_item_done until the driver indicates completion.

2.uvm_sequencer class:-
   1.class uvm_sequencer #(type REQ = uvm_sequence_item,RSP = REQ) extends uvm_sequencer_param_base #(REQ, RSP)
   2.Sequencer interface methods:-
      1.virtual task get_next_item (output REQ  t) ->  it is used to retrieve an item from the sequencer's queue
      2.virtual function void item_done (RSP item = null) -> it is used to signal completion back to the sequence
   3. seq_item_export
      -> it is a variables in uvm_sequencer class that provides access to the sequencer's implementations of the sequencer interface
      -> the sequencer interface is used to communicate with the driver,which requests and responds sequence item from the driver
3.uvm_driver class:-
  -> class uvm_driver #(type  	REQ 	 =  	uvm_sequence_item,type  	RSP 	 =  	REQ) extends uvm_component
  -> ports:-
      -> seq_item_port :- Derived driver classes should use this port to request items from the sequencer.

*/


//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class seq_item extends uvm_sequence_item;
  `uvm_object_utils(seq_item)
  function new(string n="seq_item");
    super.new(n);
  endfunction
  rand bit [7:0]value;
endclass

class seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq)
  function new(string n="seq");
    super.new(n);
  endfunction
  seq_item item;
  task body();
    item=seq_item::type_id::create("item");
    item.randomize();
    $display("[Sequence] ","request to sequencer by calling wait_for_grant() method");
    wait_for_grant();
    $display("[Sequence] ","Got grant from the sequencer");
    send_request(item);
    $display("[Sequence] ","sequence item sent to the sequencer");
    $display("[Sequence] ","value sent : %0d",item.value);
    $display("[Sequence] ","waiting for item done");
    wait_for_item_done();
    $display("[Sequence] ","got item done from driver via sequencer");
  endtask
endclass

class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  seq_item item;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item=seq_item::type_id::create("item");
  endfunction
  task run_phase(uvm_phase phase);
    seq_item_port.get_next_item(item);
    $display("[Driver] ","Pulling sequence_item from sequencer's queue");
    $display("[Driver] ","value got: %0d",item.value);
    $display("[Driver] ","sending item done");
    seq_item_port.item_done();
    $display("[Driver] ","signaled completion to the sequence by calling item_done");
  endtask
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  function new(string n="agent",uvm_component p=null);
    super.new(n,p);
  endfunction
  driver drv;
  uvm_sequencer #(seq_item) sqr;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=driver::type_id::create("drv",this);
    sqr=uvm_sequencer #(seq_item)::type_id::create("sqr",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  function new(string n="env",uvm_component p=null);
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
  seq s;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e=env::type_id::create("e",this);
    s=seq::type_id::create("s");
  endfunction
  task run_phase(uvm_phase phase);
    s.start(e.agt.sqr);
  endtask
endclass

module top;
  initial run_test("test");
endmodule
