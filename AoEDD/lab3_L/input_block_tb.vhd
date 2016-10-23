----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2016 07:01:06 AM
-- Design Name: 
-- Module Name: input_block_tb - Behavioral
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

entity input_block_tb is
--  Port ( );
end input_block_tb;

architecture Behavioral of input_block_tb is
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
    
    signal n_oe, ent, enp, n_sclr, n_sload, clk, n_aclr, n_aload: STD_LOGIC;
    signal oe, aclr, aload, n_clk: STD_LOGIC;
    signal inputs, feedback, s_inputs: STD_LOGIC_VECTOR(3 downto 0);
    signal clock: STD_LOGIC := '0';
    signal clock_period: TIME := 4ns;
begin
    input_block_instance: input_block port map(
        N_OE => n_oe,
        ENT => ent, 
        ENP => enp,
        N_SCLR => n_sclr,
        N_SLOAD => n_sload,
        CLK => clk,
        N_ACLR => n_aclr,
        N_ALOAD => n_aload,
        INPUTS => inputs,
        FEEDBACK => feedback,
        
        OE => oe,
        ACLR => aclr,
        ALOAD => aload,
        N_CLK => n_clk,
        S_INPUTS => s_inputs
    );
    
    clock <= not clock after clock_period / 2;
    
    process(clock)
    begin
        clk <= clock;
    end process;
    
    process
    begin
        for index in 0 to 15 loop
            inputs <= "0000";
            feedback <= conv_std_logic_vector(index, 4);
            wait for 7ns;
        end loop;
    end process;
    
    process 
    begin
        -- testing counting function
        ent <= '1';
        enp <= '1';
        n_sload <= '1';
        n_sclr <= '1';
        n_aload <= '1';
        n_aclr <= '1';
        n_oe <= '0';
            
        wait for 100ns;
    end process;

end Behavioral;
