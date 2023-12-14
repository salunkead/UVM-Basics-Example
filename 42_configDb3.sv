//can we access config db in a object type class?

`include "uvm_macros.svh"
import uvm_pkg::*;
class trans extends uvm_sequence;
  `uvm_object_utils(trans)
  function new(string n="trans");
    super.new(n);
  endfunction
  int a;
  task body;
    if(uvm_config_db#(int)::get(null,"","key",a))
      $display("value of a=%0d",a);
    else
      $display("unable to acces cofig db");
  endtask
endclass
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
  endfunction
  trans tr;
  uvm_sequencer#(trans)sqr;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr=trans::type_id::create("tr");
    sqr=uvm_sequencer#(trans)::type_id::create("sqr",this);
  endfunction
  task run_phase(uvm_phase phase);
    tr.start(sqr);
  endtask
endclass

module test;
  initial
    begin
      uvm_config_db#(int)::set(null,"*","key",52);
      run_test("comp1");
    end
endmodule
