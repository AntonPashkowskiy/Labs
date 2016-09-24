----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2016 08:57:18 AM
-- Design Name: 
-- Module Name: register_input_block_tb - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_input_block_tb is
--  Port ( );
end register_input_block_tb;

architecture Behavioral of register_input_block_tb is
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
    
    signal s0, s1, sr_ser, sl_ser: STD_LOGIC;
    signal rib_inputs, rib_feedback, rib_outputs: STD_LOGIC_VECTOR(3 downto 0);
begin
    register_input_block_instance: register_input_block port map(
        inputs => rib_inputs,
        feedback => rib_feedback,
        S0 => s0,
        S1 => s1,
        SR_SER => sr_ser,
        SL_SER => sl_ser,
        outputs => rib_outputs
    );
    
    process
        variable converted_others: STD_LOGIC_VECTOR(3 downto 0);
    begin
         for i in 0 to 15 loop
            for j in 0 to 15 loop
                for k in 0 to 15 loop
                     rib_inputs <= conv_std_logic_vector(i, 4);
                     rib_feedback <= conv_std_logic_vector(j, 4);
                     converted_others := conv_std_logic_vector(k, 4);
                     
                     s0 <= converted_others(0);
                     s1 <= converted_others(1);
                     sr_ser <= converted_others(2);
                     sl_ser <= converted_others(3);
                     wait for 5 ns;
                end loop;
            end loop;
         end loop;
    end process;
end Behavioral;

