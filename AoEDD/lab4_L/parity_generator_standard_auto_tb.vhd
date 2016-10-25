----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2016 01:34:57 PM
-- Design Name: 
-- Module Name: parity_generator_standard_auto_tb - Behavioral
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
use STD.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parity_generator_standard_auto_tb is
--  Port ( );
end parity_generator_standard_auto_tb;

architecture Behavioral of parity_generator_standard_auto_tb is
    component parity_generator is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           D : in STD_LOGIC;
           E : in STD_LOGIC;
           F : in STD_LOGIC;
           G : in STD_LOGIC;
           H : in STD_LOGIC;
           I : in STD_LOGIC;
           PARITY_IO : inout STD_LOGIC;
           N_XMIT : in STD_LOGIC;
           PARITY_ERROR: out STD_LOGIC);
    end component;

    component parity_generator_serial is
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               C : in STD_LOGIC;
               D : in STD_LOGIC;
               E : in STD_LOGIC;
               F : in STD_LOGIC;
               G : in STD_LOGIC;
               H : in STD_LOGIC;
               I : in STD_LOGIC;
               PARITY_IO : inout STD_LOGIC;
               N_XMIT : in STD_LOGIC;
               PARITY_ERROR: out STD_LOGIC);
    end component;
    
    function stringToLogicVector(str : string) return std_logic_vector is
        variable vtmp: std_logic_vector(str'range);
    begin
        for i in str'range loop
            if str(i) = '1' then
                vtmp(i) := '1';
            elsif str(i) = '0' then
                vtmp(i) := '0';
            else
                vtmp(i) := 'X';
            end if;
        end loop;
        return vtmp;
    end stringToLogicVector;

    signal inputs: STD_LOGIC_VECTOR(8 downto 0);
    signal parity_io, n_xmit, parity_error: STD_LOGIC;
    signal parity_io_serial, n_xmit_serial, parity_error_serial: STD_LOGIC;
begin
    parity_generator_instance: parity_generator port map(
        A => inputs(0),
        B => inputs(1),
        C => inputs(2),
        D => inputs(3),
        E => inputs(4),
        F => inputs(5),
        G => inputs(6),
        H => inputs(7),
        I => inputs(8),
        PARITY_IO => parity_io,
        N_XMIT => n_xmit,
        PARITY_ERROR => parity_error
    );
    
    parity_generator_instance_serial: parity_generator_serial port map(
        A => inputs(0),
        B => inputs(1),
        C => inputs(2),
        D => inputs(3),
        E => inputs(4),
        F => inputs(5),
        G => inputs(6),
        H => inputs(7),
        I => inputs(8),
        PARITY_IO => parity_io_serial,
        N_XMIT => n_xmit_serial,
        PARITY_ERROR => parity_error_serial
    );
    
    process
        file test_file: TEXT open READ_MODE is "test.txt"; 
        variable current_line: LINE;
        variable test_vector: STD_LOGIC_VECTOR(0 to 11);
        variable test_vector_string: STRING(12 downto 1);
        variable expected_output: STD_LOGIC;
    begin
        while not endfile(test_file) loop
            readline(test_file, current_line);
            read(current_line, test_vector_string);
            
            test_vector := stringToLogicVector(test_vector_string);
            inputs <= test_vector(0 to 8);
            n_xmit <= test_vector(9);
            n_xmit_serial <= test_vector(9);
            parity_io <= test_vector(10);
            parity_io_serial <= test_vector(10);
                        
            wait for 5 ns;
            
            if (parity_error_serial /= parity_error) then
                report "Error on vector: " & test_vector_string;
            end if;
        end loop;
    end process;
end Behavioral;
