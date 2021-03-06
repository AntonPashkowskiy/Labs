----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2016 04:20:04 PM
-- Design Name: 
-- Module Name: device_tb - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity device_tb is
--  Port ( );
end device_tb;

architecture Behavioral of device_tb is
    component device is
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
    end component;
    
    signal inputs, outputs: STD_LOGIC_VECTOR(3 downto 0);
begin
    device_instance: device port map(
        X1 => inputs(0),
        X2 => inputs(1),
        X3 => inputs(2),
        X4 => inputs(3),
        Y1 => outputs(0),
        Y2 => outputs(1),
        Y3 => outputs(2),
        Y4 => outputs(3)
    );
    
    process
    begin
        for index in 0 to 15 loop
            inputs <= conv_std_logic_vector(index, 4);
            wait for 5ns;
        end loop;
    end process;
end Behavioral;
