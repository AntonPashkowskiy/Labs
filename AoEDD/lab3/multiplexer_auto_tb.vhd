----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/06/2016 04:35:42 PM
-- Design Name: 
-- Module Name: multiplexer_auto_tb - Behavioral
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

entity multiplexer_auto_tb is
--  Port ( );
end multiplexer_auto_tb;

architecture Behavioral of multiplexer_auto_tb is
    component multiplexer is
        Port ( A1 : in STD_LOGIC;
               B1 : in STD_LOGIC;
               A2 : in STD_LOGIC;
               B2 : in STD_LOGIC;
               A3 : in STD_LOGIC;
               B3 : in STD_LOGIC;
               A4 : in STD_LOGIC;
               B4 : in STD_LOGIC;
               NG : in STD_LOGIC;
               NA_B : in STD_LOGIC;
               Y1 : out STD_LOGIC;
               Y2 : out STD_LOGIC;
               Y3 : out STD_LOGIC;
               Y4 : out STD_LOGIC
        );
    end component;
    
    function str2vec(str : string) return std_logic_vector is
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
    end str2vec;
    
    function vec2str(vec : std_logic_vector) return string is
        variable stmp : string(vec'LEFT+1 downto 1);
    begin
        for i in vec'REVERSE_RANGE loop
            if vec(i) = '1' then
                stmp(i+1) := '1';
            elsif vec(i) = '0' then
                stmp(i+1) := '0';
            else
                stmp(i+1) := 'X';
            end if;
        end loop;
        return stmp;
    end vec2str;
    
    signal a_line, b_line, output: STD_LOGIC_VECTOR(3 downto 0);
    signal ng, na_b: STD_LOGIC;
    
begin
    multiplexer_instance: multiplexer port map(
        A1 => a_line(0),
        A2 => a_line(1),
        A3 => a_line(2),
        A4 => a_line(3),
        B1 => b_line(0),
        B2 => b_line(1),
        B3 => b_line(2),
        B4 => b_line(3),
        Y1 => output(0),
        Y2 => output(1),
        Y3 => output(2),
        Y4 => output(3),
        NG => ng,
        NA_B => na_b
    );
    
    process
        file test_values_file: TEXT open READ_MODE is "test_values.txt"; 
        variable current_line: LINE;
        variable test_vector: STD_LOGIC_VECTOR(0 to 13);
        variable test_vector_string: STRING(14 downto 1);
        variable expected_output: STD_LOGIC_VECTOR(3 downto 0);
    begin
        while not endfile(test_values_file) loop
            readline(test_values_file, current_line);
            read(current_line, test_vector_string);
            
            test_vector := str2vec(test_vector_string);
            a_line <= test_vector(0 to 3); 
            b_line <= test_vector(4 to 7);
            ng <= test_vector(8);
            na_b <= test_vector(9);
            expected_output := test_vector(10 to 13);
            
            wait for 4 ns;
            
            if output /= expected_output then
                assert false;
                report "Failure for string: " & test_vector_string &
                       " expected value: " & vec2str(expected_output) &
                       " result value: " & vec2str(output);
            end if;
        end loop;
    end process;
end Behavioral;
