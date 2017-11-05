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
        posicao_memoria <= "0010010";
      when "0111000" =>
        posicao_memoria <= "0010110";
      when "0111001" =>
        posicao_memoria <= "0011010";
      when "0110100" =>
        posicao_memoria <= "0101010";
      when "0110101" =>
        posicao_memoria <= "0101110";
      when "0110110" =>
        posicao_memoria <= "0110010";
      when "0110001" =>
        posicao_memoria <= "0110001";
      when "0110010" =>
        posicao_memoria <= "1000010";
      when "0110011" =>
        posicao_memoria <= "1001010";
      when others =>
        null;
    end case;
  end process;
end estrutural;
