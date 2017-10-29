-- VHDL que verifica se o caractere eh valido
library ieee;
use ieee.std_logic_1164.all;

entity valida_caractere is
  port(
    verifica_jogada       : in  std_logic;
    caractere             : in  std_logic_vector(6 downto 0);
    caractere_valido      : out std_logic;
    fim_valida_caractere  : out std_logic
  );
end valida_caractere;

architecture estrutural of valida_caractere is
begin
  process (caractere)
  begin
    if verifica_jogada = '1' then
      case caractere is
        when "0110111" =>
          caractere_valido <= '1';
        when "0111000" =>
          caractere_valido <= '1';
        when "0111001" =>
          caractere_valido <= '1';
        when "0110100" =>
          caractere_valido <= '1';
        when "0110101" =>
          caractere_valido <= '1';
        when "0110110" =>
          caractere_valido <= '1';
        when "0110001" =>
          caractere_valido <= '1';
        when "0110010" =>
          caractere_valido <= '1';
        when "0110011" =>
          caractere_valido <= '1';
        when others =>
          caractere_valido <= '0';
      end case;
      fim_valida_caractere <= '1';
    else
      fim_valida_caractere <= '0';
    end if;
  end process;
end estrutural;
