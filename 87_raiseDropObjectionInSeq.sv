////How to raise objection and drop obejction in sequence class
/*
1.Methods used are as follows
  1. uvm_sequence_base class property:- 
     uvm_phase starting_phase;
  2. function uvm_phase get_starting_phase();
     Returns the ‘starting phase’.
     If non-null, the starting phase specifies the phase in which this sequence was started.
  3. function void set_starting_phase(uvm_phase  	phase);
     Sets the ‘starting phase’.
*/


//////////////////////////////
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
  uvm_phase starting_phase; 
  seq_item item;
  
  task pre_body;
    starting_phase=get_starting_phase();
    if(starting_phase !=null)
      begin
        starting_phase.raise_objection(this);
      end
    else
      begin
        $display("null access in pre body");
      end
  endtask
  
  task body();
    repeat(5)
      begin
        `uvm_do(item)
        $display("[Sequence] ","value sent to the driver : %0d",item.value);
        $display("-------------------------------------------------------");
      end
  endtask
  
   task post_body;
    if(starting_phase !=null)
      begin
        starting_phase.drop_objection(this);
      end
     else
       begin
         $display("null access in post body");
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
        $display("[Driver] ","data received from sequence : %0d at t=%0t",item.value,$time);
        #5;
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
    s.set_starting_phase(phase);
    s.start(e.agt.sqr);
  endtask
endclass

module top;
  initial run_test("test");
endmodule
