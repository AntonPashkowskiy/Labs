----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2016 05:37:46 AM
-- Design Name: 
-- Module Name: signal_joining_block - Behavioral
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

entity signal_joining_block is
    Port (
        AND1: in STD_LOGIC_VECTOR(2 downto 0);
        AND2: in STD_LOGIC_VECTOR(2 downto 0);
        AND3: in STD_LOGIC_VECTOR(2 downto 0);
        AND4: in STD_LOGIC_VECTOR(2 downto 0);
        OUTPUT: out STD_LOGIC := '0'
    );
end signal_joining_block;

architecture Behavioral of signal_joining_block is
    signal first_and_out: STD_LOGIC;
    signal second_and_out: STD_LOGIC;
    signal third_and_out: STD_LOGIC;
    signal four_and_out: STD_LOGIC;
begin
    first_and_out <= AND1(0) and AND1(1) and AND1(2);
    second_and_out <= AND2(0) and AND2(1) and AND2(2);
    third_and_out <= AND3(0) and AND3(1) and AND3(2);
    four_and_out <= AND4(0) and AND4(1) and AND4(2);
    
    OUTPUT <= not (first_and_out or second_and_out or third_and_out or four_and_out);
end Behavioral;
