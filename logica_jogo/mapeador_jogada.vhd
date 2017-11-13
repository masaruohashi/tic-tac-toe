-- VHDL de um mapeador de jogadas do usuario
library ieee;
use ieee.std_logic_1164.all;

entity mapeador_jogada is
  port(
    caractere: in std_logic_vector(6 downto 0);
    jogada: out std_logic_vector(3 downto 0)
  );
end mapeador_jogada;

architecture comportamental of mapeador_jogada is
begin
  process (caractere)
  begin
    case caractere is
      when "0110111" =>
        jogada <= "0110";
      when "0111000" =>
        jogada <= "0111";
      when "0111001" =>
        jogada <= "1000";
      when "0110100" =>
        jogada <= "0011";
      when "0110101" =>
        jogada <= "0100";
      when "0110110" =>
        jogada <= "0101";
      when "0110001" =>
        jogada <= "0000";
      when "0110010" =>
        jogada <= "0001";
      when "0110011" =>
        jogada <= "0010";
      when others =>
        null;
    end case;
  end process;
end comportamental;
