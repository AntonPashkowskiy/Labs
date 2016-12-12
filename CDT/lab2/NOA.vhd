library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NOA is
    Port ( 
        A: in STD_LOGIC;
        B: in STD_LOGIC;
        C: in STD_LOGIC;
        OUTPUT: out STD_LOGIC
    );
end NOA;

architecture Behavioral of NOA is
begin
    OUTPUT <= not(A or (B and C))after 3 ns;
end Behavioral;
