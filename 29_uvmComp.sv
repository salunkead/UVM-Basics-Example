//uvm_component and creating UVM TREE
/*
1.some of the methods of uvm_component class are as follows:-
  1.function new (string name,uvm_component parent)
    1.Creates a new component with the given leaf instance name and handle to its parent.  
    2.If the component is a top-level component (i.e. it is created in a static module or interface), parent should be null.
    3.If parent is null, then the component will become a child of the implicit top-level component, uvm_top.
  2.Methods used to access information about the component hierarchy, i.e., topology.
    1.virtual function uvm_component get_parent () ->Returns a handle to this component’s parent, or null if it has no parent.
    2.virtual function string get_full_name ()  ->Returns the full hierarchical name of this object
    3.function void get_children(ref uvm_component children[$]) ->array with the list of this component’s children.
    4.function int get_num_children () ->Returns the number of this component’s children.
    5.function int unsigned get_depth()  ->Returns the component’s depth from the root level. uvm_top has a depth of 0.The test and any other top level components have a depth of 1, and so on.
                                       Hierarchy here is,
                                                         uvm_root
                                                            |
                                                          comp3
                                                           / \
                                                       comp1 comp2
*/

//Code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
    $display("comp1, ","my parent is: %p",get_parent());
    $display("comp1, ","my full name is: %s",get_full_name ());
    $display("comp1, ","my depth in hierarchy is: %0d",get_depth());
    $display("-----------------------------------------------------");
  endfunction
endclass
class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
    $display("comp2, ","my parent is: %p",get_parent());
    $display("comp2, ","my full name is: %s",get_full_name ());
    $display("comp2, ","my depth in hierarchy is: %0d",get_depth());
    $display("-----------------------------------------------------");
  endfunction
endclass

class comp3 extends uvm_component;
  comp1 c1;
  comp2 c2;
  uvm_component childs[$];
  `uvm_component_utils(comp3)
  function new(string n="comp3",uvm_component p=null);
    super.new(n,p);
    c1=new("c1",this);
    c2=new("c2",this);
    $display("comp3, ","my parent is: %p",get_parent());
    $display("comp3, ","my full name is: %s",get_full_name ());
    get_children(childs);
    $display("comp3, ","no of childrens are : %p",childs);
    $display("comp3, ","my numbers of childrens are : %0d",get_num_children());
    $display("comp3, ","my depth in hierarchy is: %0d",get_depth());
    $display("-----------------------------------------------------");
  endfunction
endclass

module test;
  comp3 c3;
  initial
    begin
      c3=new("c3",null);
      uvm_top.print_topology(uvm_default_tree_printer);   //uvm_root class method function void print_topology (uvm_printer printer=null)
    end
endmodule
