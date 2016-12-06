----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2016 12:18:01 PM
-- Design Name: 
-- Module Name: NAO22 - Behavioral
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

entity NAO22 is
    Port ( 
        A: in STD_LOGIC;
        B: in STD_LOGIC;
        C: in STD_LOGIC;
        D: in STD_LOGIC;
        OUTPUT: out STD_LOGIC
    );
end NAO22;

architecture Behavioral of NAO22 is
begin
    OUTPUT <= not((A or B) and (C or D)) after 3 ns;
end Behavioral;
