//`uvm_do(sequence) :- sequence as a argument in `uvm_do() macro

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class trans extends uvm_sequence_item;
	`uvm_object_utils(trans)
	function new(string n="trans");
		super.new(n);
	endfunction
  rand bit[7:0]addr;
  rand bit wr;
endclass

class wr_seq extends uvm_sequence #(trans);
  `uvm_object_utils(wr_seq)
  function new(string n="wr_seq");
    super.new(n);
  endfunction
  trans tr;
  task body();
    `uvm_do_with(tr,{tr.wr==1;})
  endtask
endclass

class rd_seq extends uvm_sequence #(trans);
  `uvm_object_utils(rd_seq)
  function new(string n="rd_seq");
    super.new(n);
  endfunction
  trans tr;
  task body();
    `uvm_do_with(tr,{tr.wr==0;})
  endtask
endclass

class seq extends uvm_sequence#(trans);
	`uvm_object_utils(seq)
	function new(string n="seq");
		super.new(n);
	endfunction
  wr_seq ws;
  rd_seq rs;
  task body;
    repeat(5)
      begin
        `uvm_do(ws)
        `uvm_do(rs)
      end
  endtask
endclass

class driver extends uvm_driver #(trans);
	`uvm_component_utils(driver)
	function new(string n="Driver",uvm_component p=null);
		super.new(n,p);
	endfunction
	trans tr;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		tr=trans::type_id::create("tr");
	endfunction
  task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(tr);
        $display("[Drv]","wr=%b and addr=%0d ",tr.wr,tr.addr);
        seq_item_port.item_done(tr);
        $display("---------------------------------------");
      end
  endtask
endclass

class agent extends uvm_agent;
	`uvm_component_utils(agent)
	function new(string n="agent",uvm_component p=null);
		super.new(n,p);
	endfunction
	uvm_sequencer #(trans) sqr;
	driver drv;
    seq sq;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sqr=uvm_sequencer #(trans)::type_id::create("sqr",this);
		drv=driver::type_id::create("drv",this);
      sq=seq::type_id::create("seq");
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction
  task run_phase(uvm_phase phase);
    sq.start(sqr);
  endtask
endclass

module test;
  initial run_test("agent");
endmodule
