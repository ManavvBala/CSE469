// TB for grading CPU LAB4 Summer
// This is the top level testbench  module for the CPU
`timescale 1ns/10ps

module cpu_tb();

	// define signals
	logic clk, reset;
	logic [3:0]  test_selector;

	
	// instantiate modules
	cpu dut (.*);
	
	// set up the clock
	parameter CLOCK_PERIOD=100000;
	initial begin
	 clk <= 0;
	 forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	
	initial begin
		$display("Running benchmark: test01_ADDI");
		test_selector <= 4'd1; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
									  
		$display("Running benchmark: test02_LDUR_STUR");
		test_selector <= 4'd2; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$display("Running benchmark: test03_B");
		test_selector <= 4'd3; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$display("Running benchmark: test04_CBZ");
		test_selector <= 4'd4; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test05_SUBS_ADDS_BLT");
		test_selector <= 4'd5; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$display("Running benchmark: test06_BR");
		test_selector <= 4'd6; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$display("Running benchmark: test07_BR_fwd");
		test_selector <= 4'd7; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test08_BLT_delay");
		test_selector <= 4'd8; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test09_not_fwd_inst");
		test_selector <= 4'd9; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test10_BL");
		test_selector <= 4'd10; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test11_fwd");
		test_selector <= 4'd11; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test12_not_fwd_31");
		test_selector <= 4'd12; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$stop;  // pause the simulation
	end
endmodule