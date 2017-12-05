-- VHDL da Unidade de Controle da interface jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity controle_envio_jogada is
  port(
    clock               : in std_logic;
    reset               : in std_logic;
    enviar_jogada       : in std_logic;  -- indica que deve habilitar o envio da jogada para a outra bancada
    fim_envio           : in std_logic;  -- indica que o dado terminou de ser enviado pela uart
    reenviar_dado       : out std_logic  -- indica que o dado será reenviado pela uart
  );
end controle_envio_jogada;

architecture comportamental of controle_envio_jogada is
type tipo_estado is (inicial, enviando);
signal estado   : tipo_estado;

begin
    process (clock, estado, reset)
    begin

    if reset = '1' then
        estado <= inicial;

    elsif (clock'event and clock = '1') then
      case estado is
        when inicial =>                -- Aguarda sinal de start
          if enviar_jogada = '1' then
            estado <= enviando;
          else
            estado <= inicial;
          end if;

        when enviando =>          -- Aguarda fim do envio pela uart do oponente
          if fim_envio = '1' then
            estado <= inicial;
          else
            estado <= enviando;
          end if;

        when others =>       -- Default
          estado <= inicial;
      end case;
    end if;
    end process;

    -- logica de saída
    with estado select
      reenviar_dado <= '1' when enviando,
                       '0' when others;
end comportamental;
