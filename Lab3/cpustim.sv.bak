`timescale 1ns/10ps

module cpustim();

    // Parameters
    parameter CLOCK_PERIOD = 1000000;  // 1 ms clock period (very long)
    parameter MAX_CYCLES = 100;        // Adjust based on your program length

    // Signals
    logic clk;
    logic rst;

    // Instantiate the CPU
    CPU dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    // Force %t's to print in a nice format
    initial $timeformat(-9, 2, " ns", 10);

    // Test sequence
    integer cycle_count;
    initial begin
        // Initialize
        rst = 1;
        cycle_count = 0;
        
        // Apply reset for one clock cycle
        @(posedge clk);
        #(CLOCK_PERIOD/10);
        rst = 0;
        
        // Run for MAX_CYCLES or until program completion
        for (cycle_count = 0; cycle_count < MAX_CYCLES; cycle_count++) begin
            @(posedge clk);
            
            // Display cycle information
            $display("Cycle %d: PC = %h, Instruction = %h", 
                    cycle_count, dut.prevPC, dut.instr);
                    
            // Display register values for debugging
            $display("  Registers: Rd1 = %h, Rd2 = %h", dut.Rd1, dut.Rd2);
            $display("  ALU Output: %h", dut.aluOut);
            
            // Optional: Check for program completion
            // For example, if the instruction is a specific halt instruction
            // or if PC stops changing, we can exit
            if (dut.instr == 32'hD503201F) begin  // NOP instruction typically used for ending
                $display("Program complete: NOP instruction detected");
                break;
            end
            
            // Alternative completion detection: if PC doesn't change after a cycle
            if (cycle_count > 0 && (dut.prevPC == dut.curPC)) begin
                $display("Program complete: PC not advancing");
                break;
            end
        end
        
        // End simulation
        if (cycle_count >= MAX_CYCLES) begin
            $display("Simulation reached maximum cycle count (%d)", MAX_CYCLES);
        end
        else begin
            $display("Program completed after %d cycles", cycle_count);
        }
        
        // Display final register values or memory state if desired
        $display("Final PC value: %h", dut.prevPC);
        
        // End simulation
        $finish;
    end

    // Optional: Monitor other signals for debugging
    initial begin
        $monitor("Time = %t, PC = %h, Instr = %h, ALUOut = %h, RegWrite = %b",
                $time, dut.prevPC, dut.instr, dut.aluOut, dut.RegWrite);
    end

endmodule