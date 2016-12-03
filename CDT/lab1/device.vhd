----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2016 03:30:08 PM
-- Design Name: 
-- Module Name: device - Behavioral
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

entity device is
    Port (
        X1: in STD_LOGIC;
        X2: in STD_LOGIC;
        X3: in STD_LOGIC;
        X4: in STD_LOGIC;
        Y1: out STD_LOGIC;
        Y2: out STD_LOGIC;
        Y3: out STD_LOGIC;
        Y4: out STD_LOGIC 
    );
end device;

architecture Behavioral of device is
    component NO3A2
        Port ( 
            A: in STD_LOGIC;
            B: in STD_LOGIC;
            C: in STD_LOGIC;
            D: in STD_LOGIC;
            OUTPUT: out STD_LOGIC
        );
    end component;
    
    component EX2
        Port ( 
            A: in STD_LOGIC;
            B: in STD_LOGIC;
            OUTPUT: out STD_LOGIC
        );
    end component;
    
    component NOA3
        Port (
            A: in STD_LOGIC;
            B: in STD_LOGIC;
            C: in STD_LOGIC;
            D: in STD_LOGIC;
            OUTPUT: out STD_LOGIC
        );
    end component;

    component NAO22
        Port ( 
            A: in STD_LOGIC;
            B: in STD_LOGIC;
            C: in STD_LOGIC;
            D: in STD_LOGIC;
            OUTPUT: out STD_LOGIC
        );
    end component;

    signal first_no3a2, second_no3a2: STD_LOGIC;
    signal first_ex2: STD_LOGIC;
    signal first_noa3: STD_LOGIC;
    signal first_nao22: STD_LOGIC;
    signal N_X2, N_X4, n_first_noa3, N_X1: STD_LOGIC;
begin
    N_X2 <= not X2;
    N_X4 <= not X4;
    n_first_noa3 <= not first_noa3;
    N_X1 <= not X1;

    first_no3a2_instance: NO3A2 port map(
        A => X3,
        B => N_X2,
        C => N_X4,
        D => X1,
        OUTPUT => first_no3a2
    );
    
    ex2_instance: EX2 port map(
        A => X4,
        B => X1,
        OUTPUT => first_ex2
    );
    
    noa3_instance: NOA3 port map(
        A => first_no3a2,
        B => first_ex2,
        C => X3,
        D => N_X2,
        OUTPUT => first_noa3
    );
    
    second_no3a2_instance: NO3A2 port map(
        A => N_X4,
        B => n_first_noa3,
        C => N_X2,
        D => X1,
        OUTPUT => second_no3a2
    );
    
    nao22_instance: NAO22 port map(
        A => X3,
        B => N_X2,
        C => N_X1,
        D => first_noa3,
        OUTPUT => first_nao22
    );
        
    Y1 <= not first_noa3;
    Y2 <= second_no3a2;
    Y3 <= X1;
    Y4 <= first_nao22;
end Behavioral;
