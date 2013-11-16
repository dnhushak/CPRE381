# Simply change the project settings in this section
# for each new project. There should be no need to
# modify the rest of the script.

set library_file_list {
                           work {Basic\ Components/mips32.vhd
                           	Basic\ Components/utils.vhd
                           	Basic\ Components/Gates/and_2in.vhd
                           	Basic\ Components/Gates/inv_1bit.vhd
                           	Basic\ Components/Gates/nand_2in.vhd
                           	Basic\ Components/Gates/nor_2in.vhd
                           	Basic\ Components/Gates/or_2in.vhd
                           	Basic\ Components/Gates/or_Nin.vhd
                           	Basic\ Components/Gates/xor_2in.vhd
                           	Basic\ Components/Utility\ Components/mux_1bit_2in.vhd
                           	Basic\ Components/Utility\ Components/mux_1bit_Min.vhd
                           	Basic\ Components/Utility\ Components/mux_Nbit_2in.vhd
                           	Basic\ Components/Utility\ Components/mux_Nbit_Min.vhd
                           	Basic\ Components/Utility\ Components/decoder_Nbit.vhd
                           	Basic\ Components/Utility\ Components/extender_Nbit_Mbit.vhd
                           	Basic\ Components/Utility\ Components/onescomplementer_Nbit.vhd
                           	Basic\ Components/Utility\ Components/rightshifter_Nbit.vhd
                           	Basic\ Components/Utility\ Components/leftshifter_Nbit.vhd
                           	Basic\ Components/ALU\ Components/addersubtracter_Nbit.vhd
                           	Basic\ Components/ALU\ Components/ALU_1bit.vhd
                           	Basic\ Components/ALU\ Components/ALU_Nbit.vhd
                           	Basic\ Components/ALU\ Components/fulladder_1bit.vhd
                           	Basic\ Components/ALU\ Components/fulladder_Nbit.vhd
                           	Basic\ Components/Register\ Components/dff.vhd
                           	Basic\ Components/Register\ Components/register_Nbit.vhd
                           	Basic\ Components/Register\ Components/registerfile_Nbit_Mreg.vhd
				Basic\ Components/Testbenches/addersubtracter_Nbit_tb.vhd
                           	Basic\ Components/Testbenches/ALU_Nbit_tb.vhd
                           	Basic\ Components/Testbenches/extender_Nbit_Mbit_tb.vhd
                           	Basic\ Components/Testbenches/register_Nbit_tb.vhd}
}


# After sourcing the script from ModelSim for the
# first time use these commands to recompile.

proc r  {} {uplevel #0 source compile.tcl}
proc rr {} {global last_compile_time
            set last_compile_time 0
            r                            }
proc q  {} {quit -force                  }

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

# Prefer a fixed point font for the transcript
set PrefMain(font) {Courier 10 roman normal}

# Compile out of date files
set time_now [clock seconds]
if [catch {set last_compile_time}] {
  set last_compile_time 0
}
foreach {library file_list} $library_file_list {
  #vlib $library
  #vmap work $library
  foreach file $file_list {
    if { $last_compile_time < [file mtime $file] } {
      if [regexp {.vhdl?$} $file] {
        vcom -93 $file
      } else {
        vlog $file
      }
      set last_compile_time 0
    }
  }
}
set last_compile_time $time_now


