//Virtual sequencer
/*
1. when you need to drive stimulus from multiple agents(e.g drivers,sequences) onto different interfaces or environment,a virtual sequencer acts as central coordinator.
   it ensures these agents executes their sequences in controlled and synchronized manner.
2. virtual sequencers inherit from uvm_sequencer to manage and execute sequences
3. every sequence has an m_sequencer handle,which is reference to the sequencer that will drive it's items.
4. m_sequencer is a generic type sequencer
5. it's declared as uvm_sequencer_base to accommodate different sequencer types

*/

//Design Module

module adder(input [31:0]a,b,output int y);
  always@(*)
    begin
      y=a+b;
    end
endmodule

module substractor(input [31:0]in1,in2,output int out);
  always@(*)
    begin
      out=in1-in2;
    end
endmodule

module top(input [31:0]a,b,in1,in2,output int y,out);
  adder dut1(a,b,y);
  substractor dut2(in1,in2,out);
endmodule


//Testbench

`include "uvm_macros.svh"
import uvm_pkg::*;
class adder_item extends uvm_sequence_item;
  `uvm_object_utils(adder_item)
  function new(string n="a_item");
    super.new(n);
  endfunction
  randc logic[31:0]a,b;
  logic [31:0]y;
  constraint c1{a<100 && b<200;}
endclass

class adder_seq extends uvm_sequence #(adder_item);
  `uvm_object_utils(adder_seq)
  function new(string n="a_seq");
    super.new(n);
  endfunction
  adder_item i;
  task body();
    i=adder_item::type_id::create("i");
    repeat(10)
      begin
        start_item(i);
        i.randomize;
        finish_item(i);
      end
  endtask
endclass

interface adder_if;
  logic[31:0] a,b,y;
endinterface

class adder_driver extends uvm_driver #(adder_item);
  `uvm_component_utils(adder_driver)
  function new(string n="a_drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual adder_if vif;
  adder_item i;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    i=adder_item::type_id::create("i");
    if(!uvm_config_db #(virtual adder_if)::get(this,"","key1",vif))
      `uvm_error(get_name,"Unable to get virtual interface");
  endfunction
  function void compare();
    if((i.a+i.b)==i.y)
      begin
      `uvm_info(get_name,"Result Correct",UVM_NONE)
      end
    else
      begin
      `uvm_error(get_name,"Result Incorrect")
      end
  endfunction
  task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(i);
        vif.a<=i.a;
        vif.b<=i.b;
        #1;
        i.y=vif.y;
        `uvm_info(get_name,$sformatf("value of a=%0d and b=%0d -> result: y=%0d",i.a,i.b,i.y),UVM_NONE);
        compare();
        #9;
        seq_item_port.item_done();
      end
  endtask
endclass

class adder_agent extends uvm_agent;
  `uvm_component_utils(adder_agent)
  function new(string n="a_agt",uvm_component p=null);
    super.new(n,p);
  endfunction
  adder_driver a_drv;
  uvm_sequencer #(adder_item) a_sqr;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a_drv=adder_driver::type_id::create("a_drv",this);
    a_sqr=uvm_sequencer #(adder_item)::type_id::create("s_sqr",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a_drv.seq_item_port.connect(a_sqr.seq_item_export);
  endfunction
endclass

///////////////////////////////////////
class sub_item extends uvm_sequence_item;
  `uvm_object_utils(sub_item)
  function new(string n="s_item");
    super.new(n);
  endfunction
  randc logic[31:0]in1,in2;
  logic[31:0] out;
  constraint c{in1>in2;}
endclass

class sub_seq extends uvm_sequence #(sub_item);
  `uvm_object_utils(sub_seq)
  function new(string n="s_seq");
    super.new(n);
  endfunction
  sub_item j;
  task body();
    j=sub_item::type_id::create("s_item");
    repeat(10)
      begin
        start_item(j);
        j.randomize() with {in1<1000 && in2<1000;};
        finish_item(j);
      end
  endtask
endclass

interface sub_if;
  logic[31:0] in1,in2,out;
endinterface

class sub_driver extends uvm_driver #(sub_item);
  `uvm_component_utils(sub_driver)
  function new(string n="s_drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual sub_if vif;
  sub_item j;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    j=sub_item::type_id::create("j");
    if(!uvm_config_db #(virtual sub_if)::get(this,"","key2",vif))
      `uvm_error(get_name,"Unable to get virtual interface");
  endfunction
  function void compare_result();
    if((j.in1-j.in2)==j.out)
      begin
        `uvm_info(get_name,"Results are correct",UVM_NONE);
      end
    else
      begin
        `uvm_error(get_name,"Results are Incorrect");
      end
  endfunction
  task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(j);
        vif.in1<=j.in1;
        vif.in2<=j.in2;
        #1;
        j.out=vif.out;
        `uvm_info(get_name,$sformatf("value of in1=%0d and in2=%0d -> result: out=%0d",j.in1,j.in2,j.out),UVM_NONE);
        compare_result();
        #9;
        seq_item_port.item_done();
      end
  endtask
endclass

class sub_agent extends uvm_agent;
  `uvm_component_utils(sub_agent)
  function new(string n="s_agt",uvm_component p=null);
    super.new(n,p);
  endfunction
  sub_driver s_drv;
  uvm_sequencer #(sub_item) s_sqr;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s_drv=sub_driver::type_id::create("s_drv",this);
    s_sqr= uvm_sequencer #(sub_item)::type_id::create("s_sqr",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    s_drv.seq_item_port.connect(s_sqr.seq_item_export);
  endfunction
endclass

class vsequencer extends uvm_sequencer;
  `uvm_component_utils(vsequencer)
  function new(string n="vseqr",uvm_component p=null);
    super.new(n,p);
  endfunction
  uvm_sequencer #(adder_item) v_sqr1;
  uvm_sequencer #(sub_item) v_sqr2;
endclass

class sequence1 extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(sequence1)
  function new(string n="seq1");
    super.new(n);
  endfunction
  vsequencer vsqr;
  task body();
    if(!$cast(vsqr,m_sequencer))
      `uvm_error(get_name,"casting to m_sequencer failed");
  endtask
endclass

class adder_gen extends sequence1;
  `uvm_object_utils(adder_gen)
  function new(string n="add_gen");
    super.new(n);
  endfunction
  adder_seq aseq;
  task body();
    aseq=adder_seq::type_id::create("aseq");
    super.body();
    aseq.start(vsqr.v_sqr1);
  endtask
endclass

class sub_gen extends sequence1;
  `uvm_object_utils(sub_gen)
  function new(string n="sub_gen");
    super.new(n);
  endfunction
  sub_seq sseq;
  task body();
    sseq=sub_seq::type_id::create("sseq");
    super.body();
    sseq.start(vsqr.v_sqr2);
  endtask
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  function new(string n="e",uvm_component p=null);
    super.new(n,p);
  endfunction
  adder_agent a_agt;
  sub_agent s_agt;
  vsequencer vseqr;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a_agt=adder_agent::type_id::create("a_agt",this); 
    s_agt=sub_agent::type_id::create("s_agt",this); 
    vseqr=vsequencer::type_id::create("vseqr",this); 
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.v_sqr1=a_agt.a_sqr;
    vseqr.v_sqr2=s_agt.s_sqr;
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  env e;
  adder_gen gen1;
  sub_gen gen2;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e=env::type_id::create("e",this);
    gen1=adder_gen::type_id::create("gen1");
    gen2=sub_gen::type_id::create("gen2");
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen1.start(e.vseqr);
    #20;
    $display("-------------------------------------------------------------------------");
    gen2.start(e.vseqr);
    phase.drop_objection(this);
  endtask
endclass

module tb_top;
  adder_if vif1();
  sub_if vif2();
  top top_dut(vif1.a,vif1.b,vif2.in1,vif2.in2,vif1.y,vif2.out);
  initial
    begin
      uvm_config_db #(virtual adder_if)::set(null,"*","key1",vif1);
      uvm_config_db #(virtual sub_if)::set(null,"*","key2",vif2);
      run_test("test");
    end
endmodule













