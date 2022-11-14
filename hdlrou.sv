class  envi extends uvm_env;
  int a,b,c;
  string x,y;
  function new (string n="envi",uvm_component p=null);
    super.new(n,p);
  endfunction
endclass

class test extends uvm_test;

