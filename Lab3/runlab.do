# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./adder_1bit.sv"
vlog "./adder_64bit.sv"
vlog "./alu_1bit.sv"
vlog "./alu.sv"
vlog "./alustim.sv"
vlog "./ControlUnit.sv"
vlog "./CPU.sv"
vlog "./cpustim.sv"
vlog "./DataMem.sv"
vlog "./demux1_2.sv"
vlog "./demux2_4.sv"
vlog "./demux3_8.sv"
vlog "./demux5_32.sv"
vlog "./DFF_enable.sv"
vlog "./DFF.sv"
vlog "./Instructmem.sv"
vlog "./isZero.sv"
vlog "./math.sv"
vlog "./mux2_1.sv"
vlog "./mux2xN_N.sv"
vlog "./mux4_1.sv"
vlog "./mux8_1.sv"
vlog "./mux16_1.sv"
vlog "./mux32_1.sv"
vlog "./mux64x32_1.sv"
vlog "./PC.sv"
vlog "./regfile.sv"
vlog "./register.sv"
vlog "./flag_register.sv"
vlog "./cpustim.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpustim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cpu_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
