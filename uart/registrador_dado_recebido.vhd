-- VHDL de um Registrador de dados para a recepcao

library ieee;
use ieee.std_logic_1164.all;

entity registrador_dado_recebido is
  port(
    clock: in  std_logic;
    enable: in  std_logic;
    clear: in std_logic;
    entrada: in  std_logic_vector(11 downto 0);
    saida: out std_logic_vector(11 downto 0)
  );
end registrador_dado_recebido;

architecture exemplo of registrador_dado_recebido is
signal IQ : std_logic_vector(11 downto 0);

begin
  process (clock, enable, clear, IQ)
  begin

  if (clock'event and clock = '1') then
    if clear = '1' then
      IQ <= (others => '0');
    elsif enable = '1' then
      IQ <= entrada;
    end if;
  end if;

  saida <= IQ;
  end process;
end exemplo;
