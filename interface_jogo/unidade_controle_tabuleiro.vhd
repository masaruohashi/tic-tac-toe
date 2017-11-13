-- VHDL da Unidade de Controle do modulo de impressão do tabuleiro
library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_tabuleiro is
  port(
    clock: in std_logic;
    reset: in std_logic;
    start: in std_logic;
    fim_contagem: in std_logic;
    uart_livre: in std_logic;
    transmite_dado: out std_logic;
    atualiza_caractere: out std_logic;
    pronto: out std_logic
  );
end unidade_controle_tabuleiro;

architecture comportamental of unidade_controle_tabuleiro is
type tipo_estado is (inicial, prepara, imprime, final);
signal estado   : tipo_estado;

begin
    process (clock, estado, reset)
    begin

    if reset = '1' then
      estado <= inicial;
    elsif (clock'event and clock = '1') then
      case estado is
        when inicial =>                -- Aguarda sinal de start
          if start = '1' then
            estado <= prepara;
          else
            estado <= inicial;
          end if;

        when prepara =>
          if fim_contagem = '1' then
            estado <= final;
          else
            estado <= imprime;
          end if;

        when imprime =>                -- Imprime o tabuleiro no terminal
          if uart_livre = '1' then
            estado <= prepara;
          else
            estado <= imprime;
          end if;

        when final =>
          estado <= inicial;

        when others =>       -- Default
          estado <= inicial;
      end case;
    end if;
    end process;

    -- logica de saída
    with estado select
      transmite_dado <= '1' when imprime,
                        '0' when others;

    with estado select
      atualiza_caractere <= '1' when prepara,
                            '0' when others;

    with estado select
      pronto <= '1' when final,
                '0' when others;
end comportamental;
