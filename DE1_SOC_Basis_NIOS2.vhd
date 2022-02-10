library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE1_SoC_Basic_Nios2_SOC is
port (
	-- Inputs
	CLOCK_50             : in std_logic;
	KEY                  : in std_logic_vector (3 downto 0);
	SW                   : in std_logic_vector (9 downto 0);
	----- ADC -------
	ADC_CONVST          : out std_logic;
	ADC_DIN             : out std_logic;
	ADC_DOUT            : in std_logic;
	ADC_SCLK            : out std_logic;
	
	
	-- Outputs
	LEDR            : out std_logic_vector (9 downto 0);

   HEX0            : out std_logic_vector (6 downto 0);
	HEX1            : out std_logic_vector (6 downto 0);
	HEX2            : out std_logic_vector (6 downto 0);
	HEX3            : out std_logic_vector (6 downto 0);
	HEX4            : out std_logic_vector (6 downto 0);
	HEX5            : out std_logic_vector (6 downto 0);
	
	AVALON			 : out std_logic_vector (7 downto 0);
	GPIO_0        : inout std_logic_vector(35 downto 0);
	GPIO_1        : inout std_logic_vector(35 downto 0)
	);
end entity;


architecture struct of DE1_SoC_Basic_Nios2_SOC is

component DE1_SoC_QSYS is
        port (
            adc_ltc2308_conduit_end_CONVST                          : out std_logic;                                       -- CONVST
            adc_ltc2308_conduit_end_SCK                             : out std_logic;                                       -- SCK
            adc_ltc2308_conduit_end_SDI                             : out std_logic;                                       -- SDI
            adc_ltc2308_conduit_end_SDO                             : in  std_logic                    := 'X';             -- SDO
            clk_clk                                                 : in  std_logic                    := 'X';             -- clk
            key_external_connection_export                          : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
            reset_reset_n                                           : in  std_logic                    := 'X';             -- reset_n
            sevenseg_readdata                                       : out std_logic_vector(6 downto 0);                    -- readdata
            sevenseg_readdata1                                      : out std_logic_vector(6 downto 0);                    -- readdata1
            sevenseg_readdata2                                      : out std_logic_vector(6 downto 0);                    -- readdata2
            sevenseg_readdata3                                      : out std_logic_vector(6 downto 0);                    -- readdata3
            sevenseg_readdata4                                      : out std_logic_vector(6 downto 0);                    -- readdata4
            sevenseg_readdata5                                      : out std_logic_vector(6 downto 0);                    -- readdata5
            sw_external_connection_export                           : in  std_logic_vector(9 downto 0) := (others => 'X'); -- export
            avalon_telemetre_pwm_0_conduit_end_beginbursttransfer   : in  std_logic                    := 'X';             -- beginbursttransfer
            avalon_telemetre_pwm_0_conduit_end_writeresponsevalid_n : out std_logic;                                       -- writeresponsevalid_n
            avalon_telemetre_pwm_0_conduit_end_readdata             : out std_logic_vector(9 downto 0);                  -- writedata				-- readdata
            avalon_servomoteur_pwm_writeresponsevalid_n             : out std_logic);
    end component DE1_SoC_QSYS;
	 
	 
	 begin
	 
	 u0 : component DE1_SoC_QSYS
        port map (
            adc_ltc2308_conduit_end_CONVST => ADC_CONVST,
            adc_ltc2308_conduit_end_SCK => ADC_SCLK,
            adc_ltc2308_conduit_end_SDI => ADC_DIN,
            adc_ltc2308_conduit_end_SDO => ADC_DOUT,
            clk_clk                                                 => CLOCK_50,                                                 --                                clk.clk
            key_external_connection_export                          => KEY,                          --            key_external_connection.export                                   --                    pll_sys_outclk2.clk
            reset_reset_n                                           => KEY(0),                                           --                              reset.reset_n
            sevenseg_readdata              => HEX0,              --                sevenseg.readdata
            sevenseg_readdata1             => HEX1,             --                        .readdata1
            sevenseg_readdata2             => HEX2,             --                        .readdata2
            sevenseg_readdata3             => HEX3,             --                        .readdata3
            sevenseg_readdata4             => HEX4,             --                        .readdata4
            sevenseg_readdata5             => HEX5,                                           --                                   .readdata5
            sw_external_connection_export                           => SW,                           --             sw_external_connection.export
            avalon_telemetre_pwm_0_conduit_end_beginbursttransfer   => GPIO_0(3),   -- avalon_telemetre_pwm_0_conduit_end.beginbursttransfer
            avalon_telemetre_pwm_0_conduit_end_writeresponsevalid_n => GPIO_0(1), --  				.writeresponsevalid_n
                                                   
            avalon_servomoteur_pwm_writeresponsevalid_n             => GPIO_1(1),             
				avalon_telemetre_pwm_0_conduit_end_readdata             => LEDR             --                                   .readdata
        );
--
--	 u1 : component servomoteur
--		port map (
--				clk => CLOCK_50,
--            reset_n => KEY(0),
--				position => SW,
--				commande => GPIO_1(1)
--				);


	 
--	 component telemetre_us is 
--		port (clk : in std_logic;
--				rst : in std_logic;
--				echo : in std_logic; -- sortie du telemetre de mesure donnee donc entree ici
--				trig : out std_logic; -- declenchement de la mesure
--				LEDR : out std_logic_vector(9 downto 0)
--	  
--				);
--    end component telemetre_us;
--
--		
--	 begin




end architecture;