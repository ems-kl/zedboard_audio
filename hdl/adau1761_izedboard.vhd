----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:47:06 01/18/2014 
-- Design Name: 
-- Module Name:    adau1761_izedboard - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

library unisim;
use unisim.vcomponents.all;

entity adau1761_izedboard is
    Port ( clk_48    : in  STD_LOGIC;
           AC_ADR0   : out   STD_LOGIC;
           AC_ADR1   : out   STD_LOGIC;
           AC_GPIO0  : out   STD_LOGIC;  -- I2S MISO
           AC_GPIO1  : in    STD_LOGIC;  -- I2S MOSI
           AC_GPIO2  : in    STD_LOGIC;  -- I2S_bclk
           AC_GPIO3  : in    STD_LOGIC;  -- I2S_LR
           AC_MCLK   : out   STD_LOGIC;
           AC_SCK    : out   STD_LOGIC;
           AC_SDA    : inout STD_LOGIC;
           hphone_l  : in    std_logic_vector(23 downto 0);
           hphone_r  : in    std_logic_vector(23 downto 0);
           line_in_l : out   std_logic_vector(23 downto 0);
           line_in_r : out   std_logic_vector(23 downto 0);
           new_sample: out   std_logic;
           sw : in std_logic_vector(1 downto 0);
           active : out std_logic_vector(1 downto 0)
        );
end adau1761_izedboard;

architecture Behavioral of adau1761_izedboard is

	COMPONENT i2c
	PORT(
		clk       : IN std_logic;    
		i2c_sda_i : IN std_logic;      
		i2c_sda_o : OUT std_logic;      
		i2c_sda_t : OUT std_logic;      
		i2c_scl   : OUT std_logic;
      sw : in std_logic_vector(1 downto 0);
      active : out std_logic_vector(1 downto 0));
	END COMPONENT;

	COMPONENT ADAU1761_interface
	PORT(
		clk_48 : IN std_logic;          
		codec_master_clk : OUT std_logic
		);
	END COMPONENT;

	COMPONENT i2s_bit_clock
	PORT(
		clk_48 : IN std_logic;          
		pulse_per_bit : OUT std_logic;
		i2s_clk : OUT std_logic
		);
	END COMPONENT;

   component clocking
   port(
      CLK_100           : in     std_logic;
      CLK_48            : out    std_logic;
      RESET             : in     std_logic;
      LOCKED            : out    std_logic
      );
   end component;

	COMPONENT audio_signal
	PORT(
		clk          : IN  std_logic;
		sample_taken : IN  std_logic;          
		audio_l      : OUT std_logic_vector(15 downto 0);
		audio_r      : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	COMPONENT i2s_data_interface
	PORT(
		clk         : IN  std_logic;
		audio_l_in  : IN  std_logic_vector(23 downto 0);
		audio_r_in  : IN  std_logic_vector(23 downto 0);
		i2s_bclk    : IN  std_logic;
		i2s_lr      : IN  std_logic;          
		audio_l_out : OUT std_logic_vector(23 downto 0);
		audio_r_out : OUT std_logic_vector(23 downto 0);
		new_sample  : OUT std_logic;
		i2s_d_out   : OUT std_logic;
		i2s_d_in    : IN  std_logic
		);
	END COMPONENT;

   signal audio_l             : std_logic_vector(15 downto 0);
   signal audio_r             : std_logic_vector(15 downto 0);
   signal codec_master_clk    : std_logic;

   signal i2c_scl   : std_logic;
   signal i2c_sda_i : std_logic;
   signal i2c_sda_o : std_logic;
   signal i2c_sda_t : std_logic;
   
   signal i2s_mosi  : std_logic;
   signal i2s_miso  : std_logic;
   signal i2s_bclk  : std_logic;
   signal i2s_lr    : std_logic;

begin
   AC_ADR0       <= '1';
   AC_ADR1       <= '1';
   AC_GPIO0      <= i2s_MISO;
   i2s_MOSI      <= AC_GPIO1;
   i2s_bclk      <= AC_GPIO2;
   i2s_lr        <= AC_GPIO3;
   AC_MCLK       <= codec_master_clk;
   AC_SCK        <= i2c_scl;
   
i_i2s_sda_obuf : IOBUF
   port map (
      IO => AC_SDA,   -- Buffer inout port (connect directly to top-level port)
      O => i2c_sda_i, -- Buffer output (to fabric)
      I => i2c_sda_o, -- Buffer input  (from fabric)
      T => i2c_sda_t  -- 3-state enable input, high=input, low=output 
   );
   
	Inst_i2c: i2c PORT MAP(
		clk       => CLK_48,
		i2c_sda_i => i2c_sda_i,
		i2c_sda_o => i2c_sda_o,
		i2c_sda_t => i2c_sda_t,
		i2c_scl   => i2c_scl,
      sw => sw,
      active => active
	);
     
i_ADAU1761_interface: ADAU1761_interface PORT MAP(
		clk_48 => clk_48 ,
		codec_master_clk => codec_master_clk
	);
   
Inst_i2s_data_interface: i2s_data_interface PORT MAP(
		clk         => clk_48,
		audio_l_out => line_in_l,
		audio_r_out => line_in_r,
		audio_l_in  => hphone_l,
		audio_r_in  => hphone_r,
		new_sample  => new_sample,

		i2s_bclk    => i2s_bclk,
		i2s_d_out   => i2s_MISO,
		i2s_d_in    => i2s_MOSI,
		i2s_lr      => i2s_lr
	);
end Behavioral;