library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity servomoteur_testbench is 
end servomoteur_testbench;

Architecture test_bench of servomoteur_testbench is
signal clk, reset_n, address, chipselect, write_n, commande: std_logic := '0';
--signal position : std_logic_vector(9 downto 0):= (others => '0');
signal WriteData : std_logic_vector(15 downto 0):= (others => '0');
signal Done : boolean := False;

constant period : time := 20 ns;

begin

	 UUT : entity work.servomoteur 
		port map (clk => clk,
				  reset_n => reset_n,
				  address => address, 
				  chipselect => chipselect,
				  write_n => write_n,
				  WriteData => WriteData,
				  commande => commande
				  );

clk <= '0' when Done else not clk after period / 2;
reset_n <= '0', '1' after 5 ms;

test : process

begin 
	WriteData <= "0000000000000000";
	wait for 30 ms;
	
	WriteData <= "0000000001000000";
	wait for 30 ms;
	
	WriteData <= "0000000000000100";
	wait for 30 ms;
	
	WriteData <= "0000000000001000";
	wait for 30 ms;
	
	WriteData <= "0000000000010000";
	wait for 30 ms;
	
	Done <= True;
	wait;
	
end process;



end test_bench;