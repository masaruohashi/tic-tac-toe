-- VHDL de um Registrador de Deslocamento para a direita.

library ieee;
use ieee.std_logic_1164.all;

entity registrador_deslocamento_recepcao is
  port(
    clock       : in  std_logic;
    enable      : in  std_logic;
    shift       : in  std_logic;
    RIN         : in  std_logic;
    saida       : out std_logic_vector(11 downto 0)
  );
end registrador_deslocamento_recepcao;

architecture exemplo of registrador_deslocamento_recepcao is
signal IQ : std_logic_vector(11 downto 0);

begin
  process (clock, shift, IQ)
  begin

  if (clock'event and clock = '1') then
    if (shift = '1' and enable = '1') then
      IQ <= RIN & IQ(11 downto 1);
    end if;
  end if;

  saida <= IQ;
  end process;
end exemplo;
