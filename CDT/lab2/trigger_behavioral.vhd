library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity trigger_behavioral is
    Port ( 
        D: in STD_LOGIC;
        R: in STD_LOGIC;
        S: in STD_LOGIC;
        C: in STD_LOGIC;
        Q: out STD_LOGIC
    );
end trigger_behavioral;

architecture Behavioral of trigger_behavioral is
begin
    process (D, R, S, C)
        variable trigger_state: STD_LOGIC := '0';
    begin
        if (R = '1' and C = '0') then
            trigger_state := '0';
            Q <= trigger_state;
        end if;
        
        if (R = '0' and S = '1' and C = '0') then
            trigger_state := '1';
            Q <= trigger_state;
        end if;
        
        if (R = '0' and S = '0' and C'event and C = '1') then
            trigger_state := D;
            Q <= trigger_state;
        end if;
        
        if (R = '0' and S = '0' and C = '0') then
            Q <= trigger_state;
        end if;
    end process;

end Behavioral;
