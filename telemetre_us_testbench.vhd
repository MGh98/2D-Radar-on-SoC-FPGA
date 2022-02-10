library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity telemetre_testbench is 
end telemetre_testbench;

Architecture test_bench of telemetre_testbench is
signal clk, rst, trig, echo: std_logic := '0';
signal readdata : std_logic_vector(31 downto 0):= (others => '0');
signal LEDR : std_logic_vector(9 downto 0):= (others => '0');
signal Done : boolean := False;

constant period : time := 20 ns;

begin

	 UUT : entity work.telemetre_us 
		port map (clk => clk,
				  rst => rst,
				  trig => trig,
				  echo => echo,
				  LEDR => LEDR,
				  read => read,
				  chipselect => chipselect,
				  readdata => readdata);


clk <= '0' when Done else not clk after period / 2;
rst <= '1', '0' after 5 ms;

test : process

begin 
  
	read <= '0';
	chipselect <= '0';
  
	echo <= '0';
	wait for 1 ms;
	
	echo <= '1';
	wait for 5 ms;
	echo <= '0';
	wait for 10 ms;
	
	read <= '1';
	chipselect <= '1';
	
	echo <= '1';
	wait for 10 ms;
	echo <= '0';
	wait for 10 ms;
	
    echo <= '1';
	wait for 15 ms;
	echo <= '0';
	wait for 10 ms;
	
	echo <= '1';
	wait for 20 ms;
	echo <= '0';
	wait for 10 ms;
	
	echo <= '1';
	wait for 25 ms;
	echo <= '0';
	wait for 10 ms;
	
	echo <= '1';
	wait for 30 ms;
	echo <= '0';
	wait for 10 ms;
	
	echo <= '1';
	wait for 35 ms;
	echo <= '0';
	wait for 10 ms;
	
	echo <= '1';
	wait for 40 ms;
	echo <= '0';
	wait for 10 ms;
	
	Done <= True;
	wait;
	
end process;


end test_bench;