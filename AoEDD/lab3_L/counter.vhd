----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2016 08:41:53 AM
-- Design Name: 
-- Module Name: counter - Behavioral
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

entity counter is
    Port (
        N_OE: in STD_LOGIC;
        ENT: in STD_LOGIC;
        ENP: in STD_LOGIC;
        N_SCLR: in STD_LOGIC;
        N_SLOAD: in STD_LOGIC;
        CLK: in STD_LOGIC;
        N_ACLR: in STD_LOGIC;
        N_ALOAD: in STD_LOGIC;
        A: in STD_LOGIC;
        B: in STD_LOGIC;
        C: in STD_LOGIC;
        D: in STD_LOGIC;
        
        CCO: out STD_LOGIC;
        RCO: out STD_LOGIC;
        Qa: out STD_LOGIC;
        Qb: out STD_LOGIC;
        Qc: out STD_LOGIC;
        Qd: out STD_LOGIC
    );
end counter;

architecture Behavioral of counter is
    -- components definition
    component input_block is
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
    end component;
    
    component storage_cell is
        Port ( 
            CLK: in STD_LOGIC;
            ACLR: in STD_LOGIC;
            ALOAD: in STD_LOGIC;
            A_INPUT: in STD_LOGIC;
            S_INPUT: in STD_LOGIC;
            LOCK: in STD_LOGIC;
            
            OUTPUT: out STD_LOGIC;
            LOCKABLE_OUTPUT: out STD_LOGIC
        );
    end component;
    
    component carry_output_block is
        Port ( 
            ENT: in STD_LOGIC;
            ENP: in STD_LOGIC;
            CLK: in STD_LOGIC;
            STORAGE_CELL_FEEDBACK: in STD_LOGIC_VECTOR(3 downto 0);
            
            CCO: out STD_LOGIC;
            RCO: out STD_LOGIC
        );
    end component;
    
    -- signal definition for input block
    signal oe, aclr, aload, n_clk: STD_LOGIC;
    signal feedback, a_inputs, s_inputs, outputs: STD_LOGIC_VECTOR(3 downto 0);
begin
    input_block_instance: input_block port map(
        N_OE => N_OE,
        ENT => ENT,
        ENP => ENP,
        N_SCLR => N_SCLR,
        N_SLOAD => N_SLOAD,
        CLK => CLK,
        N_ACLR => N_ACLR,
        N_ALOAD => N_ALOAD,
        INPUTS(0) => A,
        INPUTS(1) => B,
        INPUTS(2) => C,
        INPUTS(3) => D,
        FEEDBACK => feedback,
        
        OE => oe,
        ACLR => aclr,
        ALOAD => aload,
        N_CLK => n_clk,
        S_INPUTS => s_inputs
    );
    
    carry_out_block_instance: carry_output_block port map(
        ENT => ENT,
        ENP => ENP,
        CLK => CLK,
        STORAGE_CELL_FEEDBACK => feedback,
        
        CCO => CCO,
        RCO => RCO
    );
    
    a_inputs(0) <= A;
    a_inputs(1) <= B;
    a_inputs(2) <= C;
    a_inputs(3) <= D;
    
    storage_cells_generating: for index in 0 to 3 generate
        storage_cell_input: storage_cell port map(
            CLK => CLK,
            ACLR => aclr,
            ALOAD => aload,
            A_INPUT => a_inputs(index),
            S_INPUT => s_inputs(index),
            LOCK => N_OE,
            
            OUTPUT => feedback(index),
            LOCKABLE_OUTPUT => outputs(index)
        );
    end generate;
    
    Qa <= outputs(0);
    Qb <= outputs(1);
    Qc <= outputs(2);
    Qd <= outputs(3);
end Behavioral;
