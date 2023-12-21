//Non-Blocking get operation
/*
1.port.try_get method:-
  1.the try_get method is used to retrieve transaction from another component without blocking the execution
  2.Calling port.try_get(rdata) retrieve transaction from another component
  3.try_get method returns 1 if the transaction is available, otherwise, it returns 0
2.port.can_get() method:-
  1.can_get() method call returns 1 if the component can get transaction immediately, otherwise, it returns 0
  2.no argument must be passed to can_get, this method is used to see whether any transaction is available to get
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  uvm_nonblocking_get_port #(int) port;
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
  endfunction
  int rdata;
  task main_phase(uvm_phase phase);
    repeat(5)
      begin
        if(port.can_get())
          begin
            port.try_get(rdata);
            $display("[comp1] ","data received from comp2 is : %0d",rdata);
          end
        else
          $display("[comp1] ","comp2 is not ready");
      end
  endtask
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  uvm_nonblocking_get_imp #(int,comp2) imp;
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  function bit try_get(output int sdata);
    sdata=$urandom_range(1,50);
    $display("[comp2] ","data sent to comp2 is : %0d",sdata);
  endfunction
  function bit can_get();
    $display("----------------------------------------");
    $display("[comp2] ","comp1 is requesting for data");
    return 1;
  endfunction
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="container",uvm_component p=null);
    super.new(n,p);
  endfunction
  comp1 c1;
  comp2 c2;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1=comp1::type_id::create("c1",this);
    c2=comp2::type_id::create("c2",this);
  endfunction 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    c1.port.connect(c2.imp);
  endfunction
endclass

module test;
  initial run_test("container");
endmodule
