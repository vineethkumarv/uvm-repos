`include "uvm_macros.svh"
import uvm_pkg::*;
class s_item extends uvm_sequence_item();
  rand bit a;
  `uvm_object_utils_begin(s_item)
  `uvm_field_int(a,UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string n="sequence_item_or_transaction");
    super.new(n);
  endfunction

endclass

class sequ extends uvm_sequence#(s_item);
  s_item tr;
  `uvm_object_utils(sequ)
  function new(string n="sequence");
    super.new(n);
  endfunction
  virtual task body();
  tr=s_item::type_id::create("tr");
  `uvm_do(tr)
  tr.print();
endtask
endclass

//create a sequencer if want here no need of any 

  class driv extends uvm_driver#(s_item);
    s_item tr1;
    sequ sq;
    `uvm_component_utils(driv)
    function new(string n="driver",uvm_component p);
      super.new(n,p);
    endfunction
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("///////////////////////////");
    tr1=s_item::type_id::create("tr1");
    sq=sequ::type_id::create("sq");
  endfunction
endclass

class age extends uvm_agent();
  driv d;
  sequ sq;
  uvm_sequencer#(s_item) sqr;
  `uvm_component_utils(age)
  function new(string n="age",uvm_component p);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  d=driv::type_id::create("d",this);
  sq=sequ::type_id::create("sq");
  $display("in BP of agent");
  sqr=uvm_sequencer#(s_item)::type_id::create("sqr",this);
endfunction
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(sqr.seq_item_export);
//d.seq_item_port.connect(sqr.seq_item_export);
  endfunction
    
endclass

class environ extends uvm_env();
  `uvm_component_utils(environ)
  age at;
  function new(string n="env",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    at=age::type_id::create("at",this);
  $display("contents of sequence are..........................");
  at.print();
  endfunction
  virtual task run_phase(uvm_phase phase);
  // super.run_phase(phase);i
  //phase.raise_objection(this);
  
  $display("hi in RP of env");
  $display("contents of agent are..........................");
  at.print();
  $display("contents of sequence are..........................");
  at.sq.print();
  $display("contents of sequencer are..........................");
  at.sqr.print();
  $display("contents of seq_item are..........................");
  at.d.tr1.print();
    uvm_resource_db#(int)::get_by_name("hi","i");
  at.sq.start(at.sqr);
  //phase.drop_objection(this);
endtask
endclass

class goto extends uvm_component;
  int i;
  `uvm_component_utils(goto)
  virtual function void build_phase(uvm_phase phase);
   if(uvm_resource_db#(int)::get_by_name("hi","i")) begin
  uvm_resource_db#(int)::read_by_name("hi","i",i);
    $display("value is %0d",i);
  end
  endfunction
  function new(string n="goto",uvm_component p=null);
    super.new(n,p);
  endfunction
endclass

class test extends uvm_test();
  `uvm_component_utils(test)
  environ e;
  goto g;
  function new(string n="test",uvm_component p);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e=environ::type_id::create("e",this);
  g=goto::type_id::create("g",this);
  uvm_resource_db#(int)::set("hi","*",40);
endfunction
/*virtual task run_phase(uvm_phase phase);
// super.run_phase(phase);
//e.at.sq.start(e.at.sqr);
$display("contents of agent are..........................");
e.at.print();
$display("contents of sequence are..........................");
e.at.sq.print();
$display("contents of sequencer are..........................");
e.at.sqr.print();
$display("contents of seq_item are..........................");
e.at.d.tr1.print();
  endtask*/
endclass



module one;
//goto g;
//environ ev;
//uvm_phase p;
initial begin
//  g=new();
//  ev=new();
  run_test("test");
  //ev.run_phase(p);
end
endmodule








