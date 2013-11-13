Component Naming:

COMPONENTNAME_#BIT_#IN_#REG... etc

Start with a descriptive component name
#BIT refers to input width - a second #BIT will refer to output width
#IN refers to number of inputs
#REG, #MUX, etc. refers to number of said component within the 

Example: An extender that extends a 16 bit input to a 32 bit output:
extender_16bit_32bit.vhd

Example: a single register file with 4 32 bit registers and 2 read inputs:
regfile_32bit_2in_4reg.vhd

Any generic used should replace the # with the generic name:
extender_Nbit_Mbit.vhd

Within this extender component, the generic referring to input width would be N, and output width would be M




Port naming:
Inputs:
i_INPUTNAME

Control INPUT:
c_CONTROLNAME

Outputs:
o_OUTPUTNAME

Signals:
s_SIGNALNAME

Generate Labels:
g_GENERATENAME

Standard ports:
i_A, i_B -> Data in ports
i_C -> carry input
c_S -> select (for muxes, etc)
o_D -> data output
o_C -> carry output
o_OF -> overflow output