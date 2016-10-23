----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2016 03:27:54 PM
-- Design Name: 
-- Module Name: carry_output_block - Behavioral
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

entity carry_output_block is
    Port ( 
        ENT: in STD_LOGIC;
        ENP: in STD_LOGIC;
        CLK: in STD_LOGIC;
        STORAGE_CELL_FEEDBACK: in STD_LOGIC_VECTOR(3 downto 0);
        
        CCO: out STD_LOGIC;
        RCO: out STD_LOGIC
    );
end carry_output_block;

architecture Behavioral of carry_output_block is
    signal rco_signal: STD_LOGIC;
begin
    rco_signal <= STORAGE_CELL_FEEDBACK(0) and 
                  STORAGE_CELL_FEEDBACK(1) and 
                  STORAGE_CELL_FEEDBACK(2) and 
                  STORAGE_CELL_FEEDBACK(3) and 
                  ENT; 
    RCO <= rco_signal;
    CCO <= rco_signal and (not CLK) and (ENT and ENP); 
end Behavioral;
