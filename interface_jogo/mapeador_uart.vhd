-- VHDL de um mapeador para a habilitação da UART
library ieee;
use ieee.std_logic_1164.all;

entity mapeador_uart is
  port(
    jogador: in std_logic;
    uart_recebe_dado: in std_logic;
    uart_jogador: out std_logic;
    uart_oponente: out std_logic
  );
end mapeador_uart;

architecture estrutural of mapeador_uart is
begin
  process (uart_recebe_dado, jogador)
  begin
    if uart_recebe_dado = '1' then
      if jogador='0' then
        uart_jogador <= '1';
        uart_oponente <= '0';
      else
        uart_jogador <= '0';
        uart_oponente <= '1';
      end if;
    else
      uart_jogador <= '0';
      uart_oponente <= '0';
    end if;
  end process;
end estrutural;
