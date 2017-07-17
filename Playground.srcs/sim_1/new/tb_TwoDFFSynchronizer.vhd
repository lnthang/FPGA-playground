----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2017 10:16:04 PM
-- Design Name: 
-- Module Name: tb_TwoDFFSynchronizer - Behavioral
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

entity tb_TwoDFFSynchronizer is
--  Port ( );
end tb_TwoDFFSynchronizer;

architecture Behavioral of tb_TwoDFFSynchronizer is
  constant CLK_PERIOD : time := 10 ns;
  constant ASYNC_CLK_PERIOD : time := 7 ns;

  component TwoDFFSynchronizer
  port 
    ( sync_clk  : in std_logic;
      async_in  : in std_logic;
      sync_out  : out std_logic );
  end component;

  signal clk      : std_logic := '0';
  signal s_async_in : std_logic := '0';
  signal s_sync_out : std_logic := '0';

begin
  uut : TwoDFFSynchronizer
  port map
    ( sync_clk => clk,
      async_in => s_async_in,
      sync_out => s_sync_out );

  clock_proc : process
  begin
    clk <= not clk;
    wait for CLK_PERIOD;
  end process clock_proc;

  async_sim_proc : process
  begin
    wait for ASYNC_CLK_PERIOD;
    s_async_in <= '1';
    wait for ASYNC_CLK_PERIOD * 10;
    s_async_in <= '0';
    wait for ASYNC_CLK_PERIOD * 1.5;
    s_async_in <= '1';

    wait;
  end process async_sim_proc;

end Behavioral;
