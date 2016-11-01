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
    signal first_no3a2, second_no3a2: STD_LOGIC;
    signal ex2: STD_LOGIC;
    signal noa3: STD_LOGIC;
    signal nao22: STD_LOGIC;
begin
    first_no3a2 <= not (X3 xor (not X2) xor (not X4 and X1));
    ex2 <= (X4 and not X1) xor (not X4 and X1);
    noa3 <= not (first_no3a2 xor (ex2 and X3 and not X2));
    
    second_no3a2 <= not ((not X4) xor (not noa3) xor (not X2 and X1));
    nao22 <= not ((X3 xor (not X2)) and ((not X1) xor noa3));
    
    Y1 <= not noa3;
    Y2 <= second_no3a2;
    Y3 <= X1;
    Y4 <= nao22;
end Behavioral;
