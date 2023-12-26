//Jump method of uvm_phase class
/*
1.method used:-
 function void jump( 	uvm_phase  	phase 	) -> Jump to a specified phase.
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp extends uvm_component;
  `uvm_component_utils(comp)
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("Executing build_phase");
    phase.jump(uvm_end_of_elaboration_phase::get());
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("Executing connect_phase");
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("Executing end_of_elaboration_phase");
  endfunction
  task run_phase(uvm_phase phase);
    $display("Executing run_phase");
  endtask
endclass

module test;
  initial
    begin
      run_test("comp");
    end
endmodule
