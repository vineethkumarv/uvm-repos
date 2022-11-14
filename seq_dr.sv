`include"uvm_macros.svh"
import uvm_pkg::*;
class s_item extends uvm_sequence_item();
  rand bit [7:0]a;
  rand bit [7:0]b;
  bit y;
  `uvm_object_utils_begin(s_item)
  `uvm_field_int(a,UVM_ALL_ON)
  `uvm_field_int(b,UVM_ALL_ON)
  //`uvm_field_int(a)
  `uvm_object_utils_end

  function new(string n="it_is_a_seq_item");
    super.new(n);
  endfunction
endclass
/*class s_item1 extends s_item();//uvm_sequence_item();
  rand bit [7:0]x;
  rand bit [7:0]y;
  bit z;
  `uvm_object_utils_begin(s_item1)
  `uvm_field_int(x,UVM_ALL_ON)
  `uvm_field_int(y,UVM_ALL_ON)
  //`uvm_field_int(a)
  `uvm_object_utils_end

  function new(string n="it_is_a_seq_item1");
    super.new(n);
  endfunction
endclass*/

class sequ extends uvm_sequence#(s_item);
  s_item s;
  //s_item1 s1;
  `uvm_object_utils(sequ)
  function new (string n="sequ");
    super.new(n);
    $display("in sequence");
  endfunction
  virtual task body();
    $display("hi");
    s=s_item::type_id::create("s");
    s.print();
  //  repeat (2) begin
    wait_for_grant(); 
   //start_item(s); //instead of the six steps we can have three steps of start_item and finish item
    void'(s.randomize());
   send_request(s);
    s.print();
   wait_for_item_done(); //end
   get_response(s);
   // finish_item(s);//instead of three steps we can have uvm_domacro
    /*s1=s_item1::type_id::create("s1");
    wait_for_grant();
    void'(s1.randomize());
    s1.print();
    send_request(s1);
    wait_for_item_done();
   */
 endtask
endclass

class sqr extends uvm_sequencer#(s_item);
s_item s;
`uvm_component_utils(sqr)
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
s=s_item::type_id::create("s",this);
endfunction
  function new(string n="sqr",uvm_component p=null);
    super.new(n,p);
 endfunction
 /*virtual task run_phase(uvm_phase phase);
 seq_item_port.put(s); 
 endtask*/
 
endclass

class driv extends uvm_driver#(s_item);
  static driv d0;
  s_item s;
  int d_a,d_b;
  //uvm_seq_item_pull_port#(jelly_bean_transaction,REQ) portp;
  //uvm_seq_item_pull_export portexp;
  //s_item1 s1;
  `uvm_component_utils_begin(driv)
  `uvm_field_int(d_a,UVM_DEFAULT)
  `uvm_field_int(d_b,UVM_DEFAULT)
  `uvm_component_utils_end

  function new(string n="sqr",uvm_component p=null);
    super.new(n,p);
    $display("in driver");
    //s.print();
  endfunction
  virtual function void build_phase(uvm_phase phase);
  s=s_item::type_id::create("s",this);
  //s1=s_item1::type_id::create("s1",this);
  `uvm_info("EX","in build phase of driver",UVM_LOW);
  //s.print();

  endfunction

  virtual task run_phase(uvm_phase phase);
  //forever begin
//  phase.raise_objection(this);
 // seq_item_port.get_next_item(s);//blocking
  #10
  //`uvm_info("EX","1 got the next item",UVM_LOW);
  //#10
  seq_item_port.get(s);//non blocking
  `uvm_info("EX","2 got the next item",UVM_LOW);
 // #10
  seq_item_port.put(s);
  `uvm_info("EX","2.1 got the next item",UVM_LOW);
  //portp.get(s);
  //seq_item_port.item_done();
  //`uvm_info("EX","3 got the next item",UVM_LOW);
  //seq_item_port.get(s);//non blocking
  //seq_item_port.put(s);
//  phase.drop_objection(this);
  //d_a =s.a;
  //d_b = s.b;
  //this.print();
  //portp.put(s);
  //seq_item_port.put(s);
  //seq_item_port.get(s);
  //seq_item_port.put(s1);
  //seq_item_port.get_next_item(s);
  //driv::get_inst_name.seq_item_port.get_next_item(s1);
  //s1.print();
  //driv::get_inst_name.seq_item_port.item_done();
  //seq_item_port.item_done();

  `uvm_info("EX","got the item done",UVM_LOW);
  //end
  endtask

endclass

class age extends uvm_agent();
  driv bus;
  uvm_sequencer#(s_item) asr;
  //sqr sr;
  `uvm_component_utils(age)
  function new(string n="age",uvm_component p=null);
    super.new(n,p);
    $display("in agent");
  endfunction

  virtual function void build_phase(uvm_phase phase);
  bus=driv::type_id::create("bus",this);
  asr=uvm_sequencer#(s_item)::type_id::create("sr",this);
  `uvm_info("EX","in build phase of agent",UVM_LOW);
  //bus.print();
endfunction

virtual function void connect_phase(uvm_phase phase);

super.connect_phase(phase);
$display("before connecting driver values are:");
//bus.print();
bus.seq_item_port.connect(asr.seq_item_export);
`uvm_info("EX","in connect phase of agent",UVM_LOW);
 endfunction
 endclass

 class environ extends uvm_env();
   `uvm_component_utils(environ)
   age a;
   function new(string n="environ",uvm_component p=null);
     super.new(n,p);
   endfunction
   virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   a=age::type_id::create("a",this);
 endfunction
endclass

class test extends uvm_test();
  `uvm_component_utils(test)
  environ e;
  sequ s;
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e=environ::type_id::create("e",this);
  s=sequ::type_id:: create("s");
endfunction
virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
s.start(e.a.asr);
phase.drop_objection(this);
   endtask
 endclass


/*module adder(intf inf);
input bit [3:0]a;
input bit [3:0]b;
output bit [4:0]y;
assign y=a+b;
endmodule

interface intf;
  logic [3:0]a,b;
  logic [4:0]y;
endinterface*/

module one;
// initial begin
   //intf inf();
 //end

 initial begin 
   run_test("test");
 end
 endmodule




