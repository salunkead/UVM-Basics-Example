//User defined NON-TIME CONSUMMING PHASE (function)
/*
1.classes and Methods used are as follows:-
  1.virtual class uvm_topdown_phase extends uvm_phase -> if you want to create user defined phase which executes top down then you need to use this class
  2.virtual function void exec_func(uvm_component  	comp,uvm_phase  	phase) -> used for user defined non-time consuming phase(if your phase is function then you need to use this callback)
  3.static function uvm_phase get_uvm_schedule() -> Get the “UVM” schedule, which consists of the run-time phases that all components execute when participating in the “UVM” domain.
  4.static function uvm_domain get_common_domain() -> Phases in the “common” domain are build, connect, end_of_elaboration, start_of_simulation, run, extract, check, report, and final.
  5.function uvm_phase find(uvm_phase  	phase,bit  	stay_in_scope 	 =  	1) -> Locate the phase node with the specified phase IMP and return its handle.  With stay_in_scope set, searches only within this phase’s schedule or domain.
  6.function void add(uvm_phase  	phase,uvm_phase  	with_phase 	 =  	null,uvm_phase  	after_phase 	 =  	null,uvm_phase  	before_phase 	 =  	null) -> Build up a schedule structure inserting phase by phase, specifying linkage
*/


//Example:-
`include "uvm_macros.svh"
import uvm_pkg::*;
class user_defined_phase extends uvm_component;
  `uvm_component_utils(user_defined_phase)
  function new(string n="user",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void my_phase(uvm_phase phase);
  endfunction
endclass

class top_down extends uvm_topdown_phase;
  static local top_down top;
  function new(string n="top_down");
    super.new(n);
  endfunction
  static function top_down get();
    if(top==null)
      top=new("top");
    return top;
  endfunction
  function void exec_func(uvm_component comp,uvm_phase phase);
    user_defined_phase user;
    if($cast(user,comp))
      user.my_phase(phase);
  endfunction
endclass

class driver extends user_defined_phase;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("[driver] ","Build phase of driver component");
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("[driver] ","Connect phase of driver component");
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("[driver] ","end_of_elaboration_phase of driver component");
  endfunction
  function void my_phase(uvm_phase phase);
    super.my_phase(phase);
    $display("[driver] ","user defined phase of driver component......!");
  endfunction
endclass

class monitor extends user_defined_phase;
  `uvm_component_utils(monitor)
  function new(string n="mon",uvm_component p=null);
    super.new(n,p);
  endfunction
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     $display("[monitor] ","Build phase of monitor  component");
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("[monitor] ","Connect phase of monitor  component");
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("[monitor] ","end_of_elaboration_phase of monitor  component");
  endfunction
  function void my_phase(uvm_phase phase);
    super.my_phase(phase);
    $display("[monitor] ","user defined phase of monitor  component......!");
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  uvm_phase p1,p2,p3;
  uvm_domain dm;
  driver drv;
  monitor mon;
  function void build_phase(uvm_phase phase);
    drv=driver::type_id::create("drv",this);
    mon=monitor::type_id::create("mon",this);
    p1=uvm_domain::get_uvm_schedule();
    dm=uvm_domain::get_common_domain();
    p2=dm.find(uvm_build_phase::get());
    p3=dm.find(uvm_connect_phase::get());
    p1.add(top_down::get(),null,p2,p3);
  endfunction
endclass

module op;
  initial run_test("test");
endmodule
