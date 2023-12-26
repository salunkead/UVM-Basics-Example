//User defined phase- time consuming phase(task)
/*
1.virtual class uvm_task_phase extends uvm_phase  --> specifically for task based phases
 -> user can create custom task phases by extending uvm_task_phase.
 -> it provides mechanism to register tasks for execution within the phase.
 -> manages the execution of the registered task,ensuring proper sequencing and synchronization 
2.virtual task exec_task(uvm_component  	comp,uvm_phase  	phase)
 -> if the user defined phase is time consuming phase(i.e task ),you will have to use this task
3.static function uvm_phase get_uvm_schedule()
 -> Get the “UVM” schedule, which consists of the run-time phases that all components execute when participating in the “UVM” domain
 -> a phasing domain has the schedule,which is the list of the phases that are executed in order.the schedule consists of two types of phases
   1.build-in UVM phases 
   2.user defined phases
4.function void add(uvm_phase  	phase,uvm_phase with_phase 	 =  null,uvm_phase  	after_phase 	 =  	null,uvm_phase  	before_phase 	 =  	null)
  -> Build up a schedule structure inserting phase by phase, specifying linkage
  -> Phases can be added anywhere, in series or parallel with existing nodes
  -> phase	handle of singleton derived imp containing actual functor. by default the new phase is appended to the schedule
  -> with_phase	specify to add the new phase in parallel with this one
  -> after_phase	specify to add the new phase as successor to this one
  -> before_phase	specify to add the new phase as predecessor to this one
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class user_phase extends uvm_component;
  function new(string n="user_phase",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual task user_phase(uvm_phase phase);
  endtask
endclass

class my_phase extends uvm_task_phase;
  static local my_phase obj;
  function new(string n="my_phase");
    super.new(n);
  endfunction
  static function my_phase get;
    if(obj==null)
      obj=new("obj");
    return obj;
  endfunction
  task exec_task(uvm_component comp,uvm_phase phase);
    user_phase t;
    if($cast(t,comp))
      t.user_phase(phase);
  endtask
endclass

class driver extends user_phase;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    $display("build_phase is executed");
  endfunction
  function void connect_phase(uvm_phase phase);
    $display("connect_phase is executed");
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    $display("end_of_elaboration_phase is executed");
  endfunction
  task configure_phase(uvm_phase phase);
    $display("configure phase");
  endtask
  task main_phase(uvm_phase phase);
    $display("main_phase is executing");
  endtask
  task user_phase(uvm_phase phase);
    $display("user phase is executing...................");
  endtask
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  driver drv;
  uvm_phase schedule;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=driver::type_id::create("e",this);
    schedule=uvm_domain::get_uvm_schedule();
    schedule.add(my_phase::get,null,uvm_configure_phase::get(),uvm_main_phase::get); //here,we are scheduling our user defined phase,after configure phase and before main_phase
  endfunction
endclass

module top;
  initial run_test("test");
endmodule
