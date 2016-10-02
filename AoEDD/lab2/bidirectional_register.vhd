----------------------------------------------------------------------------------
-- Company: Anton
-- Engineer: Anton Pashkouski
-- 
-- Create Date: 09/21/2016 02:32:48 PM
-- Design Name: bidirectional register
-- Module Name: bidirectional_register - Behavioral
-- Project Name: register
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

entity bidirectional_register is
    Port ( -- parallel inputs
           A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           D : in STD_LOGIC;
           -- mode controls inputs
           S0 : in STD_LOGIC;
           S1 : in STD_LOGIC;
           -- serial data inputs
           SR_SER : in STD_LOGIC;
           SL_SER : in STD_LOGIC;
           -- clock and clear
           CLK : in STD_LOGIC;
           NOT_CLR : in STD_LOGIC;
           -- parallel outputs
           Qa : out STD_LOGIC;
           Qb : out STD_LOGIC;
           Qc : out STD_LOGIC;
           Qd : out STD_LOGIC
    );
end bidirectional_register;

architecture Behavioral of bidirectional_register is
    -- components definition
    component register_input_block
        Port (
            inputs: in STD_LOGIC_VECTOR(3 downto 0);
            feedback: in STD_LOGIC_VECTOR(3 downto 0);
            S0: in STD_LOGIC;
            S1: in STD_LOGIC;
            SR_SER: in STD_LOGIC;
            SL_SER: in STD_LOGIC;
            outputs: out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    component jk_trigger
        Port ( 
            J : in STD_LOGIC;
            K : in STD_LOGIC;
            CLK : in STD_LOGIC;
            N_RESET : in STD_LOGIC;
            N_SET : in STD_LOGIC;
            Q : inout STD_LOGIC := '0';
            NQ : inout STD_LOGIC := '1'
        );
    end component;
    
    -- internal signal and varibales definition
    signal input_block_feedback: STD_LOGIC_VECTOR(3 downto 0);
    signal input_block_outputs: STD_LOGIC_VECTOR(3 downto 0);
    signal j_vector, k_vector, trigger_output: STD_LOGIC_VECTOR(3 downto 0);
begin
    register_input_block_instance: register_input_block port map(
        inputs(0) => A,
        inputs(1) => B,
        inputs(2) => C,
        inputs(3) => D,
        S0 => S0,
        S1 => S1,
        SR_SER => SR_SER,
        SL_SER => SL_SER,
        feedback => input_block_feedback,
        outputs => input_block_outputs    
    );
    
    jkt_generating: for index in 0 to 3 generate
        all_jk_triggers: jk_trigger port map(
            J => j_vector(index),
            K => k_vector(index),
            CLK => CLK,
            N_RESET => NOT_CLR,
            N_SET => '1',
            Q => trigger_output(index)
        );
    end generate;
    
    process (trigger_output) 
    begin
        input_block_feedback <= trigger_output;
        Qa <= trigger_output(0);
        Qb <= trigger_output(1);
        Qc <= trigger_output(2);
        Qd <= trigger_output(3);
    end process;
    
    process (input_block_outputs)
    begin
        for index in 0 to 3 loop
            j_vector(index) <= not input_block_outputs(index);
            k_vector(index) <= input_block_outputs(index);
        end loop;
    end process;
end Behavioral;
