-- VHDL de um contador para a impressao do tabuleiro

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity contador_tabuleiro is
    port(
      clock     : in  std_logic;
      zera      : in  std_logic;
      conta     : in  std_logic;
      contagem  : out std_logic_vector(5 downto 0);
      fim       : out std_logic
    );
end contador_tabuleiro;

architecture exemplo of contador_tabuleiro is
signal IQ: unsigned(5 downto 0);

begin
  process (clock, conta, IQ, zera)
  begin

  if zera = '1' then
    IQ <= (others => '0');
  elsif clock'event and clock = '1' then
    if (conta = '1') then
      IQ <= IQ + 1;
    end if;
  end if;

  if IQ = 64 then
    fim <= '1';
  else
    fim <= '0';
  end if;

  contagem <= std_logic_vector(IQ);

  end process;
end exemplo;
