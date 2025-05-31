`timescale 1ns/10ps
module cpustim();
    // Parameters
    parameter CLOCK_PERIOD = 100000;  // 1 ms clock period (very long)
    parameter MAX_CYCLES = 10000;        // Adjust based on your program length
    // Signals
    logic clk;
    logic rst;
    integer cycle_count;
    
    // Instantiate the CPU
    CPU dut (
        .clk(clk),
        .rst(rst)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        repeat (10000) begin
            #(CLOCK_PERIOD/2) clk = ~clk;
        end
    end
    
    // Test sequence
    initial begin
        // Initialize
        rst = 1;
        cycle_count = 0;
        
        repeat (3) @(posedge clk);  // Hold reset for 3 clock cycles
        #(CLOCK_PERIOD/10);
        rst = 0;
		  
		  
        
        // Run for MAX_CYCLES or until program completion
        for (cycle_count = 0; cycle_count < MAX_CYCLES; cycle_count++) begin
            @(posedge clk);
        end
        
        // End simulation
        $finish;
    end

endmodule