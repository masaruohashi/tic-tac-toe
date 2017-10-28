-- VHDL que verifica se o caractere eh valido
library ieee;
use ieee.std_logic_1164.all;

entity valida_caractere is
  port(
    caractere        : in std_logic_vector(6 downto 0);
    posicao_memoria  : out std_logic_vector(5 downto 0);
    caractere_valido : out std_logic
  );
end valida_caractere;

architecture estrutural of valida_caractere is
begin
  process (caractere)
  begin
    case caractere is
      when "0110111" =>
        posicao_memoria  <= "000001";
        caractere_valido <= '1';
      when "0111000" =>
        posicao_memoria  <= "000101";
        caractere_valido <= '1';
      when "0111001" =>
        posicao_memoria  <= "001001";
        caractere_valido <= '1';
      when "0110100" =>
        posicao_memoria  <= "011001";
        caractere_valido <= '1';
      when "0110101" =>
        posicao_memoria  <= "011101";
        caractere_valido <= '1';
      when "0110110" =>
        posicao_memoria  <= "100001";
        caractere_valido <= '1';
      when "0110001" =>
        posicao_memoria  <= "110001";
        caractere_valido <= '1';
      when "0110010" =>
        posicao_memoria  <= "110101";
        caractere_valido <= '1';
      when "0110011" =>
        posicao_memoria  <= "111001";
        caractere_valido <= '1';
      when others =>
        caractere_valido <= 0;
    end case;
  end process;
end estrutural;
