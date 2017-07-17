----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2017 04:43:59 PM
-- Design Name: 
-- Module Name: SimpleUart - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SimpleUart is
  port ( clk      : in STD_LOGIC;
         rx       : in STD_LOGIC;
         tx       : out STD_LOGIC;
         ------------
         tx_byte  : in STD_LOGIC_VECTOR(7 downto 0);
         rx_byte  : out STD_LOGIC_VECTOR(7 downto 0);
         tx_start : in STD_LOGIC;
         rx_done  : out STD_LOGIC );
end SimpleUart;

architecture Behavioral of SimpleUart is
  signal s_startsampling_en   : STD_LOGIC := '0';
  signal s_sampling_tick      : STD_LOGIC := '0';
  signal s_sampling_tick_pre  : STD_LOGIC := '0';
  
  signal s_rx_latch1   : STD_LOGIC := '0';
  signal s_rx_latch2   : STD_LOGIC := '0';
  
  signal s_bit_cnt    : INTEGER := 0;
  
  signal s_rx_byte    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  signal s_rx_done    : STD_LOGIC := '0';
  
  signal s_tx_byte    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  signal s_tx_start_latch : STD_LOGIC := '0';
  signal s_tx_tick  : STD_LOGIC := '0';
  signal s_tx_tick_pre  : STD_LOGIC := '0';
  signal s_tx_done  : STD_LOGIC := '0';
  signal s_tx_en    : STD_LOGIC := '0';
  signal s_tx       : STD_LOGIC := '1';
  signal s_tx_bit_cnt : INTEGER := 0;
  
begin
  
  uart_detect_start_proc  : process (clk, rx, s_bit_cnt, s_startsampling_en)
  begin
    if rising_edge(clk) then
      s_rx_latch1 <= rx;
      s_rx_latch2 <= s_rx_latch1;
      
      -- Start condition
      if (s_rx_latch2 = '1') and (s_rx_latch1 = '0') and (s_startsampling_en = '0') then
        s_startsampling_en <= '1';
        s_rx_done <= '0';
      end if;
      
      if (s_bit_cnt >= 9) then
        s_startsampling_en <= '0';
        s_rx_done <= '1';
      end if;
    end if;  
  end process uart_detect_start_proc;
  
  ------------------------------------------------------------------------
  uart_sampling_tick_proc : process (clk, s_startsampling_en)
    variable v_tick_cnt : INTEGER := 0;
    
  begin
    if (s_startsampling_en = '0') then
      v_tick_cnt := 0;
      s_sampling_tick <= '0';
      
    elsif rising_edge(clk) then
      v_tick_cnt := v_tick_cnt + 1;
      
      -- ONLY support Baudrate 76800 which is 13us per bit
      -- System clk is 10ns per tick => we need 1300 tick per bit
      -- A signal will toggle 1300/2 = 650 ticks to create a rising_edge
      --  every 13us to signal sampling process.
      if (v_tick_cnt >= 650) then
        s_sampling_tick <= not s_sampling_tick;
        v_tick_cnt := 0;
      end if;
    end if;
  
  end process uart_sampling_tick_proc;
  ------------------------------------------------------------------------
  
  uart_sampling_proc : process (clk, s_sampling_tick, s_startsampling_en)
  begin
    if (s_startsampling_en = '0') then
      s_bit_cnt <= 0;
      --s_rx_done <= '0';
    
    elsif rising_edge(clk) then
      s_sampling_tick_pre <= s_sampling_tick;
      
      if (s_sampling_tick_pre = '0') and (s_sampling_tick = '1') then
        if (s_bit_cnt = 0) then
          NULL;
        elsif (s_bit_cnt < 9) then
          s_rx_byte <= rx & s_rx_byte(7 downto 1);
        end if;
        
        
        --else
        s_bit_cnt <= s_bit_cnt + 1;
        --end if;
      end if;
      
      if (s_bit_cnt >= 9) then
        --s_bit_cnt <= 0;
        --s_rx_done <= '1';
        rx_byte <= s_rx_byte;
      end if;
    end if;
  end process uart_sampling_proc;
  
  rx_done <= s_rx_done;
  
  --------------------------------------------------
  ----------  TX process --------
  --------------------------------------------------
  tx_start_proc : process(clk, tx_start, s_tx_done)
  begin
    if (s_tx_done = '1') then
      s_tx_en <= '0';
      
    elsif rising_edge(clk) then
      s_tx_start_latch <= tx_start;
      
      if (s_tx_start_latch = '0') and (tx_start = '1') then
        --start_cnt := '1';
        s_tx_en <= '1';
        --s_tx_byte <= tx_byte;
        --s_tx <= '0';
      end if;
      
    end if;
    
  end process tx_start_proc;
  
  
  ------------------------------------------------------------------------
  uart_tx_tick_proc : process (clk, s_tx_en)
    variable v_tick_cnt : INTEGER := 0;
    
  begin
    if (s_tx_en = '0') then
      v_tick_cnt := 0;
      s_tx_tick <= '0';
      
    elsif rising_edge(clk) then
      v_tick_cnt := v_tick_cnt + 1;
      
      -- ONLY support Baudrate 76800 which is 13us per bit
      -- System clk is 10ns per tick => we need 1300 tick per bit
      -- A signal will toggle 1300/2 = 650 ticks to create a rising_edge
      --  every 13us to signal sampling process.
      if (v_tick_cnt >= 650) then
        s_tx_tick <= not s_tx_tick;
        v_tick_cnt := 0;
      end if;
    end if;
  
  end process uart_tx_tick_proc;
  
  uart_tx_proc : process (clk, s_tx_tick, s_tx_en)
    --variable v_tx_bit_cnt : INTEGER = 0;
  begin
    if (s_tx_en = '0') then
      s_tx_tick_pre <= '0';
      s_tx_bit_cnt <= 0;
      s_tx_done <= '0';
      
    elsif rising_edge(clk) then
      s_tx_tick_pre <= s_tx_tick;
      
      if (s_tx_tick_pre = '0') and (s_tx_tick = '1') then
        
        if (s_tx_bit_cnt = 0) then
          s_tx <= '0';
          s_tx_done <= '0';
          s_tx_byte <= tx_byte;
        elsif (s_tx_bit_cnt > 8) then
          s_tx <= '1';
          s_tx_done <= '1';
        else
          s_tx <= s_tx_byte(0);
          s_tx_byte <= s_tx_byte(0) & s_tx_byte(7 downto 1);
          s_tx_done <= '0';
        end if; 
        
        s_tx_bit_cnt <= s_tx_bit_cnt + 1;
        
        
      end if;
    end if;
  end process uart_tx_proc;
  
  tx <= s_tx;
end Behavioral;

-----------------------------------
