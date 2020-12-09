transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Aabjeet/cse141l-lab4/src {C:/Users/Aabjeet/cse141l-lab4/src/RegFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aabjeet/cse141l-lab4/src {C:/Users/Aabjeet/cse141l-lab4/src/InstFetch.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aabjeet/cse141l-lab4/src {C:/Users/Aabjeet/cse141l-lab4/src/DataMem.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aabjeet/cse141l-lab4/src {C:/Users/Aabjeet/cse141l-lab4/src/Ctrl.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aabjeet/cse141l-lab4/src {C:/Users/Aabjeet/cse141l-lab4/src/CPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aabjeet/cse141l-lab4/src {C:/Users/Aabjeet/cse141l-lab4/src/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aabjeet/cse141l-lab4/src {C:/Users/Aabjeet/cse141l-lab4/src/InstROM.v}

