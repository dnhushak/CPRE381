proc cpucompile {} {	r

			set library_file_list {
                           work {Project-B/SCPv2b/cpuv3.vhd
                           	Project-B/SCPv2b/tb_cpuv3.vhd
                           	Project-B/SCPv2b/components/alucontrolv3.vhd
				Project-B/SCPv2b/components/controlv3.vhd
				Project-B/SCPv2b/components/mem.vhd}
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

proc cpurefresh {} { 	restart -f
			run 30000}
