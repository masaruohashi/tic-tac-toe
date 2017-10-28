-- VHDL que verifica se o caractere eh valido
library ieee;
use ieee.std_logic_1164.all;

entity valida_caractere is
  port(
    caractere        : in std_logic_vector(6 downto 0);
    caractere_valido : out std_logic
  );
end valida_caractere;

architecture estrutural of valida_caractere is
begin
  process (caractere)
  begin
    case caractere is
      when "0110111" =>
        caractere_valido <= '1' AND verifica_jogada;
      when "0111000" =>
        caractere_valido <= '1' AND verifica_jogada;
      when "0111001" =>
        caractere_valido <= '1' AND verifica_jogada;
      when "0110100" =>
        caractere_valido <= '1' AND verifica_jogada;
      when "0110101" =>
        caractere_valido <= '1' AND verifica_jogada;
      when "0110110" =>
        caractere_valido <= '1' AND verifica_jogada;
      when "0110001" =>
        caractere_valido <= '1' AND verifica_jogada;
      when "0110010" =>
        caractere_valido <= '1' AND verifica_jogada;
      when "0110011" =>
        caractere_valido <= '1' AND verifica_jogada;
      when others =>
        caractere_valido <= 0;
    end case;
  end process;
end estrutural;
