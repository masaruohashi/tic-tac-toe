-- VHDL de um mapeador de caracteres
library ieee;
use ieee.std_logic_1164.all;

entity mapeador_jogador is
  port(
    jogador             : in std_logic;
    caractere_jogador   : in std_logic_vector(6 downto 0);
    caractere_oponente  : in std_logic_vector(6 downto 0);
    caractere_saida     : out std_logic_vector(6 downto 0)
  );
end mapeador_jogador;

architecture estrutural of mapeador_jogador is
  signal sinal_caractere_saida: std_logic_vector(6 downto 0);
begin
  process (jogador)
  begin
    if jogador = '0' then
      sinal_caractere_saida <= caractere_jogador;
    else
      sinal_caractere_saida <= caractere_oponente;
    end if;
    caractere_saida <= sinal_caractere_saida;
  end process;
end estrutural;
