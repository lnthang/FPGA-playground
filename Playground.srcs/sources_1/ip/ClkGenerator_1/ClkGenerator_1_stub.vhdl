-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
-- Date        : Mon Jul 17 23:03:19 2017
-- Host        : DESKTOP-EDIDKQP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/workspace/git/Playground/Playground.srcs/sources_1/ip/ClkGenerator_1/ClkGenerator_1_stub.vhdl
-- Design      : ClkGenerator_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35ticpg236-1L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClkGenerator_1 is
  Port ( 
    clkOut100MHz : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clkIn12MHz : in STD_LOGIC
  );

end ClkGenerator_1;

architecture stub of ClkGenerator_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clkOut100MHz,reset,locked,clkIn12MHz";
begin
end;
