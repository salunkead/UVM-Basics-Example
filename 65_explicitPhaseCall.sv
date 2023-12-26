//Calling phases explicitly without using run_test() method
/*
1.the phase class defines everything about phases 
2.class uvm_phase extends uvm_object 
3.method used for explicit call
  function new(string  	name 	 =  	"uvm_phase",uvm_phase_type  	phase_type 	 =  	UVM_PHASE_SCHEDULE,uvm_phase  	parent 	 =  	null)
*/

//Example- we should not call phases explicitly,it may result into an unexpected behavior
//simulator throws warning:- [UVM_DEPRECATED] build()/build_phase() has been called explicitly, outside of the phasing system. This usage of build is deprecated and may lead to unexpected
`include "uvm_macros.svh"
import uvm_pkg::*;

class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  uvm_phase phase;
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
    phase=new;
    build_phase(phase);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("Build phase of comp1");
    connect_phase(phase);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("connect phase of comp1");
    end_of_elaboration_phase(phase);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("end_of_elaboration_phase of comp1");
    start_of_simulation_phase(phase);
  endfunction
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    $display("start_of_simulation_phase of comp1");
  endfunction
endclass

module test;
  comp1 c;
  initial
    begin
      c=comp1::type_id::create("c",null);
    end
endmodule

