//Analysis FIFO
/*
1.TLM FIFO:-
  1.it primarily focuses on direct communication between two components with different paces
  2.it acts as buffer in their interaction,ensuring smooth data flow and preventing data loss when one component generates data faster or slower than other can consume.
2.Analysis FIFO:-
  1.it primarily focuses on broadcasting data to multiple components operating at different paces.
3.syntax of analysis fifo:-
  1.uvm_tlm_analysis_fifo #(type T) name;
    T - is the type of data analysis fifo is going to store
  2.connect the analysis port of source components to in-built 'analysis_export' port of the analysis FIFO
*/

//Example- in below code,producer,consumer1 and consumer2 work at different pace.
`include "uvm_macros.svh"
import uvm_pkg::*;
class producer extends uvm_component;
  `uvm_component_utils(producer)
  uvm_analysis_port #(int) port;
  function new(string n="prod",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
  endfunction
  int data;
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(5)
      begin
        data=$urandom_range(1,100);
        $display("[Producer] ","data=%0d",data);
        port.write(data);
        #5;
      end
    phase.drop_objection(this);
  endtask
endclass

class consumer1 extends uvm_component;
  `uvm_component_utils(consumer1)
  uvm_tlm_analysis_fifo #(int) fifo;
  function new(string n="cons1",uvm_component p=null);
    super.new(n,p);
    fifo=new("fifo",this);
  endfunction
  int rdata;
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(5)
      begin
        fifo.get(rdata);
        $display("[consumer1] ","received data : %0d",rdata);
        #10;
      end
    phase.drop_objection(this);
  endtask
endclass

class consumer2 extends uvm_component;
  `uvm_component_utils(consumer2)
  uvm_tlm_analysis_fifo #(int) fifo;
  function new(string n="cons2",uvm_component p=null);
    super.new(n,p);
    fifo=new("fifo",this);
  endfunction
  int rdata1;
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(5)
      begin
        fifo.get(rdata1);
        $display("[consumer2] ","received data : %0d",rdata1);
        #15;
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
  consumer1 c1;
  consumer2 c2;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p=producer::type_id::create("p",this);
    c1=consumer1::type_id::create("c1",this);
    c2=consumer2::type_id::create("c2",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    p.port.connect(c1.fifo.analysis_export);
    p.port.connect(c2.fifo.analysis_export);
  endfunction
endclass

module top;
  initial run_test("container");
endmodule
