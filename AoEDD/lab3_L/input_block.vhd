----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2016 03:07:52 PM
-- Design Name: 
-- Module Name: input_block - Behavioral
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

entity input_block is
    Port (
        N_OE: in STD_LOGIC;
        ENT: in STD_LOGIC;
        ENP: in STD_LOGIC;
        N_SCLR: in STD_LOGIC;
        N_SLOAD: in STD_LOGIC;
        CLK: in STD_LOGIC;
        N_ACLR: in STD_LOGIC;
        N_ALOAD: in STD_LOGIC;
        INPUTS: in STD_LOGIC_VECTOR(3 downto 0);
        FEEDBACK: in STD_LOGIC_VECTOR(3 downto 0);
        
        OE: out STD_LOGIC;
        ACLR: out STD_LOGIC;
        ALOAD: out STD_LOGIC;
        N_CLK: out STD_LOGIC;
        S_INPUTS: out STD_LOGIC_VECTOR(3 downto 0)
    );
end input_block;

architecture Behavioral of input_block is
    -- component definition
    component control_signals is
        Port (
            N_OE: in STD_LOGIC;
            ENT: in STD_LOGIC;
            ENP: in STD_LOGIC;
            N_SCLR: in STD_LOGIC;
            N_SLOAD: in STD_LOGIC;
            N_ACLR: in STD_LOGIC;
            N_ALOAD: in STD_LOGIC;
            CLK: in STD_LOGIC;
            
            
            OE: out STD_LOGIC;
            ACLR: out STD_LOGIC;
            ALOAD: out STD_LOGIC;
            N_CLK: out STD_LOGIC;
            CONTROL_BUS: out STD_LOGIC_VECTOR(2 downto 0) 
        );
    end component;
    
    component top_signal_hub is
        Port (
            inputs: in STD_LOGIC_VECTOR(0 to 7);
            output: out STD_LOGIC 
        );
    end component;
    
    component signal_hub is
        Port (
            inputs: in STD_LOGIC_VECTOR(0 to 13);
            output: out STD_LOGIC 
        );
    end component; 
    
    -- signals definition for control signals block
    signal control_bus: STD_LOGIC_VECTOR(2 downto 0);
    
    -- types declaration
    type SIGNAL_MATRIX is array (2 downto 0) of STD_LOGIC_VECTOR(0 to 13);  
    -- signals definition for signals hubs
    signal signal_hub_matrix: SIGNAL_MATRIX;
    signal top_signal_hub_inputs: STD_LOGIC_VECTOR(0 to 7);
begin
    control_signals_instance: control_signals port map(
        -- input signals mapping
        N_OE => N_OE,
        ENT => ENT,
        ENP => ENP,
        N_SCLR => N_SCLR,
        N_SLOAD => N_SLOAD,
        N_ACLR => N_ACLR,
        N_ALOAD => N_ALOAD,
        CLK => CLK,
        -- output signals mapping
        OE => OE,
        ACLR => ACLR,
        ALOAD => ALOAD,
        N_CLK => N_CLK,
        CONTROL_BUS => control_bus
    );
    
    top_signal_hub_instance: top_signal_hub port map(
        inputs => top_signal_hub_inputs,
        output => S_INPUTS(0)
    );
    
    signal_hubs_generating: for index in 2 downto 0 generate
        signal_hub_instance: signal_hub port map(
            inputs => signal_hub_matrix(index),
            output => S_INPUTS(index + 1)
        );
    end generate; 
        
    top_signal_hub_inputs <= 
        INPUTS(0) & 
        control_bus(2) & 
        control_bus(1) & 
        FEEDBACK(0) & 
        control_bus(0) & 
        control_bus(0) & 
        control_bus(1) & 
        FEEDBACK(0);
        
    signal_hub_matrix(0) <=
        INPUTS(1) &
        control_bus(2) &
        control_bus(0) &
        '1' &
        '1' &
        FEEDBACK(0) &
        FEEDBACK(1) &
        control_bus(1) &
        control_bus(0) &
        FEEDBACK(0) &
        '1' &
        '1' &
        control_bus(1) &
        FEEDBACK(1);
    
    signal_hub_matrix(1) <=
        INPUTS(2) &
        control_bus(2) &
        control_bus(1) &
        FEEDBACK(1) &
        FEEDBACK(0) &
        '1' &
        FEEDBACK(2) &
        control_bus(1) &
        control_bus(0) &
        FEEDBACK(1) &
        FEEDBACK(0) &
        '1' &
        control_bus(1) &
        FEEDBACK(2);
        
    signal_hub_matrix(2) <=
        INPUTS(3) &
        control_bus(2) &
        control_bus(0) &
        FEEDBACK(2) &
        FEEDBACK(1) &
        FEEDBACK(0) &
        FEEDBACK(3) &
        control_bus(1) &
        control_bus(0) &
        FEEDBACK(2);
        FEEDBACK(1);
        FEEDBACK(0);
        control_bus(1);
        FEEDBACK(3);
end Behavioral;
