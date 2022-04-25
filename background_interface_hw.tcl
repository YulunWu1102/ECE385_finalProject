# TCL File Generated by Component Editor 18.1
# Mon Apr 25 15:57:47 CDT 2022
# DO NOT MODIFY


# 
# background_interface "background_interface" v1.0
# Yulun Wu 2022.04.25.15:57:47
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module background_interface
# 
set_module_property DESCRIPTION ""
set_module_property NAME background_interface
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Final Project Custom IPs"
set_module_property AUTHOR "Yulun Wu"
set_module_property DISPLAY_NAME background_interface
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL background_interface
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file background_interface.sv SYSTEM_VERILOG PATH background_interface.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL background_interface
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file background_interface.sv SYSTEM_VERILOG PATH background_interface.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point CLK
# 
add_interface CLK clock end
set_interface_property CLK clockRate 50000000
set_interface_property CLK ENABLED true
set_interface_property CLK EXPORT_OF ""
set_interface_property CLK PORT_NAME_MAP ""
set_interface_property CLK CMSIS_SVD_VARIABLES ""
set_interface_property CLK SVD_ADDRESS_GROUP ""

add_interface_port CLK CLK clk Input 1


# 
# connection point RESET
# 
add_interface RESET reset end
set_interface_property RESET associatedClock CLK
set_interface_property RESET synchronousEdges DEASSERT
set_interface_property RESET ENABLED true
set_interface_property RESET EXPORT_OF ""
set_interface_property RESET PORT_NAME_MAP ""
set_interface_property RESET CMSIS_SVD_VARIABLES ""
set_interface_property RESET SVD_ADDRESS_GROUP ""

add_interface_port RESET RESET reset Input 1


# 
# connection point VGA_port
# 
add_interface VGA_port conduit end
set_interface_property VGA_port associatedClock CLK
set_interface_property VGA_port associatedReset ""
set_interface_property VGA_port ENABLED true
set_interface_property VGA_port EXPORT_OF ""
set_interface_property VGA_port PORT_NAME_MAP ""
set_interface_property VGA_port CMSIS_SVD_VARIABLES ""
set_interface_property VGA_port SVD_ADDRESS_GROUP ""

add_interface_port VGA_port backgroundDATA backgrounddata Output 8
add_interface_port VGA_port LOCAL_ADDR local_addr Input 16


# 
# connection point avl_mm_slave
# 
add_interface avl_mm_slave avalon end
set_interface_property avl_mm_slave addressUnits WORDS
set_interface_property avl_mm_slave associatedClock CLK
set_interface_property avl_mm_slave associatedReset RESET
set_interface_property avl_mm_slave bitsPerSymbol 8
set_interface_property avl_mm_slave burstOnBurstBoundariesOnly false
set_interface_property avl_mm_slave burstcountUnits WORDS
set_interface_property avl_mm_slave explicitAddressSpan 0
set_interface_property avl_mm_slave holdTime 0
set_interface_property avl_mm_slave linewrapBursts false
set_interface_property avl_mm_slave maximumPendingReadTransactions 0
set_interface_property avl_mm_slave maximumPendingWriteTransactions 0
set_interface_property avl_mm_slave readLatency 0
set_interface_property avl_mm_slave readWaitTime 1
set_interface_property avl_mm_slave setupTime 0
set_interface_property avl_mm_slave timingUnits Cycles
set_interface_property avl_mm_slave writeWaitTime 0
set_interface_property avl_mm_slave ENABLED true
set_interface_property avl_mm_slave EXPORT_OF ""
set_interface_property avl_mm_slave PORT_NAME_MAP ""
set_interface_property avl_mm_slave CMSIS_SVD_VARIABLES ""
set_interface_property avl_mm_slave SVD_ADDRESS_GROUP ""

add_interface_port avl_mm_slave AVL_ADDR address Input 16
add_interface_port avl_mm_slave AVL_READ read Input 1
add_interface_port avl_mm_slave AVL_WRITE write Input 1
add_interface_port avl_mm_slave AVL_CS chipselect Input 1
add_interface_port avl_mm_slave AVL_WRITEDATA writedata Input 8
add_interface_port avl_mm_slave AVL_READDATA readdata Output 8
set_interface_assignment avl_mm_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avl_mm_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avl_mm_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avl_mm_slave embeddedsw.configuration.isPrintableDevice 0

