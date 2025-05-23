`timescale 1ns/10ps
module flag_register (
	input logic clk, enable, reset,
	input logic in_zero, in_overflow, in_negative, in_carry,
	output logic out_zero, out_overflow, out_negative, out_carry
);

    // DFF enable for each in and out
	DFF_enable zeroDFF (.d(in_zero), .q(out_zero), .clk, .reset, .enable);
	DFF_enable overflowDFF (.d(in_overflow), .q(out_overflow), .clk, .reset, .enable);
	DFF_enable negativeDFF (.d(in_negative), .q(out_negative), .clk, .reset, .enable);
	DFF_enable carryDFF (.d(in_carry), .q(out_carry), .clk, .reset, .enable);

endmodule 