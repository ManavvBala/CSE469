onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpustim/clk
add wave -noupdate /cpustim/rst
add wave -noupdate /cpustim/dut/control/opcode
add wave -noupdate /cpustim/dut/control/negative
add wave -noupdate /cpustim/dut/control/zero
add wave -noupdate /cpustim/dut/control/overflow
add wave -noupdate /cpustim/dut/control/carry_out
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
add wave -noupdate -radix hexadecimal -childformat {{{/cpustim/dut/rf/register_values[31]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[30]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[29]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[28]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[27]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[26]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[25]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[24]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[23]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[22]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[21]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[20]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[19]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[18]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[17]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[16]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[15]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[14]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[13]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[12]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[11]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[10]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[9]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[8]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[7]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[6]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[5]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[4]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[3]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[2]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[1]} -radix hexadecimal} {{/cpustim/dut/rf/register_values[0]} -radix hexadecimal}} -expand -subitemconfig {{/cpustim/dut/rf/register_values[31]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[30]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[29]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[28]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[27]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[26]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[25]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[24]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[23]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[22]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[21]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[20]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[19]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[18]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[17]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[16]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[15]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[14]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[13]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[12]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[11]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[10]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[9]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[8]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[7]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[6]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[5]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[4]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[3]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[2]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[1]} {-height 15 -radix hexadecimal} {/cpustim/dut/rf/register_values[0]} {-height 15 -radix hexadecimal}} /cpustim/dut/rf/register_values
add wave -noupdate /cpustim/dut/pc/DataIn
add wave -noupdate /cpustim/dut/pc/DataOut
add wave -noupdate /cpustim/dut/instr
add wave -noupdate -radix hexadecimal /cpustim/dut/curPC
add wave -noupdate -radix hexadecimal /cpustim/dut/prevPC
add wave -noupdate /cpustim/dut/imem/address
add wave -noupdate /cpustim/dut/imem/instruction
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix hexadecimal /cpustim/dut/mainAlu/A
add wave -noupdate -radix hexadecimal /cpustim/dut/mainAlu/B
add wave -noupdate -radix binary /cpustim/dut/mainAlu/cntrl
add wave -noupdate -radix hexadecimal /cpustim/dut/mainAlu/result
add wave -noupdate -radix hexadecimal /cpustim/dut/Rd1
add wave -noupdate -radix hexadecimal /cpustim/dut/Rd2
add wave -noupdate -radix hexadecimal /cpustim/dut/ALUin
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15385567010 ps} 0}
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
WaveRestoreZoom {0 ps} {107625 us}
