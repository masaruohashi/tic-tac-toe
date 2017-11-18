-- VHDL de um mapeador entrada de caractere paralelo
library ieee;
use ieee.std_logic_1164.all;

entity mapeador_entrada_caractere is
  port(
    jogador: in std_logic_vector(6 downto 0);
    oponente: in std_logic_vector(6 downto 0);
    jogador_atual: in std_logic;
    entrada_caractere: out std_logic_vector(6 downto 0)
  );
end mapeador_entrada_caractere;

architecture estrutural of mapeador_entrada_caractere is
begin
  process (jogador_atual)
  begin
    if jogador_atual='0' then
      entrada_caractere <= jogador;
    else
      entrada_caractere <= oponente;
    end if;
  end process;
end estrutural;
