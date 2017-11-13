-- VHDL que verifica se o caractere eh valido
library ieee;
use ieee.std_logic_1164.all;

entity valida_caractere is
  port(
    caractere             : in  std_logic_vector(6 downto 0);
    caractere_valido      : out std_logic
  );
end valida_caractere;

architecture estrutural of valida_caractere is
  signal sinal_caractere_valido: std_logic := '0';
begin
  process (caractere)
  begin
    case caractere is
      when "0110111" =>
        sinal_caractere_valido <= '1';
      when "0111000" =>
        sinal_caractere_valido <= '1';
      when "0111001" =>
        sinal_caractere_valido <= '1';
      when "0110100" =>
        sinal_caractere_valido <= '1';
      when "0110101" =>
        sinal_caractere_valido <= '1';
      when "0110110" =>
        sinal_caractere_valido <= '1';
      when "0110001" =>
        sinal_caractere_valido <= '1';
      when "0110010" =>
        sinal_caractere_valido <= '1';
      when "0110011" =>
        sinal_caractere_valido <= '1';
      when others =>
        sinal_caractere_valido <= '0';
    end case;
    caractere_valido <= sinal_caractere_valido;
  end process;
end estrutural;
