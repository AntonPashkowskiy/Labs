----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2016 03:42:36 PM
-- Design Name: 
-- Module Name: storage_cell - Behavioral
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

entity storage_cell is
    Port ( 
        CLK: in STD_LOGIC;
        ACLR: in STD_LOGIC;
        ALOAD: in STD_LOGIC;
        A_INPUT: in STD_LOGIC;
        S_INPUT: in STD_LOGIC;
        LOCK: in STD_LOGIC;
        OUTPUT: out STD_LOGIC;
        LOCKABLE_OUTPUT: out STD_LOGIC
    );
end storage_cell;
    
architecture Behavioral of storage_cell is
    component jk_trigger is
    Port ( J : in STD_LOGIC;
           K : in STD_LOGIC;
           CLK : in STD_LOGIC;
           N_RESET : in STD_LOGIC;
           N_SET : in STD_LOGIC;
           Q : inout STD_LOGIC;
           NQ : inout STD_LOGIC);
    end component;
    
    signal  j, k, clock, n_reset, n_set, q, nq: STD_LOGIC;
    signal n_set_hight_async, n_set_low_async: STD_LOGIC;    
begin
    jk_trigger_instance: jk_trigger port map(
        J => j,
        K => k,
        CLK => clock,
        N_RESET => n_reset,
        N_SET => n_set,
        Q => q,
        NQ => nq
    );
    
    -- set trigger state async
    n_set_hight_async <= not (A_INPUT and ALOAD and not ACLR);
    n_set_low_async <= not ((ALOAD and n_set_hight_async) or ACLR);
    n_set <= n_set_hight_async;
    n_reset <= n_set_low_async;
    
    -- set trigger state sync
    clock <= CLK;
    j <= S_INPUT;
    k <= not S_INPUT;
    
    -- set storage cell output
    OUTPUT <= q;
    
    process (LOCK)
    begin
        if (LOCK = '1') then
           LOCKABLE_OUTPUT <= 'Z'; 
        elsif (LOCK = '0') then
           LOCKABLE_OUTPUT <= not nq;
        end if;
    end process;
end Behavioral;
