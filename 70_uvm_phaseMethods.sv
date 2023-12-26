//uvm_phase class methods
/*
1.function string get_domain_name() -> Returns the domain name associated with this phase node
2.function int get_run_count() -> Accessor to return the integer number of times this phase has executed
3.virtual function string get_full_name() -> Returns the full path from the enclosing domain down to this node.  
4.function uvm_phase get_parent() -> Returns the parent schedule node, if any, for hierarchical graph traversal
5.function uvm_phase get_schedule( 	bit  	hier 	 = ) -> Returns the topmost parent schedule node, if any, for hierarchical graph traversal
6.function string get_schedule_name( 	bit  	hier 	 = ) -> Returns the schedule name associated with this phase node
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    $display("build phase of comp1");
    $display("%s",phase.get_domain_name);
    $display("count=%0d",phase.get_run_count);
    $display("full_name=%0s",phase.get_full_name());
    $display("%p",phase.get_parent());
    $display("%p",phase.get_schedule());
    $display("%0s",phase.get_schedule_name());
    $display("-------------------------------------");
  endfunction
  function void connect_phase(uvm_phase phase);
    $display("connect phase of comp1");
    $display("%s",phase.get_domain_name);
    $display("count=%0d",phase.get_run_count);
    $display("full_name=%0s",phase.get_full_name());
    $display("%p",phase.get_parent());
    $display("%p",phase.get_schedule());
    $display("%0s",phase.get_schedule_name());
    $display("-------------------------------------");
  endfunction
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10;
    $display("reset phase of comp1 at t=%0t",$time);
    $display("%s",phase.get_domain_name);
    $display("count=%0d",phase.get_run_count);
    $display("full_name=%0s",phase.get_full_name());
    $display("%p",phase.get_parent());
    $display("%p",phase.get_schedule());
    $display("%0s",phase.get_schedule_name());
    $display("-------------------------------------");
    phase.drop_objection(this);
  endtask
  task main_phase(uvm_phase phase);
    phase.raise_objection(.obj(this));
    #20;
    $display("main phase of comp1 at t=%0t",$time);
    $display("%s",phase.get_domain_name);
    $display("count=%0d",phase.get_run_count);
    $display("full_name=%0s",phase.get_full_name());
    $display("%p",phase.get_parent());
    $display("%p",phase.get_schedule());
    $display("%0s",phase.get_schedule_name());
    $display("-------------------------------------");
    phase.drop_objection(.obj(this));
  endtask
endclass

module top;
  initial run_test("comp1");
endmodule
