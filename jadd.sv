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
  seqi_add sqi;

  `uvm_object_utils(seq)
  function new (string n="sq_add");
    super.new(n);
  endfunction
  virtual task body();
  repeat(3) begin
  sqi=seqi_add::type_id::create("sqi");
  start_item(sqi);
  sqi.randomize();
  finish_item(sqi);
  end//#2
  //`uvm_do(sqi);
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
  endfunction

  virtual task run_phase(uvm_phase phase);
  //super.run_phase(phase);
  //uvm_config_db#(virtual a_intf)::get(this,"","intf",vintf);
  //phase.raise_objection(this);
  forever begin
  seq_item_port.get_next_item(sqi);
  //sqi.print();
  //sqi.randomize();
  //sqi.print();
    vintf.a =sqi.a;
    vintf.b =sqi.b;
    //vintf.s = sqi.y;
    $display(vintf.a);
  #2;
  seq_item_port.item_done();
 end
  //phase.drop_objection(this);
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
   //forever begin
   #2;
   phase.raise_objection(this);
    si.a = vintf.a;
    si.b = vintf.b;
    si.y = vintf.s;
    a_port.write(si);
    si.print();
    //break;
    phase.drop_objection(this);
   //end
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
  mon m;
  seqr sr;
  `uvm_component_utils(ag_add)

  function new(string n="agnt",uvm_component p=null);
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
sequ.start(age.sr);
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
  //logic c;                                                                                          
endinterface                                                                                          

module b_add(A,B,S);                                                                              
input bit [3:0] A,B;                                                                                      
output bit [4:0]S;
assign S= A + B;
initial begin
//  $display(A,B,S);

end
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
  //$display(inf.a);
//  $display("sum is %0d for value %0d and %0d",fb.A,fb.B,fb.S);
  //join
end
endmodule

