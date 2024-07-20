# GoBoard Template
Template project and makefile for building Systemverilog hardware designs for the [Nandland Go Board](https://nandland.com/the-go-board/) development board using an open-source toolchain on Linux.

The template implements a typical Blinky project with the 25MHz clock divided down and used to blink the green LED.  

If all is well with your installation (toolchain), this should work without problems out of the box.

NOTE: The ICE40 HX1K () package used on the GoBoard does not bond the PLL to a pin, so the maximum clock speed available is 25MHz.

## Toolchain

This requires the following tooling, all of which can be obtained from [YosysHQ](https://github.com/YosysHQ)

|Tool|Purpose|
|----|----|
|yosys| HDL Parse & Synthesis|
|nextprn| Place & Route (fitting)|
|iverilog| Linting and simulation|
|icestorm| Bitstream generation and utilities for ICE40 FPGA line|

It also uses [GtkWave](https://gtkwave.sourceforge.net/) to display simulation waveforms (VCD).

## Folders

| Folder | Purpose |
| ----|---|
| src/hdl | Hardware design source files (synthesis)|
| src/tb  | Verification test benches (simulation)|
| build   | All build outputs (created during the build process)|
| .vscode | VS Code related files|

The hdl and tb folders include a skeleton top module.  

## Makefile
The template is built using a makefile (make).  It provides only Linux support. 

You can change the PROJECT variable in the makefile to match your project name.  

All other configuration is set for the GoBoard development board, if you are using a different board you will need to change this.

Add additional sources and test benches to the SRCS and SRCS_TB variables as your project grows.

| Target | Purpose |
| -------|---------|
| all    | Builds and programs the project onto the GoBoard|
| clean  | Removes the build outputs|
| lint   | Runs iverilog to lint the HDL source code|
| synthesis| Runs yosys to parse and synthesise netlist|
| pnr | Runs nextpnr to fit (place and route) the design onto FPGA|
| pack | Packs the bitstream|
| prog | Uploads the bitstream to flash|
| timing | Generates a simple timing report|
| floorplan | Opens nextpnr in GUI mode to show floor planning|
| sim | Run simulation using iverilog/vpp; this will display outputs at completion|
| test | Runs verification| 

## VS Code Configuration
I use VS Code as an IDE for Lattice FPGA development.  The .vscode folder contains configuration (JSON) files for VS Code.

| File | Purpose | 
| -----| ------- |
| extensions.json| A list of extensions that are useful when working with Verilog|
| tasks.json| Tasks for executing selected makefile targets |

## SVLS Extension
This is a Systemverilog Language Server.  The .svlint.toml file located in the root of the project configures which rules are checked.  These are documented (somewhat erratically) on the SVLS website.  

It is quite possible to create rules that contradict each other, in fact if no .svlint.toml is configured then all rules are active and exactly this happens.

## VerilogHDL Extension

If you are using the Verilog extension then you will need to add the following to your settings.json (or configure directly in the extension):

```json
"verilog.linting.iverilog.arguments": "-Wall -Y.sv -y ./src/hdl -y ./src/tb  -l /usr/local/share/yosys/ice40/cells_sim.v",
"verilog.linting.linter": "iverilog",
"verilog.linting.iverilog.runAtFileLocation": false
```

Iverilog searches for unknown modules by looking for a file with the same name as the module in the source folders.

That is, it looks to resolve **i2s_mod** by searching for a file called **i2s_mod.sv**.  

The -Y and -y flags configure the file type suffix and folders respectively 

``` -Y.sv -y ./src/hdl -y ./src/tb```

The folders are relative to the top-level folder.


## Other Files
The top-level folder contains:

| File | Purpose | 
| -----| ------- |
| makefile | The makefile for the template|
| .gitignore | Files/folders that should not be committed to Git|
| .svlint.toml| Linting rules for the svls language server extension (vscode)|
| goboard.pcf| The constraints file for the GoBoard board|
| README.md| This file|




