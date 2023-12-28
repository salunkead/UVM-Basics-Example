//Implementaion of callback in object type class

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class trans extends uvm_sequence_item;
  `uvm_object_utils(trans)
  function new(string n="tr");
    super.new(n);
  endfunction
  rand bit[7:0]num;
endclass
class callback extends uvm_callback;
  `uvm_object_utils(callback)
  function new(string n="call");
    super.new(n);
  endfunction
  task Method1(trans tr);
    $display("[Callback], ","Method 1 of callback class");
    tr.randomize() with {tr.num%2==0;};
    $display("[Callback], ","num: %0d",tr.num);
  endtask
endclass

class seq extends uvm_sequence #(trans);
  `uvm_object_utils(seq)
  `uvm_register_cb(seq,callback)
  function new(string n="seq");
    super.new(n);
  endfunction
  trans tr;
  task pre_body();
    tr=trans::type_id::create("tr");
    start_item(tr);
    tr.randomize with {tr.num%2!=0;};
    $display("[Seq], ","num : %0d",tr.num);
    finish_item(tr);
  endtask
  task body();
    tr=trans::type_id::create("tr");
    start_item(tr);
    `uvm_do_callbacks(seq,callback,Method1(tr))
    finish_item(tr);
  endtask
endclass

class driver extends uvm_driver #(trans);
  `uvm_component_utils(driver)
  function new(string n="driver",uvm_component p=null);
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
        if(tr.num%2==0)
          begin
            $display("[Driver], ","value from callback class : %0d",tr.num);
          end
        else
          begin
            $display("[Driver], ","value from sequence class : %0d",tr.num);
          end
        $display("-----------------------------");
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
    sqr= uvm_sequencer #(trans)::type_id::create("sqr",this);
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
  seq sq;
  callback call;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e=env::type_id::create("e",this);
    sq=seq::type_id::create("sq");
    call=callback::type_id::create("call");
    uvm_callbacks #(seq,callback)::add(sq,call);
  endfunction
  task run_phase(uvm_phase phase);
    sq.start(e.agt.sqr);
  endtask
endclass

module top;
  initial run_test("test");
endmodule
