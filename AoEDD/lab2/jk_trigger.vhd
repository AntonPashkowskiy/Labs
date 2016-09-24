----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2016 03:08:59 PM
-- Design Name: 
-- Module Name: jk_trigger - Behavioral
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

entity jk_trigger is
    Port ( J : in STD_LOGIC;
           K : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           SET : in STD_LOGIC;
           Q : inout STD_LOGIC := '0';
           NQ : inout STD_LOGIC := '1');
end jk_trigger;

architecture Behavioral of jk_trigger is
    signal fl_nand1: STD_LOGIC;
    signal fl_nand2: STD_LOGIC;
begin
    process (CLK)
        variable jk: std_logic_vector(1 downto 0);
    begin    
        if (RESET = '1') then
            Q <= '0';
        elsif (SET = '1') then
            Q <= '1';
        elsif (CLK'event and CLK = '1') then
            jk := J & K;
            
            case jk is
                when "01" =>
                    Q <= '0';
                when "10" =>
                    Q <= '1';
                when "11" =>
                    Q <= not Q;
                when others =>
                    Q <= Q;
            end case;
        end if;
    end process;
    
    process (Q)
    begin 
        NQ <= not Q;
    end process;
end Behavioral;
