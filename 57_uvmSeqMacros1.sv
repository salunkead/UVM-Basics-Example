//UVM Sequence Macros :- `uvm_do(Item/Seq)
/*
1.UVM sequence macros are the set of predefined functions that can be used to create,start,and send sequence item or sequences in UVM.
2.Following steps are done in sequence class:-
  1.create item/create request
  2.wait for grant
  3.randomize the request
  4.send_request
  5.wait_for_item_done
  6.get_response
3.`uvm_do(Item/Seq)
   1.this macro takes sequence_item or sequence as an argument and executes it with default sequencer.
   2.On calling `uvm_do() the above-defined 6 steps will be executed automatically.
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
    repeat(5)
      begin
        `uvm_do(item)
        $display("[Sequence] ","value sent to the driver : %0d",item.value);
        $display("-------------------------------------------------------");
      end
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
    forever
      begin
        seq_item_port.get_next_item(item);
        $display("[Driver] ","data received from sequence : %0d",item.value);
        seq_item_port.item_done();
      end
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
