----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2017 10:56:14 PM
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Top is
  port ( clkIn12MHz   : in STD_LOGIC;
         uartRx       : in STD_LOGIC;
         uartTx       : out STD_LOGIC );
end entity Top;

architecture Behavioral of Top is
  --=================== Clock generator
  component ClkGenerator_1 
  port
    ( clkIn12MHz    : in std_logic;
      reset         : in std_logic;
      locked        : out std_logic;
      clkOut100MHz  : out std_logic );
  end component ClkGenerator_1;

  --=================== Simple Uart
  component SimpleUart
  port
    ( clk      : in STD_LOGIC;
      rx       : in STD_LOGIC;
      tx       : out STD_LOGIC;
      ------------
      tx_byte  : in STD_LOGIC_VECTOR(7 downto 0);
      rx_byte  : out STD_LOGIC_VECTOR(7 downto 0);
      tx_start : in STD_LOGIC;
      rx_done  : out STD_LOGIC );
  end component SimpleUart;

  --=================== Synchronizer for input
  component TwoDFFSynchronizer
  port
    ( sync_clk  : in std_logic;
      async_in  : in std_logic;
      sync_out  : out std_logic );
  end component;

  signal sysClk100MHz   : std_logic;
  signal s_asyncUartRx  : std_logic;
  signal s_syncUartRx   : std_logic;

  signal s_uartRxDone   : std_logic;
  signal s_uartRxByte   : std_logic_vector(7 downto 0);

begin
  main_clockGenerator_unit : ClkGenerator_1
  port map
    ( clkIn12MHz => clkIn12MHz,
      reset => '0',
      locked => open,
      clkOut100MHz => sysClk100MHz );

  uart_rxSynchronizer_unit : TwoDFFSynchronizer
  port map
    ( sync_clk => sysClk100MHz,
      async_in => uartRx,
      sync_out => s_syncUartRx );

  uart_debugInfo_unit : SimpleUart
  port map
    ( clk => sysClk100MHz,
      rx => s_syncUartRx,
      tx => uartTx,

      tx_byte => s_uartRxByte,
      rx_byte => s_uartRxByte,
      tx_start => s_uartRxDone,
      rx_done => s_uartRxDone );

end Behavioral;
