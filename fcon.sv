
`include "uvm_macros.svh"
import uvm_pkg::*;
class eenv extends uvm_env;
  `uvm_component_utils(eenv)
  string p;
  function new(string n="eenv",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(uvm_config_db#(string)::get(this,"","n",p)) begin
  $display("In the environment the value of bit retrieved is %0s",p);
  end
  else begin
    $display("not done"); end
  endfunction
endclass
class environ extends uvm_driver#(uvm_sequence_item);
  `uvm_component_utils(environ)
   eenv en;
   int a,b,c,b1,d;  
   bit x,y;
   string p,q;
  function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  en=eenv::type_id::create("en",this);
  if(uvm_config_db#(string)::get(this,"","n",p)) begin
  $display("In the driver and the value of bit retrieved is %0s",p);
  end
  else begin
    $display("not done in driver"); end
  //uvm_resource_db#(string)::read_by_type("hi",q);
  //$display(" the value of bit retrieved is %0s",q);
  endfunction
/*
  virtual task body(); 
  uvm_config_db#(string)::get(this,"uvm_test_top.*","n",p);
  $display(" the value of bit retrieved is %0s",p);
  endtaski*/
endclass

class test extends uvm_agent;
environ e;
eenv en;
`uvm_component_utils(test)
function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  en=eenv::type_id::create("eee",this);
  e=environ::type_id::create("e",this);
  //uvm_resource_db#(string)::set("top","n","krishna");
  //uvm_config_db#(string)::set(this,"*","n","shiva");//n="shiva" and equals to 
  uvm_config_db#(string)::set(null,"uvm_test_top.environ","n","shiva");
  //uvm_resource_db#(string)::set("hi","n","ram");
  //uvm_resource_db#(uvm_component)::write_by_type("top",this);
  //uvm_resource_db#(string)::write_by_type("hi","vishnu");
  endfunction
endclass

module one;
//test t = new("test",null);
initial begin
  run_test("test"); 
end endmodule
