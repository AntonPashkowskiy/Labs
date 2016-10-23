----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2016 04:07:19 PM
-- Design Name: 
-- Module Name: signal_hub - Behavioral
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

entity signal_hub is
    Port (
        inputs: in STD_LOGIC_VECTOR(0 to 13);
        output: out STD_LOGIC
    );
end signal_hub;

architecture Behavioral of signal_hub is
    signal first_and, second_and, third_and: STD_LOGIC;
begin
    first_and <= inputs(0) and inputs(1);
    second_and <= inputs(2) and (not (inputs(3) and inputs(4) and inputs(5))) and inputs(6) and not inputs(7);
    third_and <= inputs(8) and inputs(9) and inputs(10) and inputs(11) and (not (inputs(12) or inputs(13)));
        
    output <= first_and or second_and or third_and;
end Behavioral;
