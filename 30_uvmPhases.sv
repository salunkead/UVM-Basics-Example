//Phases in uvm_component class
/*
1.Phases and their uses:-
  1.build phase:-             'virtual function void build_phase(uvm_phase phase)'
    1.This phase is mainly used for instantiating sub_components,allocating memory and setting initial configuration values.
  2.connect_phase:-           'virtual function void connect_phase(uvm_phase phase)'
    1.This phase focuses on connecting the component to other component in the verification environment
    2.this involves connecting ports,exports and other communication channels to ensure proper data flow
  3.end_of_elaboration_phase:-      'virtual function void end_of_elaboration_phase(uvm_phase phase)'
    1.this phase happens after all the components have been build and connected.
    2.this phase allows you to do any adjustments before simulation starts
  4.start_of_simulation_phase:-     'virtual function void start_of_simulation_phase(uvm_phase phase)'
    1.you can set global parameters or configuration settings that are applicable to entire testbench ex-setting verbosity levels,debug flags or other global parameters
    2.initializing the DUT or any interface model.this ensures that the DUT is in correct state before any test-specific simulus is applied
  5.run_phase:-      'virtual task run_phase(uvm_phase phase)'
    1.this is the longest phase where component's main activity and verification tasks take place
    2.components process stimuli,generate response and check for expected behavior
  6.extract_phase:-     'virtual function void extract_phase(uvm_phase phase)'
    1.this phase allows components to extract and analyze data collected during the run phase.
    2.this data can be used for coverage analysis,verification reports and debugging purpose.
  7.check_phase:-      'virtual function void check_phase(uvm_phase phase)'
    1.it is used for verification checks and assertions.
    2.components can verify if their behavior met the expected outcomes and raise any errors or failures.
  8.report_phase:-     'virtual function void report_phase(uvm_phase phase)'
    1.this phase focuses on generating reports and logs summarizing the verification results
    2.this information can be used to assess the overall success of the verification effort.
  9.final_phase:-      'virtual function void final_phase(uvm_phase phase)'
    1.phase signifies the end of simulation and allows components to perform any final cleanup tasks.
    2.this may involve closing file,releasing resource.
*/

//Code-1 execution flow of all the phases
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp extends uvm_component;
  `uvm_component_utils(comp)
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(),"Build-phase is executing..!",UVM_NONE);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name(),"Connect-phase is executing..!",UVM_NONE);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_name(),"end_of_elaboration_phase is executig..!",UVM_NONE);
  endfunction
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(get_name(),"start_of_simulation_phase is executing ..!",UVM_NONE);
  endfunction
  task run_phase(uvm_phase phase);
    `uvm_info(get_name(),"run_phase is executing..!",UVM_NONE);
  endtask
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_name(),"extract_phase is executing..!",UVM_NONE);
  endfunction
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(get_name(),"check_phase is executing..!",UVM_NONE);
  endfunction
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_name(),"report_phase is executing..!",UVM_NONE);
  endfunction
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(get_name(),"final_phase is executing..!",UVM_NONE);
  endfunction
endclass

module test;
  initial run_test("comp");  //uvm_root class method ->virtual task run_test(string test_name="") -> triggers the phases within the specified class
endmodule
