`include "uvm_macros.svh"
import uvm_pkg::*;

class environ extends uvm_env;
  `uvm_component_utils(environ)
   int a,b,c,b1,d,c1;  
  function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  $display(/*"this is get by type method value of top.env %p",*/ uvm_resource_db#(string)::get_by_type("top.env"));
  /*$display("this is get by name method value of top.env %p", uvm_resource_db#(int)::get_by_name("top.env","num1"));
  $display("this is get by name method value of top.env %p", uvm_resource_db#(int)::get_by_name("top.env","num2"));
  $display("this is get by name method value of top.env %p", uvm_resource_db#(int)::get_by_name("top.env","num3"));*/
  //$display("this is get by name method value of top.env %p", uvm_resource_db#(int)::get_by_name("top.env","num4"));
  uvm_resource_db#(int)::read_by_name("top","num1",a);
  uvm_resource_db#(int)::read_by_name("top.env","num0",d);
  $display(" hi in 34 of %0d",d);
  uvm_resource_db#(int)::get_by_name("top.env","n",0);
  //uvm_resource_db#(int)::read_by_name("top.env","num4",b);
  $display("............................................");
  $display (uvm_resource_db#(int)::read_by_name("top.env","num2",b));
  $display (uvm_resource_db#(int)::read_by_name("top.env","num3",b1));
  $display (uvm_resource_db#(int)::read_by_type("top.env",c));
  $display (uvm_resource_db#(int)::read_by_type("top",c1));
  //$display (uvm_resource_db#(int)::read_by_type("top.env",d));
  $display(" the value of 'a'(num1) retrieved is %0d",a);
  $display(" the value of 'b'(num2) retrieved is %0d",b);
  $display(" the value of 'c' retrieved via read_by_type is %0d",c);
  //$display(" the value of 'c'(num4) retrieved is %0d",d);
  $display(" the value of 'b1'(num3) retrieved is %0d",c);
  endfunction
endclass
class test extends uvm_test;
environ e;
int a=10;
`uvm_component_utils(test)
function new(string n="environ",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e=environ::type_id::create("e",this);
  uvm_resource_db#(int)::set("top.env","num1",999);
  uvm_resource_db#(int)::set("top.env","num0",a);
  uvm_resource_db#(string)::set("top.env","z","hello");
  uvm_resource_db#(int)::set_default("top.env","num2");//takes no value
  uvm_resource_db#(int)::set_default("top.env","num3");
  //uvm_resource_db#(int)::set_default("top.env","num4");
  uvm_resource_db#(int)::set_anonymous("top.env",5);
  uvm_resource_db#(int)::write_by_name("top.env","num1",143); //overrides num1
 // uvm_resource_db#(int)::write_by_name("top.env","num4",143);//shows error
  uvm_resource_db#(int)::write_by_name("top.env","num2",140);
  uvm_resource_db#(int)::write_by_name("top.env","num3",100);
  uvm_resource_db#(int)::write_by_type("top.env",146);
  uvm_resource_db#(int)::set("top","num1",9999);
  //uvm_resource_db#(int)::write_by_type("top",1000);
  //uvm_resource_db#(int)::write_by_type("top.env",79); multiple values cannot be put
  uvm_resource_db#(int)::dump();
  
  endfunction
endclass

module one;
initial begin
  run_test("test");
end
endmodule

