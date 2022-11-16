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
  repeat (5) begin
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
    repeat (2) begin
    seq_item_port.get_next_item(si);
  //req.randomize();
  vintf.a=si.a;
  vintf.b=si.b;
  //this.drive(si);//
  //#1
  //vintf.s=si.y;#2; 
  seq_item_port.item_done();
  #1;
  end
  end
  endtask
  virtual task drive(seqi_add si);
  si.print();
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
   begin `uvm_error("araala","cannot get interface");
   end
 endfunction
   
 virtual task run_phase(uvm_phase phase);
   super.run_phase(phase);
   forever begin
     repeat (3) begin
   #2; 
   phase.raise_objection(this);
    si.a = vintf.a;
    si.b = vintf.b;
    si.y = vintf.s;//  vintf.c1;
    a_port.write(si);
    
    si.print();
    //break;
    phase.drop_objection(this);
   end
 end
 endtask


endclass  


class scrbrd extends uvm_scoreboard;
  `uvm_component_utils(scrbrd) 
  uvm_analysis_imp#(seqi_add,scrbrd) b_port;
  seqi_add si;
   
  function new(input string inst = "SCO", uvm_component c);
    super.new(inst, c);
    b_port = new("read", this);
  endfunction
   
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  si = seqi_add::type_id::create("si");
  endfunction
 
  virtual function void write(input seqi_add s);
  $write(":)");
  `uvm_info("araala",$sformatf("from Monitor a:%0d , b:%0d and y : %0d",s.a,s.b,s.y), UVM_NONE)
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
  sb=scrbrd::type_id::create("sb",this);
  //sequ=seq::type_id::create("sequ",this);

  endfunction

  /*virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  //sequ.start(age.sr);
  phase.drop_objection(this);
  endtask*/

 virtual function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 age.m.a_port.connect(sb.b_port);
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

interface a_intf;                                                                                   
    logic [3:0]a;                                                                                     
    logic [3:0]b;                                                                                     
    logic [4:0]s;                                                                                     
    logic c0,c1;                                                                                          
endinterface 

module f_add(a_intf a_f);                                                                              
/*input bit [3:0]a;                                                                                   
input bit [3:0]b;                                                                                   
output bit [3:0]s;                                                                                  
output bit c;  */    
//a_f.c=a_f.a[0]+a_f.b[0];
wire w1,w2,w3;
b_add b_a(.A(a_f.a[0]),.B(a_f.b[0]),.S(a_f.s[0]),.C(w1),.c(a_f.c0)); 
b_add b_a0(.A(a_f.a[1]),.B(a_f.b[1]),.S(a_f.s[1]),.C(w2),.c(w1)); 
b_add b_a1(.A(a_f.a[2]),.B(a_f.b[2]),.S(a_f.s[2]),.C(w3),.c(w2)); 
b_add b_a2(.A(a_f.a[3]),.B(a_f.b[3]),.S(a_f.s[3]),.C(a_f.c1),.c(w3)); 
//b_add b_a3(.A(),.B(),.S(a_f.s[4]),.C(),.c()); 
assign a_f.s[4] = a_f.c1;
//typedef b_add b_a;
/*initial begin                                                                                        
for(int i=0;i<=3;i++) begin     
    if (i==0) begin
      a_f.c = a_f.a[0] & a_f.b[0];
    end
    else if(i==3) begin
      a_f.s[4]=a_f.c;
    end
  b_a(.A(a_f.a[i]),.B(a_f.b[i]),.S(a_f.s[i]),.C(a_f.c)); 
  end                                                                                               
  //$display("sum is %0d and carry is %0b",a_f.s,a_f.c);                                                      
  end*/
endmodule                                                                                           

module b_add(A,B,c,S,C);                                                                              
  input bit A,B,c;                                                                                      
  output bit S,C;                                                                                     
  assign S= A ^ B ^ c;                                                                                      
  assign C= (A & B) |((A ^ B) & c)  ;                                                                     
endmodule                                                                                           


module one;
a_intf inf();
f_add fb(inf);
initial 
begin
  uvm_config_db#(virtual a_intf)::set(null,"*","intf",inf);
  run_test("test");
end
endmodule
 
