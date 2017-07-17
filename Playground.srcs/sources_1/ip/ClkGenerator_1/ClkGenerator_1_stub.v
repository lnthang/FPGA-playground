// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Mon Jul 17 23:03:19 2017
// Host        : DESKTOP-EDIDKQP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/workspace/git/Playground/Playground.srcs/sources_1/ip/ClkGenerator_1/ClkGenerator_1_stub.v
// Design      : ClkGenerator_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticpg236-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ClkGenerator_1(clkOut100MHz, reset, locked, clkIn12MHz)
/* synthesis syn_black_box black_box_pad_pin="clkOut100MHz,reset,locked,clkIn12MHz" */;
  output clkOut100MHz;
  input reset;
  output locked;
  input clkIn12MHz;
endmodule
