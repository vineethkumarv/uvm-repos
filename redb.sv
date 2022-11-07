`include "uvm_macros.svh"
import uvm_pkg::*;

class environ extends uvm_env;
  `uvm_component_utils(environ)
   int a;  
  function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
 //uvm_resource_db#(int)::get_by_name("hi","uvm_test_top.env","num1",123);
  $display("1 this is get by type method value %p", uvm_resource_db#(int)::get_by_type("component1"));
  $display("2 this is get by type method value %p", uvm_resource_db#(int)::get_by_type("component2"));
 // $display("this is get by type method value %s", uvm_resource_db#(int)::get_by_name("uvm_test_top.env","num1"));
  //$display( uvm_resource_db#(int)::get_by_name("uvm_test_top.env","num1"));
  $display("4 this is get by type method value %p", uvm_resource_db#(string)::get_by_type("component1"));
  $display("5 this is get by type method value %p", uvm_resource_db#(string)::get_by_type("component2"));
  //$display(uvm_resource_db#(int)::get_by_type("uvm_test_top.env"));
  //uvm_resource_db#(int)::read_by_name("uvm_test_top.env","num1",a);
  //$display("7 the value retrieved is %0d",a);
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
//hello h;
`uvm_component_utils(test)
function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e=environ::type_id::create("e",this);
  //h=hello::type_id::create("h",this);
  uvm_resource_db#(int)::set("component1","num1",3123);
  uvm_resource_db#(string)::set("component2","num2","vineeth");
  /*uvm_resource_db#(int)::set("uvm_test_top.env","num1",3123);
  uvm_resource_db#(int)::set("uvm_test_top.env","num1",124);
  uvm_resource_db#(int)::set("uvm_test_top.env","num1",125);//takes value num1=125 
  uvm_resource_db#(int)::set_default("uvm_test_top.env","num1");//takes no value
  uvm_resource_db#(int)::set_default("uvm_test_top.env","num1");
  uvm_resource_db#(int)::set("uvm_test_top.env","num1",125);*/
  endfunction
endclass

module one ;
initial begin
  run_test("test");
end
endmodule
