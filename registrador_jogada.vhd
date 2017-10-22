-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity registrador_jogada is
  port(
    clock: in std_logic;
    reset: in std_logic;
    guarda_jogada: in std_logic;
    entrada: in std_logic_vector(6 downto 0);
    dados: out std_logic_vector(8 downto 0)
  );
end registrador_jogada;

architecture estrutural of registrador_jogada is
signal sinal_dados: std_logic_vector(8 downto 0);
begin
  process(clock, reset, guarda_jogada)
  begin
    if reset='1' then
      sinal_dados <= (others => '0');
    elsif clock'event and clock='1' then
      if guarda_jogada='1' then
        case entrada is
          when "0110001" =>
            sinal_dados(0) <= '1';
          when "0110010" =>
            sinal_dados(1) <= '1';
          when "0110011" =>
            sinal_dados(2) <= '1';
          when "0110100" =>
            sinal_dados(3) <= '1';
          when "0110101" =>
            sinal_dados(4) <= '1';
          when "0110110" =>
            sinal_dados(5) <= '1';
          when "0110111" =>
            sinal_dados(6) <= '1';
          when "0111000" =>
            sinal_dados(7) <= '1';
          when "0111001" =>
            sinal_dados(8) <= '1';
          when others =>
            null;
        end case;
      end if;
    end if;
    dados <= sinal_dados;
  end process;
end estrutural;
