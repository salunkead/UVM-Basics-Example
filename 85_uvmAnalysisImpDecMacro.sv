//`uvm_analysis_imp_decl(SFX) macro

/*
1.instantiates multiple analysis implementation:-
-> the above macro enables a component to have multiple independent analysis implementation ports of the same type.
-> the write method is named with the provided suffix to distinguish it from other ports of the same type
-> we can create multiple implementation ports of same type using different suffix
*/

//Example :- below code creates two independent analysis implementation ports: _even and _odd,both handling int type data
`include "uvm_macros.svh"
import uvm_pkg::*;

class even extends uvm_component;
  `uvm_component_utils(even)
  uvm_analysis_port #(int) port1;
  function new(string n="even",uvm_component p=null);
    super.new(n,p);
    port1=new("port1",this);
  endfunction
  rand bit[7:0] ev;
  constraint c1{ev%2==0;}
  task run_phase(uvm_phase phase);
    repeat(10)
      begin
        this.randomize();
        $display("[even], ","value of ev: %0d",this.ev);
        port1.write(ev);
      end
  endtask
endclass

class odd extends uvm_component;
  `uvm_component_utils(odd)
  uvm_analysis_port #(int) port2;
  function new(string n="odd",uvm_component p=null);
    super.new(n,p);
    port2=new("port2",this);
  endfunction
  rand bit[7:0] od;
  constraint c2{od%2!=0;}
  task run_phase(uvm_phase phase);
    repeat(10)
      begin
        this.randomize;
        $display("[odd], ","value of od: %0d",this.od);
        port2.write(od);
      end
  endtask
endclass

`uvm_analysis_imp_decl(_even)
`uvm_analysis_imp_decl(_odd)

class get_all extends uvm_component;
  `uvm_component_utils(get_all)
  uvm_analysis_imp_even #(int,get_all) imp1;
  uvm_analysis_imp_odd #(int,get_all) imp2;
  function new(string n="get_all",uvm_component p=null);
    super.new(n,p);
    imp1=new("imp1",this);
    imp2=new("imp2",this);
  endfunction
  even even_obj;
  odd odd_obj;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    even_obj=even::type_id::create("even_obj",this);
    odd_obj=odd::type_id::create("odd_obj",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    even_obj.port1.connect(imp1);
    odd_obj.port2.connect(imp2);
  endfunction
  function void write_even(int in1);
    $display("[write_even] ","in1 : %0d",in1);
    $display("--------------------------------------");
  endfunction
  function void write_odd(int in2);
    $display("[write_odd] ","in2 : %0d",in2);
    $display("--------------------------------------");
  endfunction
endclass

module top;
  initial run_test("get_all");
endmodule
