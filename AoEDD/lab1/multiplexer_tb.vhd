----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2016 02:10:11 PM
-- Design Name: 
-- Module Name: multiplexer_tb - Behavioral
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

entity multiplexer_tb is
--  Port ( );
end multiplexer_tb;

architecture Behavioral of multiplexer_tb is
    component multiplexer
        Port (
            A1, B1, A2, B2, A3, B3, A4, B4, NG, NA_B: in STD_LOGIC;
            Y1, Y2, Y3, Y4: out STD_LOGIC
        );  
    end component;
    
    signal a_line: STD_LOGIC_VECTOR(3 downto 0);
    signal b_line: STD_LOGIC_VECTOR(3 downto 0);
    signal output: STD_LOGIC_VECTOR(3 downto 0);
    signal not_grant, is_b_selected: STD_LOGIC;
begin
    UUT: multiplexer port map (
        -- input multiplexer port mapping
        A1 => a_line(0),
        A2 => a_line(1),
        A3 => a_line(2),
        A4 => a_line(3),
        B1 => b_line(0),
        B2 => b_line(1),
        B3 => b_line(2),
        B4 => b_line(3),
        NG => not_grant,
        NA_B => is_b_selected,
        -- output multiplexer port mapping
        Y1 => output(0),
        Y2 => output(1),
        Y3 => output(2),
        Y4 => output(3)
    );
    
    process begin
        a_line <= "1010";
        b_line <= "0101";
        not_grant <= '0';
        is_b_selected <= '0';
        wait for 100 ns;
        
        a_line <= "0110";
        b_line <= "1001";
        not_grant <= '0';
        is_b_selected <= '1';
        wait for 100 ns;
        
        a_line <= "1010";
        b_line <= "0101";
        not_grant <= '1';
        is_b_selected <= '0';
        wait;
    end process;

end Behavioral;
