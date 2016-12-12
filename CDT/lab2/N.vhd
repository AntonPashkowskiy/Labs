library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity N is
    Port ( 
        INPUT: in STD_LOGIC;
        OUTPUT: out STD_LOGIC
    );
end N;

architecture Behavioral of N is
begin
    OUTPUT <= not INPUT after 1 ns;
end Behavioral;
