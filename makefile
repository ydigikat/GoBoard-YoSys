# Yosys makefile for GoBoard (ICE40HX1K FPGA) projects 
#
# Requires: yosys, icestorm, iverilog and nextpnr to be installed correctly.

PROJECT		=	project

# Configuration
DEVICE		=	hx1k
PACKAGE		=	vq100
PCF			=   goboard.pcf
TOP			= 	mod_top

# Directories
SRC			=   src
BUILD		=	build
TOOLS		=	/usr/local/bin
BIN			=	/usr/bin

# Linter (iverilog)
LINT		=	$(TOOLS)/iverilog
LINT_FLAGS  +=	-g2005-sv -Wall -t null
LINT_FLAGS  +=  -l /usr/local/share/yosys/ice40/cells_sim.v 

# Synthesiser (yosys)
SYNTH 		=	$(TOOLS)/yosys
SYNTH_FLAGS +=	-p 'synth_ice40 -abc9 -top $(TOP) -json $(BUILD)/$(PROJECT).json'

# Place & Route (nextpnr)
PNR			=	$(TOOLS)/nextpnr-ice40 
PNR_FLAGS	=	--$(DEVICE) --package $(PACKAGE) --pcf $(PCF)
PNR_FLAGS	+=  --json $(BUILD)/$(PROJECT).json 
PNR_FLAGS   +=  --asc $(BUILD)/$(PROJECT).asc

# Bitstream (icestorm)
PACK		= 	$(TOOLS)/icepack
PROG		=	$(TOOLS)/iceprog

# Reports (icestorm)
TIME		=	$(TOOLS)/icetime
TIME_FLAGS  =   -tmd $(DEVICE)

# Simulator (iverilog)
SIM			=	$(TOOLS)/iverilog
SIM_FLAGS   =   -g2005-sv -D NO_ICE40_DEFAULT_ASSIGNMENTS
SIM_FLAGS   +=  -B /usr/local/lib/ivl
SIM_FLAGS   +=  -o $(BUILD)/$(PROJECT).out 
SIM_FLAGS	+=  -D VCD_OUTPUT=$(BUILD)/$(PROJECT)
SIM_FLAGS	+=  /usr/local/share/yosys/ice40/cells_sim.v
VVP			= 	$(TOOLS)/vvp
VVP_FLAGS	=	-M /usr/local/lib/ivl

# Wave (VCD) Viewer
VCD			=	gtkwave

# Sources

SRCS        =	$(SRC)/hdl/top.sv 
SRCS_TB		=	$(SRC)/tb/top_tb.sv

				
# Targets

.PHONY: all clean lint synthesise pnr pack prog timing

all: clean lint synthesise pnr timing pack prog

clean:
	rm -rf $(BUILD)

lint: 
	$(LINT) $(LINT_FLAGS) $(SRCS)

synthesise: lint
	mkdir -p $(BUILD)
	$(SYNTH) $(SYNTH_FLAGS) $(SRCS)

fit: synthesise
	$(PNR) $(PNR_FLAGS)

pack: fit
	$(PACK) $(BUILD)/$(PROJECT).asc $(BUILD)/$(PROJECT).bin

prog: pack
	$(PROG) $(BUILD)/$(PROJECT).bin

timing: fit
	$(TIME) $(TIME_FLAGS) $(BUILD)/$(PROJECT).asc

floorplan: synthesise
	$(PNR) $(PNR_FLAGS) --gui

sim:
	mkdir -p $(BUILD)
	$(SIM) $(SIM_FLAGS) $(SRCS) $(SRCS_TB)
	$(VVP) $(VVP_FLAGS) $(BUILD)/$(PROJECT).out
	$(VCD) $(BUILD)/$(PROJECT).vcd $(BUILD)/$(PROJECT).out

# #
# # Runs testbenches without wave viewer
# #
# tests:
# 	@$(SIM_TOOL) $(SIM_CMD) $(SRCFILES) $(SIM)/serial_rx_tb.sv; $(VVP_TOOL) $(VVP_CMD) $(BUILD)/$(PROJ).out 
# 	@$(SIM_TOOL) $(SIM_CMD) $(SRCFILES) $(SIM)/i2s_tx_tb.sv; $(VVP_TOOL) $(VVP_CMD) $(BUILD)/$(PROJ).out


