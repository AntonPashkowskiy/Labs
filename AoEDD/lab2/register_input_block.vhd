----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2016 06:44:52 AM
-- Design Name: 
-- Module Name: register_input_block - Behavioral
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

entity register_input_block is
    Port (
        inputs: in STD_LOGIC_VECTOR(3 downto 0);
        feedback: in STD_LOGIC_VECTOR(3 downto 0);
        S0: in STD_LOGIC;
        S1: in STD_LOGIC;
        SR_SER: in STD_LOGIC;
        SL_SER: in STD_LOGIC;
        outputs: out STD_LOGIC_VECTOR(3 downto 0)
    );
end register_input_block;

architecture Behavioral of register_input_block is
    -- components declaration
    component signal_joining_block
        Port (
            AND1: in STD_LOGIC_VECTOR(2 downto 0);
            AND2: in STD_LOGIC_VECTOR(2 downto 0);
            AND3: in STD_LOGIC_VECTOR(2 downto 0);
            AND4: in STD_LOGIC_VECTOR(2 downto 0);
            OUTPUT: out STD_LOGIC := '0'
        ); 
    end component;
    
    -- types declaration
    type SIGNAL_MATRIX is array (15 downto 0) of STD_LOGIC_VECTOR(2 downto 0);  
    
    -- signals and variables declaration
    signal signal_joining_matrix: SIGNAL_MATRIX;
begin
    sjb_generating: for index in 0 to 3 generate 
        signal_joining_blocks: signal_joining_block port map(
            AND1 => signal_joining_matrix(index * 4 + 0),
            AND2 => signal_joining_matrix(index * 4 + 1),
            AND3 => signal_joining_matrix(index * 4 + 2),
            AND4 => signal_joining_matrix(index * 4 + 3),
            OUTPUT => outputs(index)
        );
    end generate;
    
    -- first logic block
    signal_joining_matrix(0) <= SR_SER & (not S0) & S1;
    signal_joining_matrix(1) <= S1 & S0 & inputs(0);
    signal_joining_matrix(2) <= (not S1) & S0 & feedback(1);
    signal_joining_matrix(3) <= (not S1) & (not S0) & feedback(0);
    
    -- second logic block
    signal_joining_matrix(4) <= feedback(0) & (not S0) & S1;
    signal_joining_matrix(5) <= S1 & S0 & inputs(1);
    signal_joining_matrix(6) <= (not S1) & S0 & feedback(2);
    signal_joining_matrix(7) <= (not S1) & (not S0) & feedback(1);
    
    -- third logic block
    signal_joining_matrix(8) <= feedback(1) & (not S0) & S1;
    signal_joining_matrix(9) <= S0 & S1 & inputs(2);
    signal_joining_matrix(10) <= (not S1) & S0 & feedback(3);
    signal_joining_matrix(11) <= (not S1) & (not S0) & feedback(2);
    
    -- four logic block
    signal_joining_matrix(12) <= feedback(2) & (not S0) & S1;
    signal_joining_matrix(13) <= S1 & S0 & inputs(3);
    signal_joining_matrix(14) <= (not S1) & S0 & SL_SER;
    signal_joining_matrix(15) <= (not S1) & (not S0) & feedback(3);
end Behavioral;
