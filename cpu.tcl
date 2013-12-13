proc cpucompile {} {	r

			set library_file_list {
                           work {Project-B/SCPv3/components/cpurecords.vhd
                           		Project-B/SCPv3/components/instruction_decoder.vhd
                           		Project-B/SCPv3/components/alucontrolv3.vhd
								Project-B/SCPv3/components/controlv3.vhd
								Project-B/SCPv3/components/mem.vhd
								Project-B/SCPv3/cpuv3.vhd
                           		Project-B/SCPv3/tb_cpuv3.vhd
                           		Project-C/SCPv4/components/cpurecordsv4.vhd
                           		Project-C/SCPv4/components/instruction_decoder.vhd
                           		Project-C/SCPv4/components/alucontrolv4.vhd
								Project-C/SCPv4/components/controlv4.vhd
								Project-C/SCPv4/components/ifid_reg.vhd
								Project-C/SCPv4/components/idex_reg.vhd
								Project-C/SCPv4/components/exmem_reg.vhd
								Project-C/SCPv4/components/memwb_reg.vhd
								Project-C/SCPv4/components/mem.vhd
								Project-C/SCPv4/cpuv4.vhd
                           		Project-C/SCPv4/tb_cpuv4.vhd}
			}


			uplevel #0 source cpu.tcl
			global last_cpu_compile_time
            		set last_cpu_compile_time 0


			#Does this installation support Tk?
			set tk_ok 1
			if [catch {package require Tk}] {set tk_ok 0}

			# Prefer a fixed point font for the transcript
			set PrefMain(font) {Courier 10 roman normal}

			# Compile out of date files
			set time_now [clock seconds]
			if [catch {set last_cpu_compile_time}] {
			  set last_cpu_compile_time 0
			}
			foreach {library file_list} $library_file_list {
  				#vlib $library
  				#vmap work $library
  				foreach file $file_list {
    					if { $last_cpu_compile_time < [file mtime $file] } {
      						if [regexp {.vhdl?$} $file] {
        						vcom -93 $file
      						} else {
      							vlog $file
      						}
      						set last_cpu_compile_time 0
    					}
  				}
			}
			set last_cpu_compile_time $time_now}

proc cpusim  {} {vsim -voptargs=+acc work.tb_cpuv3
				do /home/dnhushak/CPRE381/cpuv3.do
				run 30000}
				
proc cpu2sim  {} {vsim -voptargs=+acc work.tb_cpuv4
				do /home/dnhushak/CPRE381/cpuv4.do
				run 30000}

proc cpurefresh {} { 	restart -f
			run 30000}

proc mem2dump {} {	mem save -dataradix dec -wordsperline 1 -outfile /home/dnhushak/CPRE381/memdump.mif /tb_cpuv4/data_mem/mem}

proc memdump {} {	mem save -dataradix dec -wordsperline 1 -outfile /home/dnhushak/CPRE381/memdump.mif /tb_cpuv3/data_mem/mem}

