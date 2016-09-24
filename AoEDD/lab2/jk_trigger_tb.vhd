----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2016 03:33:52 PM
-- Design Name: 
-- Module Name: jk_trigger_tb - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity jk_trigger_tb is
--  Port ( );
end jk_trigger_tb;

architecture Behavioral of jk_trigger_tb is
    component jk_trigger is
        Port ( J : in STD_LOGIC;
               K : in STD_LOGIC;
               CLK : in STD_LOGIC;
               RESET : in STD_LOGIC;
               SET : in STD_LOGIC;
               Q : inout STD_LOGIC;
               NQ : inout STD_LOGIC);
    end component;
    
    signal jk: STD_LOGIC_VECTOR(1 downto 0);
    signal clk, reset, set, q, nq: STD_LOGIC;
    signal clock: STD_LOGIC := '0';
    constant clock_period: TIME := 2 ns;
begin
    -- port mapping from jk trigger component to internal signals 
    jk_trigger_instance: jk_trigger port map(
        J => jk(1),
        K => jk(0),
        CLK => clk,
        RESET => reset,
        SET => set,
        Q => q,
        NQ => nq
    ); 
    
    -- initializing clock logic
    clock <= not clock after clock_period / 2;
    
    -- jk trigger testing process
    process (clock)
    begin
        clk <= clock;
    end process;
    
    process 
    begin
        for index in 0 to 3 loop
            jk <= conv_std_logic_vector(index, 2);
            wait for 4ns;
        end loop;
    end process;
    
    process
    begin
        reset <= '0';
        set <= '0';
        wait for 20ns;
        
        reset <= '1';
        set <= '0';
        wait for 20ns;
        
        reset <= '0';
        set <= '1';
        wait for 20ns;
    end process;
    
    
end Behavioral;
