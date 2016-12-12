library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity NOAA is
    Port ( 
        A: in STD_LOGIC;
        B: in STD_LOGIC;
        C: in STD_LOGIC;
        D: in STD_LOGIC;
        OUTPUT: out STD_LOGIC
    );
end NOAA;

architecture Behavioral of NOAA is
begin
    OUTPUT <= not((A and B) or (C and D)) after 4 ns;
end Behavioral;
