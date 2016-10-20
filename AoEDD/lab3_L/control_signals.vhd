----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2016 05:13:45 PM
-- Design Name: 
-- Module Name: control_signals - Behavioral
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

entity control_signals is
    Port (
        N_OE: in STD_LOGIC;
        ENT: in STD_LOGIC;
        ENP: in STD_LOGIC;
        N_SCLR: in STD_LOGIC;
        N_SLOAD: in STD_LOGIC;
        N_ACLR: in STD_LOGIC;
        N_ALOAD: in STD_LOGIC;
        CLK: in STD_LOGIC;
        
        
        OE: out STD_LOGIC;
        ACLR: out STD_LOGIC;
        ALOAD: out STD_LOGIC;
        N_CLK: out STD_LOGIC;
        CONTROL_BUS: out STD_LOGIC_VECTOR(2 downto 0) 
    );
end control_signals;
    
architecture Behavioral of control_signals is

begin
    -- simple signal transformation
    OE <= not N_OE;
    ACLR <= not N_ACLR;
    ALOAD <= not N_ALOAD;
    N_CLK <= not CLK;
    
    CONTROL_BUS(0) <= (ENT and ENP and N_SLOAD) and not N_SCLR;
    CONTROL_BUS(1) <= not N_SCLR and N_SLOAD;
    CONTROL_BUS(2) <= not N_SCLR and not N_SLOAD;
end Behavioral;
