//TLM FIFO
/*
1.when to use TLM FIFO?
 1.when you need to buffer transactions between two components operating at different paces or with different comminication requirements
 2.when one component generates data faster than another can consume it,a TLM FIFO acts as buffer,preventing data loss and ensuring smooth communication.
 3.if components operats asynchronously or have different clock domains,a TLM FIFO facilitates communication by decoupling the sending and receiving times.
   the producer can push the transaction into the FIFO at it's own pace,while consumer can pull them out whenever it's ready,without needing synchronize their actions.
 4.  |----------- |                               |------------|                                           |-----------|
     | Producer   |put port             put_export| TLM FIFO   |get_export                        get port | Consumer  |
     |------------|                               |------------|                                           |-----------|

5.we need to connect producer's put port with FIFO's in-built put_export and consumer's get port with the FIFO's in-built get_export
6.transactions can be reterived with the help of get method of TLM FIFO
7.declaring and instantiating:-
  1.uvm_tlm_fifo #(T) fifo_name;       //T is the transaction type
  2. fifo_name=new("fifo_name",this);  //instantiating FIFO within component
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class producer extends uvm_component;
  `uvm_component_utils(producer)
  uvm_blocking_put_port #(int)port;
  int send;
  function new(string n="prod",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
  endfunction
  task run_phase(uvm_phase phase);    //Here,producer is generating data at 10 time unit/data
    phase.raise_objection(this);
    repeat(15)
      begin
        send=$urandom_range(1,50);
        $display("[Producer] "," data sent to fifo: sent=%0d",send);
        port.put(send);            //put method is used to send the transaction to the FIFO
        #10;
      end
    phase.drop_objection(this);
  endtask
endclass

class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  uvm_blocking_get_port #(int)port;
  uvm_tlm_fifo #(int)fifo;
  int rcv;
  function new(string n="cons",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
    fifo=new("fifo",this,15);
  endfunction
  task run_phase(uvm_phase phase);   //consumer is consuming data at rate 20 time unit/data
    phase.raise_objection(this);
    repeat(15)
      begin
        port.get(rcv);              //blocks until a transaction is available and retrieve it 
        $display("[Consumer] "," data received: rcv=%0d",rcv);
        #20;
      end
    phase.drop_objection(this);
  endtask
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="cont",uvm_component p=null);
    super.new(n,p);
  endfunction
  producer p;
  consumer c;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p=producer::type_id::create("p",this);
    c=consumer::type_id::create("c",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    p.port.connect(c.fifo.put_export);
    c.port.connect(c.fifo.get_export);
  endfunction
endclass

module top;
  initial run_test("container");
endmodule
