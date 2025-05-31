onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpustim/clk
add wave -noupdate /cpustim/rst
add wave -noupdate /cpustim/dut/brSelect
add wave -noupdate /cpustim/dut/control/opcode
add wave -noupdate /cpustim/dut/regflag/out_zero
add wave -noupdate /cpustim/dut/regflag/out_overflow
add wave -noupdate /cpustim/dut/regflag/out_negative
add wave -noupdate /cpustim/dut/regflag/out_carry
add wave -noupdate /cpustim/dut/mainAlu/negative
add wave -noupdate /cpustim/dut/mainAlu/zero
add wave -noupdate /cpustim/dut/mainAlu/overflow
add wave -noupdate /cpustim/dut/mainAlu/carry_out
add wave -noupdate /cpustim/dut/control/Reg2Loc
add wave -noupdate /cpustim/dut/control/UncondBranch
add wave -noupdate /cpustim/dut/control/BRTaken
add wave -noupdate /cpustim/dut/control/MemRead
add wave -noupdate /cpustim/dut/control/MemToReg
add wave -noupdate /cpustim/dut/control/ALUOp0
add wave -noupdate /cpustim/dut/control/ALUOp1
add wave -noupdate /cpustim/dut/control/MemWrite
add wave -noupdate /cpustim/dut/control/ALUSrc
add wave -noupdate /cpustim/dut/control/RegWrite
add wave -noupdate /cpustim/dut/control/ZExt
add wave -noupdate /cpustim/dut/control/BranchLink
add wave -noupdate /cpustim/dut/control/BranchRegister
add wave -noupdate /cpustim/dut/control/CheckForLT
add wave -noupdate /cpustim/dut/negativeSelect
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[80]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[79]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[78]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[77]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[76]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[75]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[74]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[73]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[72]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[71]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[70]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[69]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[68]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[67]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[66]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[65]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[64]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[63]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[62]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[61]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[60]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[59]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[58]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[57]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[56]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[55]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[54]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[53]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[52]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[51]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[50]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[49]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[48]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[47]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[46]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[45]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[44]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[43]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[42]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[41]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[40]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[39]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[38]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[37]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[36]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[35]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[34]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[33]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[32]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[31]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[30]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[29]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[28]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[27]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[26]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[25]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[24]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[23]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[22]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[21]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[20]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[19]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[18]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[17]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[16]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[15]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[14]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[13]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[12]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[11]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[10]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[9]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[8]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[7]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[6]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[5]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[4]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[3]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[2]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[1]}
add wave -noupdate -group Memory {/cpustim/dut/dataMemory/mem[0]}
add wave -noupdate -radix hexadecimal -childformat {{{/cpustim/dut/rf/register_values[31]} -radix decimal} {{/cpustim/dut/rf/register_values[30]} -radix decimal} {{/cpustim/dut/rf/register_values[29]} -radix decimal} {{/cpustim/dut/rf/register_values[28]} -radix decimal} {{/cpustim/dut/rf/register_values[27]} -radix decimal} {{/cpustim/dut/rf/register_values[26]} -radix decimal} {{/cpustim/dut/rf/register_values[25]} -radix decimal} {{/cpustim/dut/rf/register_values[24]} -radix decimal} {{/cpustim/dut/rf/register_values[23]} -radix decimal} {{/cpustim/dut/rf/register_values[22]} -radix decimal} {{/cpustim/dut/rf/register_values[21]} -radix decimal} {{/cpustim/dut/rf/register_values[20]} -radix decimal} {{/cpustim/dut/rf/register_values[19]} -radix decimal} {{/cpustim/dut/rf/register_values[18]} -radix decimal} {{/cpustim/dut/rf/register_values[17]} -radix decimal} {{/cpustim/dut/rf/register_values[16]} -radix decimal} {{/cpustim/dut/rf/register_values[15]} -radix decimal} {{/cpustim/dut/rf/register_values[14]} -radix decimal} {{/cpustim/dut/rf/register_values[13]} -radix decimal} {{/cpustim/dut/rf/register_values[12]} -radix decimal} {{/cpustim/dut/rf/register_values[11]} -radix decimal} {{/cpustim/dut/rf/register_values[10]} -radix decimal} {{/cpustim/dut/rf/register_values[9]} -radix decimal} {{/cpustim/dut/rf/register_values[8]} -radix decimal} {{/cpustim/dut/rf/register_values[7]} -radix decimal} {{/cpustim/dut/rf/register_values[6]} -radix decimal} {{/cpustim/dut/rf/register_values[5]} -radix decimal} {{/cpustim/dut/rf/register_values[4]} -radix decimal} {{/cpustim/dut/rf/register_values[3]} -radix decimal} {{/cpustim/dut/rf/register_values[2]} -radix decimal} {{/cpustim/dut/rf/register_values[1]} -radix decimal} {{/cpustim/dut/rf/register_values[0]} -radix decimal}} -expand -subitemconfig {{/cpustim/dut/rf/register_values[31]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[30]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[29]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[28]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[27]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[26]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[25]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[24]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[23]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[22]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[21]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[20]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[19]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[18]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[17]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[16]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[15]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[14]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[13]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[12]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[11]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[10]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[9]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[8]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[7]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[6]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[5]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[4]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[3]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[2]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[1]} {-height 15 -radix decimal} {/cpustim/dut/rf/register_values[0]} {-height 15 -radix decimal}} /cpustim/dut/rf/register_values
add wave -noupdate /cpustim/dut/BranchRegisterMem
add wave -noupdate -radix unsigned /cpustim/dut/rf/ReadRegister1
add wave -noupdate -radix unsigned /cpustim/dut/rf/ReadRegister2
add wave -noupdate -radix decimal /cpustim/dut/rf/ReadData1
add wave -noupdate -radix unsigned /cpustim/dut/rf/ReadData2
add wave -noupdate /cpustim/dut/pc/DataIn
add wave -noupdate /cpustim/dut/pc/DataOut
add wave -noupdate /cpustim/dut/imem/address
add wave -noupdate /cpustim/dut/imem/instruction
add wave -noupdate -radix unsigned /cpustim/dut/RnID
add wave -noupdate -radix unsigned /cpustim/dut/RmID
add wave -noupdate -radix unsigned /cpustim/dut/RdID
add wave -noupdate -divider ALU
add wave -noupdate /cpustim/dut/regflag/in_zero
add wave -noupdate /cpustim/dut/regflag/in_overflow
add wave -noupdate /cpustim/dut/regflag/in_negative
add wave -noupdate /cpustim/dut/regflag/in_carry
add wave -noupdate /cpustim/dut/regflag/out_zero
add wave -noupdate /cpustim/dut/regflag/out_overflow
add wave -noupdate /cpustim/dut/regflag/out_negative
add wave -noupdate /cpustim/dut/regflag/out_carry
add wave -noupdate /cpustim/dut/SetFlagEX
add wave -noupdate /cpustim/dut/tryforwardMuxOutA
add wave -noupdate /cpustim/dut/tryforwardMuxOutB
add wave -noupdate -radix decimal /cpustim/dut/Rd1ID
add wave -noupdate -radix decimal /cpustim/dut/Rd1EX
add wave -noupdate -radix decimal /cpustim/dut/WriteDataWB
add wave -noupdate /cpustim/dut/ForwardA
add wave -noupdate /cpustim/dut/ForwardB
add wave -noupdate -radix decimal /cpustim/dut/mainAlu/A
add wave -noupdate -radix decimal /cpustim/dut/mainAlu/B
add wave -noupdate -radix binary /cpustim/dut/mainAlu/cntrl
add wave -noupdate -radix decimal /cpustim/dut/mainAlu/result
add wave -noupdate -radix unsigned /cpustim/dut/RdWB
add wave -noupdate /cpustim/dut/RegWriteWB
add wave -noupdate -radix unsigned /cpustim/dut/RdEX
add wave -noupdate /cpustim/dut/RmEX
add wave -noupdate -radix decimal /cpustim/dut/ALUResultEX
add wave -noupdate -radix decimal /cpustim/dut/ALUResultMem
add wave -noupdate -radix decimal /cpustim/dut/ALUResultWB
add wave -noupdate -divider Stor
add wave -noupdate /cpustim/dut/ForwardBMuxOut
add wave -noupdate /cpustim/dut/ForwardRd
add wave -noupdate /cpustim/dut/ForwardRdMuxOut
add wave -noupdate /cpustim/dut/StoreDataMuxOut
add wave -noupdate /cpustim/dut/Rd2Mem
add wave -noupdate -divider {PC Values}
add wave -noupdate /cpustim/dut/ForwardTryA
add wave -noupdate /cpustim/dut/ForwardTryB
add wave -noupdate /cpustim/dut/direct_zero_check
add wave -noupdate -radix hexadecimal /cpustim/dut/Rd2ID
add wave -noupdate /cpustim/dut/BranchRegister
add wave -noupdate -radix hexadecimal /cpustim/dut/regAdderOut
add wave -noupdate -radix hexadecimal /cpustim/dut/brAddr
add wave -noupdate /cpustim/dut/brSelect
add wave -noupdate -radix hexadecimal /cpustim/dut/finalPCMuxIntermediate
add wave -noupdate -radix hexadecimal /cpustim/dut/curPC
add wave -noupdate -radix hexadecimal /cpustim/dut/prevPC
add wave -noupdate -radix hexadecimal /cpustim/dut/PCID
add wave -noupdate -radix hexadecimal /cpustim/dut/PCEX
add wave -noupdate -radix hexadecimal /cpustim/dut/PCMem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {614017480 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
configure wave -valuecolwidth 254
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 100
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {243882766 ps} {1658550190 ps}
bookmark add wave bookmark0 {{25142991717 ps} {35272210485 ps}} 112
