program test_fork();
	initial begin
		for (int i=0; i<3; ++i) begin
			fork
				#i $display("Thread %d",i);
			join
		end
		#20;
	end
endprogram

program test_rand();
	int a,b;
	reg signed [2:0] c;

	initial begin
	    // c = $random;
		c=-4;
	    $display(c);
	    a = 11 % -3;
	    b = -10 % 3;
	    // $display(a,b);
	    $display("Or:%b",c);
	end
endprogram

module tb_top();

test_rand p1();
test_fork p2();


endmodule