#==============================================================================
# Tosil Systems Pvt Ltd
# new run
# run_build.tcl
#
# Synthesis, P&R, and bitfile generation script.
#
# Usage: "vivado -mode tcl -source run_build.tcl"
#
# Engineer : Jobin Cyriac
#==============================================================================

set proj_name    "project"
set top_name     "fsm_tb"
set part_name    "xc7k70tfbv676-1"
if (![info exists add_debug])  {set add_debug 1}

if (![info exists do_phase_1]) {set do_phase_1 1} ; # create project
if (![info exists do_phase_2]) {set do_phase_2 1} ; # add design source files
if (![info exists gui_on])     {set gui_on 0}

# Build Directory
set outputDir ./build

# Project Directory (So that XIP are not overlapping)
set prjDir ./prj
# Checkpoint Directory
set cptDir $outputDir/cpt
# Release Content
set relDir $outputDir/rel
# Reports Directory
set rptDir $outputDir/rpt
# Script Directory 
set scrDir ../scripts

set start_time [clock seconds]

#
# maxThreads (Vivado default is 2 for Windows)
#
puts [concat "general.maxThreads: " [get_param general.maxThreads]]
set_param general.maxThreads 3
puts [concat "general.maxThreads: " [get_param general.maxThreads]]

set date_stamp [clock format [clock seconds] -format "%Y%m%d"]
set time_stamp [clock format [clock seconds] -format "%H%M%S"]

#========================================================================
# STAGE #0: Creating Directory structure and project
#========================================================================

# Create Directory for Outputs if it doesn't exist
if {[ file isdirectory $outputDir] == 0} {
   file mkdir $outputDir
}
if {[ file isdirectory $cptDir] == 0} {
file mkdir $cptDir
}
if {[ file isdirectory $relDir] == 0} {
file mkdir $relDir
}
if {[ file isdirectory $rptDir] == 0} {
file mkdir $rptDir
}
# Always create a new Vivado Project File & configure basic settings
create_project -part $part_name -force $prjDir/$proj_name
#if {[info exists part_name]} {
#   set_property "board_part" $part_name [current_project]
#}
set_property target_language Verilog [current_project]
set_msg_config -suppress -severity "INFO"

#========================================================================
# STAGE #1: setup design sources and constraints
#========================================================================
#read_verilog "design.v"
#add_files "top_tb.sv"
set fp [open "./files.f" r]
   while {[gets $fp line] >= 0} {
   add_files -fileset sources_1 -norecurse $line
   #sim_1 for the folder name
   }
close $fp

set fp [open "./files_tb.f" r]
   while {[gets $fp line] >= 0} {
   add_files -fileset sim_1 -norecurse $line
   #sim_1 for the folder name
   }
close $fp
#add_files "/home/toa-ltp-88/Desktop/tcl_tasks/task1/tbench/half_adder_tb.v"
set_property top fsm_tb [get_filesets sim_1]
update_compile_order -fileset sources_1
#add_files -fileset sim_1 -norecurse /home/tosil-nikhil/jenkins_projects/tb_counter_behav.wcfg
launch_simulation
run all
#exec D:/Desktop_24012024/gtkwave-3.3.100-bin-win32/gtkwave/bin/gtkwave.exe ./output.vcd ./wave.gtkw
#-------------------------------
# Get a Look Before We Exit ? --
#-------------------------------

if {$gui_on} {
     start_gui
     relaunch_sim
     run all
}
