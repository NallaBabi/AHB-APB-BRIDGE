//----------------base_sequence_class------------------------
class master_seq_base extends uvm_sequence #(master_trans);
	`uvm_object_utils(master_seq_base)
	extern function new(string name = "master_seq_base");

endclass

function master_seq_base::new(string name  = "master_seq_base");
	super.new(name);
endfunction


//-----------SINGLE SEQUENCE
class single_seq extends master_seq_base;
	`uvm_object_utils(single_seq)
	 extern function new(string name = "single_seq");
	 extern task body();
endclass

function single_seq::new(string name  = "single_seq");
	super.new(name);
endfunction

task single_seq::body();
	req = master_trans::type_id::create("req");
  	
        start_item(req);
        assert(req.randomize() with {Hburst == 3'b000;  Hwrite == 0;  Htrans == 2'b10; Hsize ==0; Haddr inside {[32'h8000_0000:32'h8000_03ff]};});
	finish_item(req);
endtask

//----------------INCREMENT 4 SEQUENCE
class inc4_seq extends master_seq_base;
	bit [31:0] haddr;
	bit [2:0] hburst,hsize;
	bit hwrite;
	bit [1:0] htrans;
	`uvm_object_utils(inc4_seq)
	 extern function new(string name = "inc4_seq");
	 extern task body();
endclass

function inc4_seq::new(string name  = "inc4_seq");
	super.new(name);
endfunction

task inc4_seq::body();
	req = master_trans::type_id::create("req");
  	begin
        start_item(req);
        assert(req.randomize() with {Hburst == 3'b011;  Hwrite == 1;  Htrans == 2'b10; Hsize == 1;Haddr inside {[32'h8400_0000:32'h8400_03ff]};});
        finish_item(req);
        `uvm_info(get_type_name(),$sformatf("data from single sequence class non_seq %s",req.sprint()),UVM_LOW)
	haddr = req.Haddr;
	hsize = req.Hsize;
	hwrite = req.Hwrite;
	hburst = req.Hburst;
        for(int i=1;i<4;i++) begin
               haddr = req.Haddr+2**hsize;
		start_item(req);
		assert(req.randomize() with {Hburst == hburst;Hsize == hsize;Htrans == 2'b11;Haddr == haddr; Hwrite == hwrite;});
		finish_item(req);
	//haddr = req.Haddr;
		
              `uvm_info(get_type_name(),$sformatf("data from single sequence class  seq %s",req.sprint()),UVM_LOW)
		


	end
end
endtask


//wrap sequence

class wrap_seq extends master_seq_base;
	bit [31:0] haddr;
	bit [2:0] hburst,hsize;
	bit hwrite;
	bit [1:0] htrans;
	int unsigned len;
	`uvm_object_utils(wrap_seq)

      	int unsigned start_addr,wrap_addr;
	 extern function new(string name = "wrap_seq");
	 extern task body();
endclass

function wrap_seq::new(string name  = "wrap_seq");
	super.new(name);
endfunction

task wrap_seq::body();
	req = master_trans::type_id::create("req");
	begin
	start_item(req);
        assert(req.randomize() with {Hburst == 3'b010;  Hwrite == 1'b1;Haddr inside {[32'h8800_0000:32'h8800_03ff]}; Htrans == 2'b10; Hsize ==2;});
	finish_item(req);
	haddr = req.Haddr;
	hsize = req.Hsize;
	hwrite = req.Hwrite;
	hburst = req.Hburst;
	len = req.length;
	start_addr = int'((haddr/((2**hsize)*(len+1))))*((2**hsize)*(len+1));
	wrap_addr = start_addr + ((2**hsize)*(len+1));
        $display("start_addr = %0d \n wrap_addr = %0d",start_addr,wrap_addr);

	for(int i=1;i<len+2;i++) 
	begin
		haddr = req.Haddr+2**hsize;
			start_item(req);
			if(haddr >=wrap_addr)
			haddr = start_addr;
			
			assert(req.randomize() with {Hburst == hburst;Hsize == hsize;Htrans == 2'b11;Haddr == haddr; Hwrite == hwrite;});
			finish_item(req);
              //`uvm_info(get_type_name(),$sformatf("data from wrap sequence class  seq %s",req.sprint()),UVM_LOW)
			
	end
        end


endtask

class unsp_len_seq extends master_seq_base;
	bit [31:0] haddr;
	bit [2:0] hburst,hsize;
	bit hwrite;
	bit [1:0] htrans;
	`uvm_object_utils(unsp_len_seq)
	 extern function new(string name = "unsp_len_seq");
	 extern task body();
endclass

function unsp_len_seq::new(string name  = "unsp_len_seq");
	super.new(name);
endfunction



task unsp_len_seq::body();
	req = master_trans::type_id::create("req");
  	begin
        start_item(req);
        assert(req.randomize() with {Hburst == 3'b011; Hsize ==2; Hwrite == 0;  Htrans == 2'b10;Haddr inside {[32'h8c00_0000:32'h8c00_03ff]};});
        finish_item(req);
        `uvm_info(get_type_name(),$sformatf("data from single sequence class non_seq %s",req.sprint()),UVM_LOW)
	haddr = req.Haddr;
	hsize = req.Hsize;
	hwrite = req.Hwrite;
	hburst = req.Hburst;
        for(int i=1;i<4;i++) begin
               haddr = req.Haddr+2**hsize;
		start_item(req);
		assert(req.randomize() with {Hburst == hburst;Hsize == hsize;Htrans == 2'b11;Haddr ==haddr; Hwrite == hwrite;});
		finish_item(req);
	//haddr = req.Haddr;
		
              `uvm_info(get_type_name(),$sformatf("data from single sequence class  seq %s",req.sprint()),UVM_LOW)
		


	end
end
endtask


