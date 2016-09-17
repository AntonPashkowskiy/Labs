----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2016 05:36:46 AM
-- Design Name: 
-- Module Name: multiplexer - TwoLineToLineMultiplexer
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

entity multiplexer is
    Port ( A1 : in STD_LOGIC;
           B1 : in STD_LOGIC;
           A2 : in STD_LOGIC;
           B2 : in STD_LOGIC;
           A3 : in STD_LOGIC;
           B3 : in STD_LOGIC;
           A4 : in STD_LOGIC;
           B4 : in STD_LOGIC;
           NG : in STD_LOGIC;
           NA_B : in STD_LOGIC;
           Y1 : out STD_LOGIC;
           Y2 : out STD_LOGIC;
           Y3 : out STD_LOGIC;
           Y4 : out STD_LOGIC);
end multiplexer;

architecture two_line_multiplexer of multiplexer is
    signal first_line_selected: STD_LOGIC;
    signal second_line_selected: STD_LOGIC;
begin
    first_line_selected <= not NG and not NA_B;
    second_line_selected <= not NG and NA_B;
    
    Y1 <= (A1 and first_line_selected) or (B1 and second_line_selected);
    Y2 <= (A2 and first_line_selected) or (B2 and second_line_selected);
    Y3 <= (A3 and first_line_selected) or (B3 and second_line_selected);
    Y4 <= (A4 and first_line_selected) or (B4 and second_line_selected);
end two_line_multiplexer;
