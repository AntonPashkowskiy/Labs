----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2016 05:50:09 AM
-- Design Name: 
-- Module Name: signal_joining_block_tb - Behavioral
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

entity signal_joining_block_tb is
--  Port ( );
end signal_joining_block_tb;

architecture Behavioral of signal_joining_block_tb is
    component signal_joining_block
        Port (
            AND1: in STD_LOGIC_VECTOR(2 downto 0);
            AND2: in STD_LOGIC_VECTOR(2 downto 0);
            AND3: in STD_LOGIC_VECTOR(2 downto 0);
            AND4: in STD_LOGIC_VECTOR(2 downto 0);
            OUTPUT: out STD_LOGIC := '0'
        );
    end component;
    
    signal and1, and2, and3, and4: STD_LOGIC_VECTOR(2 downto 0);
    signal output_signal: STD_LOGIC;
begin
    SGB_instance: signal_joining_block port map(
        AND1 => and1,
        AND2 => and2,
        AND3 => and3,
        AND4 => and4,
        OUTPUT => output_signal
    );
    
    process
        variable converted_signal: STD_LOGIC_VECTOR(2 downto 0);
    begin
        for index in 0 to 7 loop
            converted_signal := conv_std_logic_vector(index, 3);
            and1 <= converted_signal;
            and2 <= converted_signal;
            and3 <= converted_signal;
            and4 <= converted_signal;
            wait for 5ns;
        end loop;
    end process;
end Behavioral;
