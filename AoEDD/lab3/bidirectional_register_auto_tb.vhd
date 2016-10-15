----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/15/2016 07:47:30 AM
-- Design Name: 
-- Module Name: bidirectional_register_auto_tb - Behavioral
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

entity bidirectional_register_auto_tb is
--  Port ( );
end bidirectional_register_auto_tb;

architecture Behavioral of bidirectional_register_auto_tb is
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
    
    function vec2str(vec : std_logic_vector) return string is
        variable stmp : string(vec'LEFT+1 downto 1);
    begin
        for i in vec'REVERSE_RANGE loop
            if vec(i) = '1' then
                stmp(i+1) := '1';
            elsif vec(i) = '0' then
                stmp(i+1) := '0';
            else
                stmp(i+1) := 'X';
            end if;
        end loop;
        return stmp;
    end vec2str;
    
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
    
    -- testing process
    process
    begin        
        for test_number in 0 to 4 loop
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
                    
                when 4 =>
                    s0 <= '0';
                    s1 <= '0';
                    not_clr <= '1';
                    sl_ser <= '1';
                    sr_ser <= '0';
                                                
                    for index in 0 to 15 loop
                        inputs <= conv_std_logic_vector(index, 4);
                        wait for 4ns;
                    end loop;
                    
                when others =>
                    -- clear output
                    not_clr <= '0';
                    wait for 24ns;
            end case;                   
        end loop;
    end process;
    
    -- control process
    process (clock)
        variable previous_outputs: STD_LOGIC_VECTOR(3 downto 0) := "0000";
        variable expected_outputs: STD_LOGIC_VECTOR(3 downto 0);
        variable mode: STD_LOGIC_VECTOR(1 downto 0);
    begin
        if (clock'event and clock = '0') then
            mode := s0 & s1;
            
            case mode is
                -- parallel loadign testing
                when "11" =>
                    if (inputs /= outputs and not_clr = '1') then
                        assert false;
                        report "Error in (11) mode, inputs: " & vec2str(inputs) & " - ouputs: " & vec2str(outputs);
                    end if;
                    previous_outputs := outputs;
                
                -- left to right serial loading mode testing    
                when "10" =>
                    expected_outputs := previous_outputs;
                    expected_outputs := to_stdlogicvector(to_bitvector(expected_outputs) srl 1);
                    
                    if (sl_ser = '1') then
                        expected_outputs := expected_outputs xor "1000";
                    end if; 
                    
                    if (outputs /= expected_outputs and not_clr = '1') then
                        assert false;
                        report "Error in (10) mode, expected ouputs: " & 
                               vec2str(expected_outputs) & 
                               " - outputs: " & 
                               vec2str(outputs);
                    end if;
                    previous_outputs := outputs;
                
                -- right to left serial loading mode testing    
                when "01" =>
                    expected_outputs := previous_outputs;
                    expected_outputs := to_stdlogicvector(to_bitvector(expected_outputs) sll 1);
                    
                    if (sr_ser = '1') then
                        expected_outputs := expected_outputs xor "0001";
                    end if;
                    
                    if (outputs /= expected_outputs and not_clr = '1') then
                        assert false;
                        report "Error in (01) mode, expected ouputs: " & 
                               vec2str(expected_outputs) & 
                               " - outputs: " & 
                               vec2str(outputs);
                    end if;
                    previous_outputs := outputs;
                
                -- disable mode testing    
                when "00" =>
                    if (outputs /= "0000" and not_clr = '1') then
                        assert false;
                        report "Error in (00) mode, expected ouputs: 0000 - ouputs: " & vec2str(outputs);
                    end if;
                    previous_outputs := outputs;
                    
                when others =>
                    null;
            end case;
            
            if (not_clr = '0' and outputs /= "0000") then
                assert false;
                report "Error on trying clear outputs, current ouputs value: " & vec2str(outputs);
            end if;
        end if;
    end process;
end Behavioral;
