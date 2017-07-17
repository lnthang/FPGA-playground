----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2017 04:43:59 PM
-- Design Name: 
-- Module Name: TwoDFFSynchronizer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity TwoDFFSynchronizer is
  port 
    ( sync_clk  : in std_logic;
      async_in  : in std_logic;
      sync_out  : out std_logic );
end entity TwoDFFSynchronizer;

architecture Behavioral of TwoDFFSynchronizer is
  signal sync_dff1, sync_dff2 : std_logic := '0';

begin

  sync_proc: process(sync_clk)
  begin
    if rising_edge(sync_clk) then
      sync_dff1 <= async_in;
      sync_dff2 <= sync_dff1;
      sync_out <= sync_dff2;
    end if;
  end process sync_proc;

end architecture Behavioral;
