transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System/Altera_Mem_Dual_Port {C:/Users/525hm/Desktop/MIPS_design/MIPS_System/Altera_Mem_Dual_Port/ram2port_inst_data.v}
vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System {C:/Users/525hm/Desktop/MIPS_design/MIPS_System/MIPS_System.v}
vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System/Timer {C:/Users/525hm/Desktop/MIPS_design/MIPS_System/Timer/TimerCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System/MIPS_CPU {C:/Users/525hm/Desktop/MIPS_design/MIPS_System/MIPS_CPU/mipsparts.v}
vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System/GPIO {C:/Users/525hm/Desktop/MIPS_design/MIPS_System/GPIO/GPIO.v}
vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System/Decoder {C:/Users/525hm/Desktop/MIPS_design/MIPS_System/Decoder/Addr_Decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System/Altera_PLL {C:/Users/525hm/Desktop/MIPS_design/MIPS_System/Altera_PLL/ALTPLL_clkgen.v}
vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System_Syn/db {C:/Users/525hm/Desktop/MIPS_design/MIPS_System_Syn/db/altpll_clkgen_altpll.v}
vlog -vlog01compat -work work +incdir+C:/Users/525hm/Desktop/MIPS_design/MIPS_System/MIPS_CPU {C:/Users/525hm/Desktop/MIPS_design/MIPS_System/MIPS_CPU/mips.v}

