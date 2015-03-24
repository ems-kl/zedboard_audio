----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz> 
-- 
-- Module Name:    ADAU1761_interface - Behavioral 
-- Description: Was originally to do a lot more, but just creates a clock at 1/2
--              the projects 48MHz to send to the codec.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ADAU1761_interface is
    Port ( clk_48 : in  STD_LOGIC;
           codec_master_clk : out  STD_LOGIC);
end ADAU1761_interface;

architecture Behavioral of ADAU1761_interface is
   signal master_clk : std_logic := '0';
begin
   codec_master_clk <= master_clk;
   
process(clk_48)
   begin
      if rising_edge(clk_48) then
         master_clk <= not master_clk;
      end if;
   end process;
end Behavioral;

