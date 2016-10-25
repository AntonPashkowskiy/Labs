----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2016 06:11:58 AM
-- Design Name: 
-- Module Name: counter_tb - Behavioral
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

entity counter_tb is
--  Port ( );
end counter_tb;

architecture Behavioral of counter_tb is
    component counter is
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
    end component;
    
    signal inputs, outputs: STD_LOGIC_VECTOR(3 downto 0);
    signal n_oe, ent, enp, n_sclr, n_sload, n_aclr, n_aload, cco, rco, clk: STD_LOGIC;
    signal clock: STD_LOGIC := '0';
    constant clock_period: TIME := 2 ns;
begin
    counter_instance: counter port map(
        N_OE => n_oe,
        ENT => ent,
        ENP => enp,
        N_SCLR => n_sclr,
        N_SLOAD => n_sload,
        CLK => clk,
        N_ACLR => n_aclr,
        N_ALOAD => n_aload,
        A => inputs(0),
        B => inputs(1),
        C => inputs(2),
        D => inputs(3),
        
        CCO => cco,
        RCO => rco,
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
        for index in 0 to 15 loop
            inputs <= conv_std_logic_vector(index, 4);
            wait for 6ns;
        end loop;    
    end process;
    
    process 
    begin
        -- testing counter mode
        ent <= '1';
        enp <= '1';
        n_sload <= '1';
        n_sclr <= '1';
        n_aload <= '1';
        n_aclr <= '1';
        n_oe <= '0';
        wait for 50ns;
        
        -- disabling counter mode
        ent <= '0';
        enp <= '0';
        wait for 50ns; 
        
        -- sync loading mode
        n_sload <= '0';
        wait for 50ns;
        
        -- sync clear mode
        n_sclr <= '0';
        wait for 50ns;
        
        -- async loading mode
        n_sclr <= '1';
        n_sload <= '1';
        n_aload <= '0';
        wait for 50ns;
        
        -- async clear mode
        n_aclr <= '0';
        wait for 50ns;
        
        -- output disabling
        n_oe <= '1';
        wait for 50ns;
    end process;
    
    -- automatic test processes
    process (clock)
        variable previous_outputs: INTEGER := 0;
        variable current_outputs: INTEGER;
        variable counter_mode: STD_LOGIC_VECTOR(5 downto 0);
    begin
        if (clock'event and clock = '0') then
            -- testing output lock mode
            if (n_oe = '1' and outputs /= "ZZZZ") then
                report "Error in output locking mode.";
            end if;
            
            
            if (n_oe = '0') then
                -- testing sync load mode
                if (n_sload = '0' and n_sclr = '1' and n_aclr = '1' and inputs /= outputs) then
                    report "Error in sync loading mode.";
                end if;
                
                -- testing sync clear mode
                if (n_sclr = '0' and outputs /= "0000") then
                    report "Error in sync clear mode.";
                end if;
                
                -- testing counter mode
                counter_mode := ent & enp & n_sclr & n_sload & n_aclr & n_aload;
                
                if (counter_mode = "111111") then
                    current_outputs := conv_integer(unsigned(outputs));
                    
                    if (not (previous_outputs = 15 and current_outputs = 0)) then 
                        if (current_outputs /= previous_outputs + 1) then
                            report "Error in counting mode.";
                        end if;
                    end if;
                    
                    -- test carry output
                    if (current_outputs = 15 and rco /= '1') then
                        report "Error in carry output block"; 
                    end if;
                end if;
            end if;
            
            previous_outputs := conv_integer(unsigned(outputs));
        end if;
    end process;
    
    process
    begin
        if (n_oe = '0') then
            -- testing async load mode
            if (n_aload = '0' and n_aclr = '1' and inputs /= outputs) then
                report "Error in async loading mode.";
            end if;
            
            -- testing async clear mode
            if (n_aclr = '0' and outputs /= "0000") then
                report "Error in async clear mode.";
            end if;
        end if;
        
        wait for 1ns;
    end process;
end Behavioral;
