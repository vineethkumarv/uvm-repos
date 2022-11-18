`include "uvm_macros.svh"
import uvm_pkg::*;


class seqi_add extends uvm_sequence_item();
  rand bit [3:0]a;
  rand bit [3:0]b;
  bit [4:0]y;
  `uvm_object_utils_begin(seqi_add)
  `uvm_field_int(a,UVM_ALL_ON)
  `uvm_field_int(b,UVM_ALL_ON)
  `uvm_field_int(y,UVM_ALL_ON)
  `uvm_object_utils_end
  function new (string n="s_add");
    super.new(n);
  endfunction
endclass

class seq extends uvm_sequence#(seqi_add);
  `uvm_object_utils(seq)
  seqi_add si;
  function new (string n="sq_add");
    super.new(n);
  endfunction
  virtual task body();
  si=seqi_add::type_id::create("si");
  repeat (10) begin
    start_item(si);
    si.randomize();
    finish_item(si); 
  end
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
  seqi_add si;
  `uvm_component_utils(d_add)
  function new(string n="driver",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  si=seqi_add::type_id::create("si");
  if(!uvm_config_db#(virtual a_intf)::get(null,"","intf",vintf))
    `uvm_error("con","cannot retrieve from db");
  endfunction

  virtual task run_phase(uvm_phase phase);
  //super.run_phase(phase);
  forever begin
    //@(posedge vintf.clk)
    if(vintf.rst) begin
      seq_item_port.get_next_item(si);
      vintf.a=0;
      vintf.b=0;
      vintf.s=0;
      `uvm_info("araala",$sformatf("from Driver a:%0d , b:%0d and y : %0d",vintf.a,vintf.b,vintf.s), UVM_NONE)
      seq_item_port.item_done();
    @(posedge vintf.clk);
    end
    else 
    begin
      seq_item_port.get_next_item(si);
      vintf.a =si.a;
      vintf.b =si.b;
      //vintf.s =si.y;
      `uvm_info("araala",$sformatf("from Driver a:%0d , b:%0d and y : %0d",vintf.a,vintf.b,vintf.s), UVM_NONE)
      seq_item_port.item_done();
    @(posedge vintf.clk);
    end
  end
endtask
virtual task drive(seqi_add si);
si.print();
 endtask

endclass

class mon1 extends uvm_monitor();
  seqi_add si;
  virtual a_intf vintf; 
  uvm_analysis_port#(seqi_add) c_port;
  `uvm_component_utils(mon1)
  function new(string n="monitor",uvm_component p=null);
    super.new(n,p);
    c_port=new("write",this);
  endfunction
  virtual function void build_phase(uvm_phase phase);                                               
  super.build_phase(phase);  
  si=seqi_add::type_id::create("si",this);
  if(!uvm_config_db#(virtual a_intf)::get(null,"","intf",vintf))
  begin
    `uvm_error("araala","cannot get interface");
  end
endfunction

virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
  @(posedge vintf.clk)
  si.y=vintf.s;
  c_port.write(si);
end
endtask
endclass

class mon extends uvm_monitor();
  seqi_add si;
  virtual a_intf vintf; 
  uvm_analysis_port#(seqi_add) a_port;
  `uvm_component_utils(mon)
  function new(string n="monitor",uvm_component p=null);
    super.new(n,p);
    a_port=new("write",this);
  endfunction
  virtual function void build_phase(uvm_phase phase);                                               
  super.build_phase(phase);  
  si=seqi_add::type_id::create("si",this);
  if(!uvm_config_db#(virtual a_intf)::get(null,"","intf",vintf))
  begin
    `uvm_error("araala","cannot get interface");
  end
endfunction

virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
  @(posedge vintf.clk)
  si.a = vintf.a;
  si.b = vintf.b;
  si.y = vintf.s;
  a_port.write(si); 
  si.print();
end
 endtask

endclass  
`uvm_analysis_imp_decl(_1)
`uvm_analysis_imp_decl(_2)


class scrbrd extends uvm_scoreboard;
  seqi_add spd,si;
  virtual a_intf vintf;
  `uvm_component_utils(scrbrd) 
  uvm_analysis_imp_1#(seqi_add,scrbrd) b_port;
  uvm_analysis_imp_2#(seqi_add,scrbrd) d_port;

  function new(input string inst = "SCO", uvm_component c);
    super.new(inst, c);
    b_port = new("read_1", this);
    d_port = new("read_2", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  spd = seqi_add::type_id::create("spd");
  si = seqi_add::type_id::create("si");
  if(!uvm_config_db#(virtual a_intf)::get(null,"","intf",vintf))
  begin
    `uvm_error("araala","cannot get interface");
  end
endfunction

virtual function void write_1(input seqi_add s);
spd.a=s.a;
spd.b=s.b;
$write(":)");
`uvm_info("araala",$sformatf("from Monitor_1 a:%0d , b:%0d and y : %0d",s.a,s.b,s.y), UVM_NONE)
//this.verify();    
endfunction

  virtual function void write_2(input seqi_add s);
  spd.y=s.y;
  $write(":)");
  `uvm_info("araala",$sformatf("from Monitor_2 a:%0d , b:%0d and y : %0d",s.a,s.b,s.y), UVM_NONE)
  //this.verify();
endfunction

virtual task run_phase(uvm_phase phase);
//super.run_phase(phase);
forever begin
  @(negedge vintf.clk)
//phase.raise_objection(this);
  if(spd.a + spd.b == spd.y) begin
  `uvm_info("araala",$sformatf("TEST PASSED values are : a:%0d b:%0d y:%0d",spd.a,spd.b,spd.y),UVM_LOW)
  end
  else begin
  `uvm_info("araala",$sformatf("TEST FAILED values are : a:%0d b:%0d y:%0d",spd.a,spd.b,spd.y),UVM_LOW)
  end
//phase.drop_objection(this);
end
endtask

endclass

class ag_2 extends uvm_agent;
  `uvm_component_utils(ag_2)
  mon1 m;
  function new(string n="agent_2",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  m=mon1::type_id::create("m",this);
endfunction
endclass

class ag_add extends uvm_agent();
  d_add d;
  seqr sr;
  mon m;
  `uvm_component_utils(ag_add)

  function new(string n="agent",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  sr=seqr::type_id::create("sr",this);
  d=d_add::type_id::create("d",this);
  m=mon::type_id::create("m",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(sr.seq_item_export);
  endfunction

endclass

class environ extends uvm_env;
  ag_2 age_2;
  ag_add age;
  scrbrd sb;
  //seq sequ;
  `uvm_component_utils(environ)
  function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  age=ag_add::type_id::create("age",this);
  age_2=ag_2::type_id::create("ag_2",this);
  sb=scrbrd::type_id::create("sb",this);
//  sb.verify();
  //sequ=seq::type_id::create("sequ",this);

endfunction

/*virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
sb.verify();
endtask*/

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
age.m.a_port.connect(sb.b_port);
age_2.m.c_port.connect(sb.d_port);
 endfunction


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
//#10
phase.drop_objection(this);
  endtask

endclass 

interface a_intf(input bit clk,bit rst);                                                                                   
  logic [3:0]a;                                                                                     
  logic [3:0]b;                                                                                     
  logic [4:0]s;                                                          
  logic c0,c1;

endinterface 

module f_add(a_intf a_f);                                                                              
wire w1,w2,w3;
b_add b_a(.A(a_f.a[0]),.B(a_f.b[0]),.S(a_f.s[0]),.C(w1),.c(a_f.c0)); 
b_add b_a0(.A(a_f.a[1]),.B(a_f.b[1]),.S(a_f.s[1]),.C(w2),.c(w1)); 
b_add b_a1(.A(a_f.a[2]),.B(a_f.b[2]),.S(a_f.s[2]),.C(w3),.c(w2)); 
b_add b_a2(.A(a_f.a[3]),.B(a_f.b[3]),.S(a_f.s[3]),.C(a_f.c1),.c(w3)); 
assign a_f.s[4] = a_f.c1;
endmodule                                                                                           

module b_add(A,B,c,S,C);                                                                              
input bit A,B,c;                                                                                      
output bit S,C;
assign S= A ^ B ^ c;                                                                                      
assign C= (A & B) |((A ^ B) & c)  ;
endmodule                                                                                           


module one;
bit clk;
bit rst;
a_intf inf(clk,rst);
f_add fb(inf);
always #1 clk <= ~clk;
//always #1 rst <= ~rst;
initial 
begin
  uvm_config_db#(virtual a_intf)::set(null,"*","intf",inf);
  run_test("test");
end
endmodule

