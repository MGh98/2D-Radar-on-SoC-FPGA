
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity servomoteur is 
	port (clk : in std_logic;
	  reset_n : in std_logic;
	  address : in std_logic;
	  chipselect : in std_logic;
	  write_n : in std_logic;
	  WriteData : in std_logic_vector(15 downto 0);
	  commande : out std_logic
	);
end entity servomoteur;


architecture struct of servomoteur is

SIGNAL Count_20ms : std_logic_vector(19 downto 0):= (others => '0');
SIGNAL Max_count : std_logic_vector(16 downto 0) := (others => '0');
SIGNAL count_temp : std_logic_vector(16 downto 0) := (others => '0');
SIGNAL commande_temp : std_logic := '0';
Signal flag : std_logic := '0';


begin

	Process_20ms : PROCESS (clk, reset_n)
	begin
		if (reset_n = '0') then
			Count_20ms <= "00000000000000000000";
			count_temp <= (others => '0');
			flag <= '0';
			commande_temp <= '0';
			
		elsif (clk'event and clk = '1') then
		
			if flag = '0' then
				Count_20ms <= std_logic_vector(unsigned(Count_20ms) + 1);
				if (Count_20ms = "11110100001001000000") then
					Count_20ms <= "00000000000000000000";
					flag <= '1';
				end if;
				
			elsif flag = '1' then
				count_temp <= std_logic_vector(unsigned(count_temp) + 1);
				commande_temp <= '1';
				
				if (Count_temp = (std_logic_vector(to_unsigned(50000 + (to_integer(unsigned(WriteData)) * 250) ,17 )))) then
					if Count_temp < "11000011010100001" then 
						count_temp <= (others => '0');
						commande_temp <= '0';
						flag <= '0';
					end if;
				
				end if;
				
			end if;
		end if;
		end process;
			


	commande <= commande_temp;
	


end architecture struct;