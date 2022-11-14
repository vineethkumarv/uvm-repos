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
  `uvm_object_utils(seq)
  function new (string n="sq_add");
    super.new(n);
  endfunction
  virtual task body();
  start_item(req);
  req.randomize();
  finish_item(req);
endtask
endclass

class seqr extends uvm_sequencer#(seqi_add);
  `uvm_component_utils(seqr)
  function new (string n="sqr_add",uvm_component p=null);
    super.new(n,p);
  endfunction
endclass

class d_add extends uvm_driver#(seqi_add);
  virtual a_intf vintf;
  `uvm_component_utils(d_add)
  function new(string n="driver");
    super.new(n);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
  //super.run_phase(phase);
  uvm_config_db#(virtual a_intf)::get(this,"","intf",vintf);
  seq_item_port.get_next_item(req);
  req.randomize();
  vintf.a=req.a;
  vintf.b=req.b;
  seq_item_port.item_done();
  endtask
  virtual task drive();
  endtask

endclass

class ag_add extends uvm_agent();
  d_add d;
  seqr sr;
  `uvm_component_utils(ag_add)

  function new(string n="agent",uvm_component p=null);
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
  seq sequ;
  `uvm_component_utils(environ)
  function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  age=ag_add::type_id::create("age",this);
  sequ=seq::type_id::create("sequ",this);

  endfunction

  virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  sequ.start(age.sr);
  phase.drop_objection(this);
  endtask

  
endclass 


interface a_intf;                                                                                   
    logic [3:0]a;                                                                                     
    logic [3:0]b;                                                                                     
    logic [3:0]s;                                                                                     
    logic c;                                                                                          
endinterface 

module f_add(a_intf a_f);                                                                              
/*input bit [3:0]a;                                                                                   
input bit [3:0]b;                                                                                   
output bit [3:0]s;                                                                                  
output bit c;  */                                                                                     
b_add b_a();
initial begin                                                                                       
  for(int i=0;i<=3;i++) begin                                                                       
    b_a(.A(a_f.a[i]),.B(a_f.b[i]),.S(a_f.s[i]),.C(a_f.c));                                                                          
  end                                                                                               
  $display("sum is %0d and carry is %0b",a_f.s,a_f.c);                                                      
  end
endmodule                                                                                           

module b_add(A,B,S,C);                                                                              
  input bit A,B;                                                                                      
  output bit S,C;                                                                                     
  assign S= A ^ B;                                                                                      
  assign C= A & B;                                                                     
endmodule                                                                                           


module one;
a_intf inf();
f_add fb(inf);
initial 
begin
  uvm_config_db#(virtual a_intf)::set(null,"*","intf",inf);
  run_test("environ");
end
endmodule

