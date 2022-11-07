`include "uvm_macros.svh"
import uvm_pkg::*;

class environ extends uvm_env;
  `uvm_component_utils(environ)
   int a,b;  
  function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  //uvm_resource_db#(int)::get_by_name("top.env","num1");
  $display("1 this is get by type method value of comp1 %p", uvm_resource_db#(int)::get_by_type("component1"));
  //$display("2 this is get by type method value of comp2 %p", uvm_resource_db#(int)::get_by_type("component2"));
  //$display("3 this is get by name method value of top.sv %p", uvm_resource_db#(int)::get_by_name("top.env","num1"));
  $display("3 this is get by name method value of comp1 %p", uvm_resource_db#(int)::get_by_name("component1","num1"));
  uvm_resource_db#(int)::read_by_name("top.env","num3",a);
  //uvm_resource_db#(int)::read_by_name("top.env","num4",b);
  $display("............................................");
 $display (uvm_resource_db#(int)::read_by_name("env","num5",b));
  $display("7 the value retrieved is %0d",a);
  //$display("7 the value retrieved is %0d",b);
  /*$display("................................................................................................");
  $display( uvm_resource_db#(int)::get_by_name("uvm_test_top.env","num1"));
  $display("4 this is get by type method value of comp1 %p", uvm_resource_db#(string)::get_by_type("component1"));
  $display("                                  ");
  $display("5 this is get by type method value of comp2 %p", uvm_resource_db#(string)::get_by_type("component2"));
  $display(uvm_resource_db#(int)::get_by_type("top.env"));
  uvm_resource_db#(int)::read_by_name("top.env","num1",a);
  $display("7 the value retrieved is %0d",a);*/
  endfunction
endclass
/*
class hello extends uvm_component;
`uvm_component_utils(hello)
int a;
  function new(string n="hello",uvm_component p);
    super.new(n,p);
  endfunction 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  $display("a is %0d",a);
  //$display("it is %0d",uvm_resource_db#(int)::get_by_name("hello","num1"));
  //uvm_resource_db#(int)::read_by_name("uvm_test_top.component","num1",a);
  //uvm_resource_db#(int)::read_by_name("uvm_component","num1",a);
  uvm_resource_db#(int)::read_by_name("aaa","num1",a);
  $display("a is %0d",a);
 endfunction
endclass
*/
class test extends uvm_test;
environ e;

`uvm_component_utils(test)
function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e=environ::type_id::create("e",this);
  uvm_resource_db#(int)::set("component1","num1",3123);
  uvm_resource_db#(string)::set("component2","str1","vineeth");
  uvm_resource_db#(int)::set("top.env","num1",999);
  uvm_resource_db#(int)::set("top.env","num2",124);
  uvm_resource_db#(int)::set("top.env","num3",125);//takes value num1=125 
  uvm_resource_db#(int)::set_default("top.env","num4");//takes no value
  uvm_resource_db#(int)::set_default("top.env","num5");
  uvm_resource_db#(int)::write_by_name("top.env","num5",143);
  uvm_resource_db#(int)::write_by_name("top.env","num3",143);
  uvm_resource_db#(int)::write_by_name("env","num5",140);
  uvm_resource_db#(int)::write_by_type("top.env",146);

  //uvm_resource_db#(virtual simpleand_inf)::set("ifs","simpleand_inf",);
  endfunction
endclass

module one ;
initial begin
  run_test("test");
end
endmodule
