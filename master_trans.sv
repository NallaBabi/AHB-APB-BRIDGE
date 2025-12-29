class master_trans extends uvm_sequence_item;
        `uvm_object_utils(master_trans)
        rand bit [31:0] Haddr;
	rand bit Hwrite;
	rand bit [31:0] Hwdata;
	rand bit [2:0] Hburst;
	rand bit [2:0] Hsize;
	rand bit [1:0] Htrans;
	bit [1:0] Hresp;
	bit [31:0] Hrdata;
	bit Hreadyin=1,Hreadyout;
	rand int unsigned length;
	constraint c1{Hsize inside {[0:2]};};
	constraint c2{(Hsize == 1) -> (Haddr%2 == 0);
		       (Hsize ==2) -> (Haddr%4 == 0);};
	constraint c3{Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
				     [32'h8400_0000 : 32'h8400_03ff],
				     [32'h8800_0000 : 32'h8800_03ff],
				     [32'h8c00_0000 : 32'h8c00_03ff]};};
	constraint c4{(Haddr%1024) + (length * 2**Hsize) <=1023;};
	
        constraint c5 {((Hburst==2)||(Hburst==3)) -> length == 4;
                       ((Hburst==4)||(Hburst==5)) -> length == 8;
                       ((Hburst==6)||(Hburst==7)) -> length == 16;  }

        extern function new(string name = "master_trans");
        extern function void do_print(uvm_printer printer);
endclass
function master_trans::new(string name = "master_trans");
	super.new(name);
endfunction

function void master_trans::do_print(uvm_printer printer);
	super.do_print(printer);
        printer.print_field("Haddr" ,this.Haddr,32,UVM_DEC);
        printer.print_field("Hwrite" ,this.Hwrite,1,UVM_BIN);
        printer.print_field("Hwdata" ,this.Hwdata,32,UVM_HEX);
        printer.print_field("Hburst" ,this.Hburst,3,UVM_BIN);
        printer.print_field("Hsize" ,this.Hsize,3,UVM_BIN);
        printer.print_field("Htrans" ,this.Htrans,2,UVM_BIN);
        printer.print_field("Hresp" ,this.Hresp,2,UVM_BIN);
        printer.print_field("Hrdata" ,this.Hrdata,32,UVM_DEC);	
        printer.print_field("Hreadyin" ,this.Hreadyin,1,UVM_BIN);	
        printer.print_field("Hreadyout" ,this.Hreadyout,1,UVM_BIN);	
	
endfunction
