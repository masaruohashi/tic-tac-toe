-- VHDL da Unidade de Controle

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_interface_recepcao is
   port(
    clock: in   std_logic;
    reset: in   std_logic;
    pronto: in   std_logic;
    recebe_dado: in std_logic;
    tem_dado_rec: out std_logic;
    habilita_registrador: out std_logic
  );
end unidade_controle_interface_recepcao;

architecture exemplo of unidade_controle_interface_recepcao is
type tipo_estado is (inicial, prepara, recebe, final, aguarda);
signal estado   : tipo_estado;

begin
    process (clock, estado, reset)
    begin

    if reset = '1' then
        estado <= inicial;

    elsif (clock'event and clock = '1') then
      case estado is
        when inicial =>                -- Aguarda sinal de inicio
          if recebe_dado = '1' then
            estado <= prepara;
          else
            estado <= inicial;
          end if;

        when prepara =>        -- Espera o final de uma recepção
          if pronto = '1' then
            estado <= recebe;
          else
            estado <= prepara;
          end if;

        when recebe =>        -- Habilita o registrador no fluxo de dados
          estado <= final;

        when final =>
          estado <= aguarda;

        when aguarda =>        -- Habilita saida para os displays
          if recebe_dado = '0' then
            estado <= inicial;
          else
            estado <= aguarda;
          end if;

        when others =>       -- Default
          estado <= inicial;
      end case;
    end if;
    end process;

    -- logica de saída
    with estado select
      tem_dado_rec <= '1' when final,
                      '0' when others;
    with estado select
      habilita_registrador <= '1' when recebe,
                              '0' when others;
end exemplo;
