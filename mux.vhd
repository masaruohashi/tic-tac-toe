-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity mux is
  port(
    clock           : in std_logic;
    verifica_jogada : in  std_logic;
    entrada         : in  std_logic_vector(8 downto 0);
    seletor         : in  std_logic_vector(6 downto 0);
    saida           : out std_logic
  );
end mux;

architecture comportamental of mux is
begin
  process(clock, verifica_jogada, entrada)
  begin
    if clock'event and clock='1' then
      if verifica_jogada='1' then
        case seletor is
          when "0110111" =>
            saida <= entrada(6);
          when "0111000" =>
            saida <= entrada(7);
          when "0111001" =>
            saida <= entrada(8);
          when "0110100" =>
            saida <= entrada(3);
          when "0110101" =>
            saida <= entrada(4);
          when "0110110" =>
            saida <= entrada(5);
          when "0110001" =>
            saida <= entrada(0);
          when "0110010" =>
            saida <= entrada(1);
          when "0110011" =>
            saida <= entrada(2);
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;
end comportamental;
