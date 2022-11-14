`include "uvm_macros.svh"
import uvm_pkg::*;


class seqi_add extends uvm_sequence_item();
  rand bit [3:0]a;
  rand bit [3:0]b;
  `uvm_object_utils_begin(seqi_add)
  `uvm_field_int(a,UVM_ALL_ON)
  `uvm_field_int(b,UVM_ALL_ON)
  `uvm_object_utils_end
  function new (string n="s_add");
    super.new(n);
  endfunction
endclass

class seq extends uvm_sequence#(seqi_add);
  seqi_add sqi;

  `uvm_object_utils(seq)
  function new (string n="sq_add");
    super.new(n);
  endfunction
  virtual task body();
  sqi=seqi_add::type_id::create("sqi");
  /*  start_item(sqi);
  sqi.randomize();
  finish_item(sqi);*/
 `uvm_do(sqi);
endtask
endclass

class seqr extends uvm_sequencer#(seqi_add);
  `uvm_component_utils(seqr)
  function new (string n="sqr_add",uvm_component p=null);
    super.new(n,p);
  endfunction
endclass

class d_add extends uvm_driver#(seqi_add);
  seqi_add sqi;
  virtual a_intf vintf;
  `uvm_component_utils(d_add)
  function new(string n="driver",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  sqi=seqi_add::type_id::create("sqi");
  if(!uvm_config_db#(virtual a_intf)::get(null,"","intf",vintf))                                    
  begin                                                                                             
  `uvm_error(get_full_name(),"no config found")                                                   
  end
  sqi.print();
  endfunction

  virtual task run_phase(uvm_phase phase);
  //super.run_phase(phase);
  //uvm_config_db#(virtual a_intf)::get(this,"","intf",vintf);
  //phase.raise_objection(this);
  forever begin
  seq_item_port.get_next_item(sqi);
  sqi.print();
  //sqi.randomize();
    vintf.a=sqi.a;
    vintf.b=sqi.b;
  $display(vintf.a);
  seq_item_port.item_done();
  end
  //phase.drop_objection(this);
endtask
virtual task drive();
  endtask

endclass

class ag_add extends uvm_agent();
  d_add d;
  seqr sr;
  `uvm_component_utils(ag_add)

  function new(string n="agnt",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  sr=seqr::type_id::create("sr",this);
  d=d_add::type_id::create("d",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(sr.seq_item_export);
  endfunction

endclass

class environ extends uvm_env;
  ag_add age;
  //seq sequ;
  `uvm_component_utils(environ)
  function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  age=ag_add::type_id::create("age",this);
  //sequ=seq::type_id::create("sequ",this);

endfunction

/*virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
sequ.start(age.sr);
phase.drop_objection(this);
  endtask*/

endclass 

class test extends uvm_test;
  environ en;
  seq sequ;
  `uvm_component_utils(test)
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  en=environ::type_id::create("en",this);
  sequ=seq::type_id::create("sequ",this);
endfunction

virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
sequ.start(en.age.sr);
#10
phase.drop_objection(this);
  endtask

endclass 


interface a_intf;                                                                                   
  logic [3:0]a;                                                                                     
  logic [3:0]b;                                                                                     
  logic [4:0]s;                                                                                     
  //logic c;                                                                                          
endinterface                                                                                          

module b_add(A,B,S);                                                                              
input bit [3:0] A,B;                                                                                      
output bit [4:0]S;
assign S= A + B;
// assign a_i.s= a_i.a + a_i.b;
endmodule                                                                                           


module one;
a_intf inf();
b_add fb(.A(inf.a),.B(inf.b),.S(inf.s));
initial 
begin
  uvm_config_db#(virtual a_intf)::set(null,"*","intf",inf);
  //fork
  run_test("test");
  $display(inf.a);
  $display("sum is %0d for value %0d and %0d",fb.A,fb.B,fb.S);
  //join
end
endmodule

