//Different type of request and response in sequence,sequencer,driver class

/*
-> uvm_sequencer class method
   1.task get (output REQ  t) -> Retrieves the next available item from a sequence.
   2.virtual task put (RSP  	t) -> Sends a response back to the sequence that issued the request.
-> uvm_sequence_item class method
   2.function void set_id_info( 	uvm_sequence_item  	item 	) -> Copies the sequence_id and transaction_id from the referenced item into the calling item.
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class trans extends uvm_sequence_item;
  `uvm_object_utils(trans)
  function new(string n="tr");
    super.new(n);
  endfunction
  rand bit[7:0]a,b;
endclass

class trans1 extends uvm_sequence_item;
  `uvm_object_utils(trans1)
  function new(string n="tr1");
    super.new(n);
  endfunction
   bit[8:0]y;
endclass

class seq extends uvm_sequence#(trans,trans1);
  `uvm_object_utils(seq)
  function new(string n="tr");
    super.new(n);
  endfunction
  trans tr;
  trans1 tr1;
  task body;
    tr=trans::type_id::create("tr");
    tr1=trans1::type_id::create("tr1");
    repeat(10)
      begin
        wait_for_grant();
        tr.randomize;
        send_request(tr);
        `uvm_info("seq",$sformatf("a=%0d and b=%0d",tr.a,tr.b),UVM_NONE);
        wait_for_item_done();
        get_response(tr1);
        `uvm_info("seq",$sformatf("y=%0d",tr1.y),UVM_NONE);
      end
  endtask
endclass

class driver extends uvm_driver#(trans,trans1);
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  trans tr;
  trans1 tr1;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr=trans::type_id::create("tr");
    tr1=trans1::type_id::create("tr1");
  endfunction
  task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get(tr);
        tr1.y=tr.a+tr.b;
        #2;
        tr1.set_id_info(tr);  ///request and response id's
        seq_item_port.put(tr1); 
        //seq_item_port.put_response(tr1); ///we can use put or put_response
      end
  endtask
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  function new(string n="agt",uvm_component p=null);
    super.new(n,p);
  endfunction
  driver drv;
  uvm_sequencer #(trans,trans1)sqr;
  seq sq;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=driver::type_id::create("drv",this);
    sqr=uvm_sequencer #(trans,trans1)::type_id::create("sqr",this);
    sq=seq::type_id::create("sq");
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    sq.start(sqr);
    phase.drop_objection(this);
  endtask
endclass

module top;
  initial run_test("agent");
endmodule
