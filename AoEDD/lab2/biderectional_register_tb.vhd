----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2016 11:14:18 AM
-- Design Name: 
-- Module Name: biderectional_register_tb - Behavioral
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

entity biderectional_register_tb is
--  Port ( );
end biderectional_register_tb;

architecture Behavioral of biderectional_register_tb is
    component bidirectional_register
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
    end component;
    
    signal inputs, outputs: STD_LOGIC_VECTOR(3 downto 0);
    signal s0, s1, sr_ser, sl_ser, clk, not_clr: STD_LOGIC;
    signal clock: STD_LOGIC := '0';
    constant clock_period: TIME := 2 ns;
begin
    biderectional_register_instance: bidirectional_register port map(
        A => inputs(0),
        B => inputs(1),
        C => inputs(2),
        D => inputs(3),
        S0 => s0,
        S1 => s1,
        SR_SER => sr_ser,
        SL_SER => sl_ser,
        CLK => clk,
        NOT_CLR => not_clr,
        Qa => outputs(0),
        Qb => outputs(1),
        Qc => outputs(2),
        Qd => outputs(3)
    );
    
    clock <= not clock after clock_period / 2;
    
    process(clock)
    begin
        clk <= clock;
    end process;
    
    process
    begin        
        for test_number in 0 to 3 loop
            case test_number is
                when 0 =>
                    -- parallel loading mode
                    s0 <= '1';
                    s1 <= '1';
                    not_clr <= '1';
                    sl_ser <= '0';
                    sr_ser <= '0';
                            
                    for index in 0 to 15 loop
                        inputs <= conv_std_logic_vector(index, 4);
                        wait for 4ns;
                    end loop;
                    
                when 1 =>
                    -- right to left serial loading
                    s0 <= '0';
                    s1 <= '1';
                    not_clr <= '1';
                    
                    sr_ser <= '0';
                    wait for 12ns;
                    sr_ser <= '1';
                    wait for 12ns;
                    
                when 2 =>
                    -- left to right serial loading
                    s0 <= '1';
                    s1 <= '0';
                    not_clr <= '1';
                    
                    sl_ser <= '0';
                    wait for 12ns;
                    sl_ser <= '1';
                    wait for 12ns;
                    
                when 3 => 
                    -- clear output
                    not_clr <= '0';
                    wait for 24ns;
                    
                when others =>
                    -- clear output
                    not_clr <= '0';
                    wait for 24ns;
            end case;                   
        end loop;
    end process;
end Behavioral;
