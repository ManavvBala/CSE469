`timescale 1ns/10ps
module cpustim();
    // Parameters
    parameter CLOCK_PERIOD = 1000000;  // 1 ms clock period (very long)
    parameter MAX_CYCLES = 100;        // Adjust based on your program length
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
        repeat (1000) begin
            #(CLOCK_PERIOD/2) clk = ~clk;
        end
    end
    
    // Force %t's to print in a nice format
    initial $timeformat(-9, 2, " ns", 10);
    
    // Test sequence
    initial begin
        // Initialize
        rst = 1;
        cycle_count = 0;
        
        // Apply reset for one clock cycle
    repeat (3) @(posedge clk);  // Hold reset for 3 clock cycles
        #(CLOCK_PERIOD/10);
        rst = 0;
        
        // Run for MAX_CYCLES or until program completion
        for (cycle_count = 0; cycle_count < MAX_CYCLES; cycle_count++) begin
            @(posedge clk);
            
            // Display cycle information
            //$display("Cycle %d: PC = %h, Instruction = %h", 
                    //cycle_count, dut.prevPC, dut.instr);
                    
            // Display register values for debugging
            //$display("  Registers: Rd1 = %h, Rd2 = %h", dut.Rd1, dut.Rd2);
            //$display("  ALU Output: %h", dut.aluOut);
            
            // Optional: Check for program completion
            // For example, if the instruction is a specific halt instruction
            // or if PC stops changing, we can exit
            //if (dut.instr == 32'hD503201F) begin  // NOP instruction typically used for ending
                //$display("Program complete: NOP instruction detected");
                //break;
            //end
            
            // Alternative completion detection: if PC doesn't change after a cycle
            //if (cycle_count > 0 && (dut.prevPC == dut.curPC)) begin
              //  $display("Program complete: PC not advancing");
                //break;
            //end
        end
        
        // End simulation
        $stop;
    end
    
    // Debug display logic
    always @(posedge clk) begin
        $display("Cycle %0d: PC=%h, instr=%h, nextPC=%h",
                cycle_count, dut.prevPC, dut.instr, dut.curPC);
    end
    
    always @(posedge clk) begin
        $display("Branch: UncondBr=%b, condBr=%b, brSelect=%b",
                dut.UncondBranch, dut.condBranchResult, dut.brSelect);
    end
	 
	 always @(posedge clk) begin
    if (dut.instr[31:21] == 11'b11010110000) begin  // BR instruction
        $display("BR Instruction detected!");
        $display("Rn=%d, Rd1=%h", dut.Rn, dut.Rd1);
        $display("BranchRegister=%b, UncondBranch=%b, brSelect=%b", 
                 dut.BranchRegister, dut.UncondBranch, dut.brSelect);
        $display("nextPC=%h", dut.curPC);
    end
	end
	
	// Add to cpustim.sv
always @(posedge clk) begin
    // Log all instruction execution 
    $display("Cycle %0d: PC=0x%h, Instr=0x%h", 
             cycle_count, dut.prevPC, dut.instr);
             
    // Special attention to addresses near BL FINAL
    if (dut.prevPC == 64) begin
        $display("*** REACHED BL FINAL ***");
    end
    else if (dut.prevPC == 52) begin
        $display("*** REACHED BR X5 (END) ***");
    end
    else if (dut.prevPC == 72) begin
        $display("*** REACHED FINAL ***");
    end
end
endmodule