----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2016 12:10:07 PM
-- Design Name: 
-- Module Name: EX2 - Behavioral
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

entity EX2 is
    Port ( 
        A: in STD_LOGIC;
        B: in STD_LOGIC;
        OUTPUT: out STD_LOGIC
    );
end EX2;

architecture Behavioral of EX2 is
begin
    OUTPUT <= (A and not B) or (not A and B) after 5 ns;
end Behavioral;
