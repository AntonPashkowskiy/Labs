----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2016 11:14:18 AM
-- Design Name: 
-- Module Name: biderectional_register_tb - Behavioral
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

entity biderectional_register_tb is
--  Port ( );
end biderectional_register_tb;

architecture Behavioral of biderectional_register_tb is
    component bidirectional_register
        Port ( -- parallel inputs
               A : in STD_LOGIC;
               B : in STD_LOGIC;
               C : in STD_LOGIC;
               D : in STD_LOGIC;
               -- mode controls inputs
               S0 : in STD_LOGIC;
               S1 : in STD_LOGIC;
               -- serial data inputs
               SR_SER : in STD_LOGIC;
               SL_SER : in STD_LOGIC;
               -- clock and clear
               CLK : in STD_LOGIC;
               NOT_CLR : in STD_LOGIC;
               -- parallel outputs
               Qa : out STD_LOGIC;
               Qb : out STD_LOGIC;
               Qc : out STD_LOGIC;
               Qd : out STD_LOGIC
        );
    end component;
    
    signal inputs, outputs: STD_LOGIC_VECTOR(3 downto 0);
    signal s0, s1, sr_ser, sl_ser, clk, not_clr: STD_LOGIC;
begin
    biderectional_register_instance: bidirectional_register port map(
        A => inputs(0),
        B => inputs(1),
        C => inputs(2),
        D => inputs(3),
        S0 => s0,
        S1 => s1,
        SR_SER => sr_ser,
        SL_SER => sl_ser,
        CLK => clk,
        NOT_CLR => not_clr,
        Qa => outputs(0),
        Qb => outputs(1),
        Qc => outputs(2),
        Qd => outputs(3)
    );

end Behavioral;
