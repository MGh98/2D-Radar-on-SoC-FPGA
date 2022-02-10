

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity telemetre_us is 
port (clk : in std_logic;
	  rst : in std_logic;
	  echo : in std_logic; -- sortie du telemetre de mesure donnee donc entree ici
	  trig : out std_logic; -- declenchement de la mesure
	  LEDR : out std_logic_vector(9 downto 0);
	  read_in : in  std_logic; 
	  chipselect : in  std_logic;
	  readdata : out std_logic_vector(31 downto 0)
	  );
end entity telemetre_us;


architecture struct of telemetre_us is

-- clock de 50MHz => periode de 20ns
-- creer impulsion pour trig
-- on veut trig 10us donc on compte 500 cycles de clock

SIGNAL Count_10us : std_logic_vector(8 downto 0):= (others => '0'); --x"000000000"
SIGNAL Count_70ms : std_logic_vector(21 downto 0):= (others => '0');
SIGNAL Count_echo : std_logic_vector(20 downto 0) := (others => '0'); 
SIGNAL Distance : std_logic_vector(20 downto 0):= (others => '0');

SIGNAL LEDR_in : std_logic_vector(9 downto 0) := (others => '0');

SIGNAL trig_temp : std_logic := '0';

SIGNAL calcul_distance : std_logic_vector(20 downto 0) := (others => '0'); -- 17 downto 0
SIGNAL flag : std_logic;
SIGNAL readdata_out : std_logic_vector (31 downto 0) := (others => '0');


begin
	-- process du count_10us
	Process_10us : PROCESS (clk, rst)
	begin
		if (rst = '0') then
			Count_10us <= "000000000";
			
		
		elsif (clk'event and clk = '1') then
		
			if (trig_temp = '1') then 
				Count_10us <= std_logic_vector(unsigned(Count_10us) + 1);
			
				if (Count_10us = "111110100") then
					Count_10us <= "000000000";
				end if;
				
			end if;
			
		end if;
		
	end process;
	
	-- process du count_70ms
	Process_70ms : PROCESS (clk, rst)
	begin
		if (rst = '0') then
			Count_70ms <= "0000000000000000000000";
			
		
		elsif (clk'event and clk = '1') then
			Count_70ms <= std_logic_vector(unsigned(Count_70ms) + 1);
			
			if (Count_70ms = "1101010110011111100000") then
				Count_70ms <= "0000000000000000000000";
				
			end if;
			
		end if;
		
	end process;		
	
	-- process du trig
	
	Process_trig : PROCESS (rst, clk)
	begin
		if (rst = '0') then
			trig_temp <= '0';
		elsif rising_edge(clk) then
		   if (Count_70ms = "0000000000000000000000") then
			trig_temp <= '1';
			
		elsif (Count_10us = "111110011") then
			trig_temp <= '0';
			
		end if;
	end if;
		
	end process;


	-- process de l'echo
	Process_echo : PROCESS (rst, clk)
	begin
		if (rst = '0') then
			Count_echo <= "000000000000000000000";
			flag <= '0';
			
		elsif (clk'event and clk = '1') then
			if (echo = '1') then
				Count_echo <= std_logic_vector(unsigned(Count_echo) + 1);
				flag <= '1';
			
			elsif (echo = '0' and flag = '1') then
				Distance <= Count_echo;
				Count_echo <= "000000000000000000000";
				flag <= '0';
				
			elsif (echo = '0' and flag = '0') then 
				Count_echo <= "000000000000000000000";
				
			end if;

			
		end if;
		
	end process;
	
	
	-- process de traitement de la donnee distance et allumage des leds
	Process_leds : PROCESS (Distance)
	begin
   LEDR_in <= "0000000000";
--		
   if (Distance > "000000000000000000000") then
	calcul_distance <= std_logic_vector(to_unsigned(to_integer(unsigned(Distance))/3333,21));
    		if (Distance < "000000000110100000101") then
				LEDR_in <= "1111111111";
			elsif (Distance >= "000000000110100000101" and Distance < "000000001101000001010") then
				LEDR_in <= "0111111111";
			elsif (Distance >= "000000001101000001010" and Distance < "000000010011100001111") then
				LEDR_in <= "0011111111";
			elsif (Distance >= "000000010011100001111" and Distance < "000000010111011100000") then
				LEDR_in <= "0001111111";
			elsif (Distance >= "000000010111011100000" and Distance < "000000011101010011000") then
				LEDR_in <= "0000111111";
			elsif (Distance >= "000000011101010011000" and Distance < "000000100011001010000") then	
				LEDR_in <= "0000011111";
			elsif (Distance >= "000000100011001010000" and Distance < "000000101010111110000") then	
				LEDR_in <= "0000001111";
			elsif (Distance >= "000000101010111110000" and Distance < "000000110000110101000") then	
				LEDR_in <= "0000000111";
			elsif (Distance >= "000000110000110101000") then
				LEDR_in <= "0000000011";
			else 
				LEDR_in <= "0000000000";
			
			end if;
		
		end if;
		
	end process;
	
	Process_read : PROCESS(rst,clk)
	begin 
		if (rst = '0') then 
			readdata_out <= (others => '0');
		
		elsif(clk'event and clk = '1') then 
	
			if (read_in = '1' and chipselect = '1') then
			
				readdata_out(20 downto 0) <= calcul_distance;
			end if;
		end if;
	end process;

	LEDR <= LEDR_in;
	readdata <= readdata_out;
	trig <= trig_temp;
	

end architecture struct;

