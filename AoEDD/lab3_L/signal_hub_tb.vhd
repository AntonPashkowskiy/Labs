----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2016 07:39:03 AM
-- Design Name: 
-- Module Name: signal_hub_tb - Behavioral
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

entity signal_hub_tb is
--  Port ( );
end signal_hub_tb;

architecture Behavioral of signal_hub_tb is
    component signal_hub is
        Port (
            inputs: in STD_LOGIC_VECTOR(0 to 13);
            output: out STD_LOGIC 
        );
    end component;
    
    signal inp: STD_LOGIC_VECTOR(0 to 13);
    signal outp: STD_LOGIC;
begin
    signal_hub_instance: signal_hub port map(
        inputs => inp,
        output => outp
    );
    
    process
    begin
        for index in 0 to 8191 loop
            inp <= conv_std_logic_vector(index, 14);
            wait for 4ns;
        end loop;
    end process;
end Behavioral;
