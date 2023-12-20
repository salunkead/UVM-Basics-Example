//Non-Blocking put_port and put_imp port
/*
1.non-blocking TLM method calls attempt to convey transaction without consuming simulation time
2.Difference between blocking and non-blocking put operation in uvm
  1.blocking put port:-
    1.the put method waits until the transaction is successfully delivered to the receiving component before returning
    2.pros:-
      1.guarantees transaction completion
      2.maintains transaction order
    3.cons:-
      1.potential to stall the sending component if the receiver is slow or unresponsive,possibly leading to simulation slowdown.
  2.non-blocking put port:-
    1.the put method returns immediatly,indicating whether the transaction was accepted or not.if not accepted then sender needs to handle accordingly(e.g retrying later)
    2.pros:-
      1.avoids blocking the sender,enhancing simulation performance.
    3.cons:-
      1.doenot guarantee transaction completion
      2.might require additional logic to handle transaction drops or reordering
 3.if simulation speed is critical,non-blocking ports often offer advantages.
 4.if transaction completion and order are essential for correctness then blocking ports provides stronger guarantee.
*/

//Example-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  uvm_nonblocking_put_port #(int) nbport;
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
    nbport=new("nbport",this);
  endfunction
  int sdata;
  task main_phase(uvm_phase phase);
    repeat(5)
      begin
        sdata=$urandom_range(1,100);
        if(nbport.can_put())
          begin
            $display("[Comp1] ","data sent is: %0d",sdata);
            nbport.try_put(sdata);                                //the try_put method is used to send a transaction to another component without blocking the execution                                                     
          end                                                     //try_put method returns 1 If the component is ready to accept the transaction, otherwise it returns 0
        else
          $display("[comp1] ","other component is not ready");
      end
  endtask
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  uvm_nonblocking_put_imp #(int,comp2) nbimp;
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
    nbimp=new("nbimp",this);
  endfunction
  function bit try_put(int rdata);
    $display("[Comp2] ","received data : %0d",rdata);
    return 1;
  endfunction
  function bit can_put();  //no argument must be passed to can_put, this method is used to see whether the other component is ready to accept the transaction or not
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
    c1.nbport.connect(c2.nbimp);
  endfunction
endclass

module top;
  initial run_test("container");
endmodule
