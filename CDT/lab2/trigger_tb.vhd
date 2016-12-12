library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity trigger_tb is
    --Port ( );
end trigger_tb;

architecture Behavioral of trigger_tb is
    component trigger
        Port ( 
            D: in STD_LOGIC;
            R: in STD_LOGIC;
            S: in STD_LOGIC;
            C: in STD_LOGIC;
            Q: out STD_LOGIC
        );
    end component;
    
    type TRIGGER_TEST is array (0 to 8) of STD_LOGIC_VECTOR(0 to 3);
    
    signal inputs: STD_LOGIC_VECTOR(0 to 3);
    signal output: STD_LOGIC;
    constant manual_functional_test: TRIGGER_TEST := (
        "1000",
        "0011",
        "0010",
        "0001",
        "0000",
        "0011",
        "1010",
        "0001",
        "0100"
    );
begin
    trigger_instance: trigger port map(
        R => inputs(0),
        S => inputs(1),
        D => inputs(2),
        C => inputs(3),
        Q => output
    );
    
    process
    begin
        for index in 0 to 8 loop
            inputs <= manual_functional_test(index);
            wait for 100ns;
        end loop;
    end process;

end Behavioral;
