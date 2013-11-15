puts {
  Running CPU simulation....
}
proc cpuv3  {} {vsim -voptargs=+acc work.tb_cpuv3
				do /home/dnhushak/CPRE381/cpuv3.do
				run 30000}

proc cpurefresh {} { restart -f
						run 30000}
