library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity trigger is
    Port ( 
        D: in STD_LOGIC;
        R: in STD_LOGIC;
        S: in STD_LOGIC;
        C: in STD_LOGIC;
        Q: out STD_LOGIC
    );
end trigger;

architecture Behavioral of trigger is
    component N
        Port ( 
            INPUT: in STD_LOGIC;
            OUTPUT: out STD_LOGIC
        );
    end component;
    
    component NOA
        Port ( 
            A: in STD_LOGIC;
            B: in STD_LOGIC;
            C: in STD_LOGIC;
            OUTPUT: out STD_LOGIC
        );
    end component;
    
    component NOAA
        Port ( 
            A: in STD_LOGIC;
            B: in STD_LOGIC;
            C: in STD_LOGIC;
            D: in STD_LOGIC;
            OUTPUT: out STD_LOGIC
        );
    end component;
    
    signal ns, nc, nnc: STD_LOGIC;
    signal noaa_r, noa_r: STD_LOGIC;
begin
    n_first_instance: N port map(C, nc);
    n_second_instance: N port map(nc, nnc);
    n_third_instance: N port map(S, ns);
    noaa_first_instance: NOAA port map(noa_r, nc, D, nnc, noaa_r);
    noa_first_instance: NOA port map(R, ns, noaa_r, noa_r);
    n_four_instance: N port map(noaa_r, Q);
end Behavioral;
