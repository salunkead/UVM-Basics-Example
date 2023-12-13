//Sub-phases in run phase
/*
1.pre_reset_phase:-   'virtual task pre_reset_phase( 	uvm_phase  	phase 	)'
  1.this phase occurs before reset signal is asserted.
  2.it allows components to perform any final preparation tasks before entering reset state
2.reset_phase:-       'virtual task reset_phase( 	uvm_phase  	phase 	)'
  1.this phase corresponds to the asserted state of the reset signal
  2.components initialize their internal state and waits for reset to be de-asserted
3.post_reset_phase:-  'virtual task post_reset_phase( 	uvm_phase  	phase 	)'
  1.this phase happens after the reset signal is de-asserted.
  2.components resume normal operation and start their main functionalities
4.pre_configure_phase:- 'virtual task pre_configure_phase( 	uvm_phase  	phase 	)'
  1.this phase is used to perform any necessary pre-configuration actions
5.configure_phase:-     'virtual task configure_phase( 	uvm_phase  	phase 	)'
  1.this phase is used to configure DUT with initial values
6.post_configure_phase:- virtual task post_configure_phase( 	uvm_phase  	phase 	)
  1.component can verify the configuration settings and perform any post-configuration task
7.pre_main_phase:-      'virtual task pre_main_phase( 	uvm_phase  	phase 	)'
  1.this phase happens before the main test stimuli starts
8.main_phase:-          'virtual task main_phase( 	uvm_phase  	phase 	)'
  1.components generate test stimuli,interact with DUT,verify the expected behavior
9.post_main_phase:-      'virtual task post_main_phase( 	uvm_phase  	phase 	)'
10.pre_shutdown_phase:-   'virtual task pre_shutdown_phase( 	uvm_phase  	phase 	)'
   1.this phase starts before the simulation starts settling down
11.shut_down_phase:-      'virtual task shutdown_phase( 	uvm_phase  	phase 	)'
   1.this phase allows the simulation to settle down and components to finalize their operation
12.post_shutdown_phase:-  'virtual task post_shutdown_phase( 	uvm_phase  	phase 	)'
*/


//Code-1 all the sub-phases of run phase and their flow of execution
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp extends uvm_component;
  `uvm_component_utils(comp)
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
  endfunction
  task pre_reset_phase(uvm_phase phase);
    `uvm_info(get_name(),"------------------------------------",UVM_NONE);
    `uvm_info(get_name(),"pre_reset_phase is executing..!",UVM_NONE);
  endtask
  task reset_phase(uvm_phase phase);
    `uvm_info(get_name(),"reset_phase is executing..!",UVM_NONE);
  endtask
  task post_reset_phase(uvm_phase phase);
    `uvm_info(get_name(),"post_reset_phase is executing..!",UVM_NONE);
  endtask
  task pre_configure_phase(uvm_phase phase);
    `uvm_info(get_name(),"pre_configure_phase is executing..!",UVM_NONE);
    
  endtask
  task configure_phase(uvm_phase phase);
    `uvm_info(get_name(),"configure_phase is executing..!",UVM_NONE);
  endtask
  task post_configure_phase(uvm_phase phase);
    `uvm_info(get_name(),"post_configure_phase is executing..!",UVM_NONE);
  endtask
  task pre_main_phase(uvm_phase phase);
    `uvm_info(get_name(),"pre_main_phase is executing..!",UVM_NONE);
  endtask
  task main_phase(uvm_phase phase);
    `uvm_info(get_name(),"main_phase is executing..!",UVM_NONE);
  endtask
  task post_main_phase(uvm_phase phase);
    `uvm_info(get_name(),"post_main_phase is executing..!",UVM_NONE);
  endtask
  task pre_shutdown_phase(uvm_phase phase);
    `uvm_info(get_name(),"pre_shutdown_phase is executing..!",UVM_NONE);
  endtask
  task shutdown_phase(uvm_phase phase);
    `uvm_info(get_name(),"shutdown_phase is executing..!",UVM_NONE);
  endtask
  task post_shutdown_phase(uvm_phase phase);
    `uvm_info(get_name(),"post_shutdown_phase is executing..!",UVM_NONE);
    `uvm_info(get_name(),"------------------------------------",UVM_NONE);
  endtask
endclass

module test;
  initial run_test("comp");
endmodule
