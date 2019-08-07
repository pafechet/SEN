--*********************************************************************************
--*********************************************************************************
--	                              CORRELATEUR
--*********************************************************************************
--*********************************************************************************
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.stimul_pack.all;
use work.all;

--/////////////////////
--    A COMPLETER
--/////////////////////
 entity correlateur is
  port( clke, clk, reset, ref : in std_logic;
	      d_in : in std_logic_vector(7 downto 0);
	      correll :  out std_logic_vector(19 downto 0));
end correlateur;

architecture arch_correlateur of correlateur is
  signal SPile1,SPile2:std_logic_vector(7 downto 0);
  signal Smultiplicateur: std_logic_vector(15 downto 0);
  signal SReg1, SReg2, SAdditionneur : std_logic_vector(19 downto 0);
  signal  cnt :  std_logic_vector(6 downto 0	);
  signal calc, raz_pile_ref, ld_pile_rec, raz_pile_rec, ld_pile_ref, raz_reg_pdt, ld_reg_pdt, raz_reg_sum, ld_reg_sum, raz_cnt, en_cnt :  std_logic ; 
  begin
  

sequenceur_corr1: entity sequenceur_corr port map (
                      clk => clk,
             									clke => clke,
             									ref => ref, 
             									reset => reset,
             									calc => calc,
             									raz_pile_ref => raz_pile_ref,
             									ld_pile_rec => ld_pile_rec,
             									raz_pile_rec => raz_pile_rec,
             									ld_pile_ref => ld_pile_ref,
             									raz_reg_pdt => raz_reg_pdt,
             									ld_reg_pdt => ld_reg_pdt,
             									raz_reg_sum => raz_reg_sum, 
             									ld_reg_sum => ld_reg_sum,
           									  raz_cnt => raz_cnt,
           									  en_cnt => en_cnt,
           									  cnt => cnt);
         									  
compteur: entity compteur_seq port map (
                      clk => clk,
                      raz=>raz_cnt,
                      en=>en_cnt,
                      cnt=>cnt);

pile_a: entity pile_ref  generic map(taille_pile => 44) port map (
                      clk => clk,
                      ld_pile_ref => ld_pile_ref,
                      raz_pile_ref => raz_pile_ref,
                      calc => calc,
                      d_in => d_in,
                      Sout => SPile1);


pile_b: entity pile_ref generic map(taille_pile=>44) port map (
                      clk => clk,
                      ld_pile_ref => ld_pile_rec,
                      raz_pile_ref => raz_pile_rec,
                      calc => calc,d_in => d_in,
                      Sout => SPile2);

multiplicateur1 : entity multiplicateur port map (
                      A=>SPile1,
                      B=>SPile2,
                      S=>Smultiplicateur);
  
registre1: entity registre generic map(t_e => 16, t_s => 20) port map (
                      clk => clk, 
                      raz => raz_reg_pdt,
                      ld => ld_reg_pdt,
                      data_in => Smultiplicateur,
                      data_out => SReg1);
   
registre2: entity registre generic map(t_e=>20,t_s=>20) port map (
	                    clk => clk, 
	                    raz => raz_reg_sum,
	                    ld => ld_reg_sum,
	                    data_in => SAdditionneur,
	                    data_out => SReg2);  
   
additionneur1: entity additionneur port map (
                      E1 => SReg1,
                      E2 => SReg2,
                      S => SAdditionneur);

  
	correll <= SReg2;
end arch_correlateur;  
      
