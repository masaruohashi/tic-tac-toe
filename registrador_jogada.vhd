-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_jogada is
  port(
    clock: in std_logic;
    reset: in std_logic;
    guarda_jogada: in std_logic;
    jogador: in std_logic;
    entrada: in std_logic_vector(3 downto 0);
    jogadas_realizadas: out std_logic_vector(8 downto 0);
    jogadas_jogador: out std_logic_vector(8 downto 0)
  );
end registrador_jogada;

architecture comportamental of registrador_jogada is
signal sinal_jogadas: std_logic_vector(8 downto 0) := "000000000";
signal sinal_jogador: std_logic_vector(8 downto 0) := "000000000";
begin
  process(clock, reset, guarda_jogada, jogador, entrada)
  begin
    if reset='1' then
      sinal_jogadas <= (others => '0');
      sinal_jogador <= (others => '0');
    elsif clock'event and clock='1' then
      if guarda_jogada='1' then
        sinal_jogadas(to_integer(unsigned(entrada))) <= '1';
        if jogador = '1' then
          sinal_jogador(to_integer(unsigned(entrada))) <= '1';
        end if;
      end if;
    end if;
    jogadas_realizadas <= sinal_jogadas;
    jogadas_jogador <= sinal_jogador;
  end process;
end comportamental;
