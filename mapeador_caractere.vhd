-- VHDL de um mapeador de caracteres
library ieee;
use ieee.std_logic_1164.all;

entity mapeador_caractere is
  port(
    caractere: in std_logic_vector(6 downto 0);
    posicao_memoria: out std_logic_vector(6 downto 0)
  );
end mapeador_caractere;

architecture estrutural of mapeador_caractere is
begin
  process (caractere)
  begin
    case caractere is
      when "0110111" =>
        posicao_memoria <= "0000101";
      when "0111000" =>
        posicao_memoria <= "0001001";
      when "0111001" =>
        posicao_memoria <= "0001101";
      when "0110100" =>
        posicao_memoria <= "0011101";
      when "0110101" =>
        posicao_memoria <= "0100001";
      when "0110110" =>
        posicao_memoria <= "0100101";
      when "0110001" =>
        posicao_memoria <= "0110101";
      when "0110010" =>
        posicao_memoria <= "0111001";
      when "0110011" =>
        posicao_memoria <= "0111101";
      when others =>
        null;
    end case;
  end process;
end estrutural;
