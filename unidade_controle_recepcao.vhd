-- VHDL da Unidade de Controle

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_recepcao is
   port(clock    : in   std_logic;
        prepara  : in   std_logic;
        fim      : in   std_logic;
        reseta   : in   std_logic;
        saida    : out  std_logic_vector(5 downto 0));  -- limpa|carrega|zera|desloca|conta|pronto
end unidade_controle_recepcao;

architecture exemplo of unidade_controle_recepcao is
type tipo_estado is (inicial, preparacao, recebimento, final);
signal estado   : tipo_estado;

begin
    process (clock, estado, reseta)
    begin

    if reseta = '1' then
        estado <= inicial;

    elsif (clock'event and clock = '1') then
        case estado is
            when inicial =>                -- Aguarda de borda do sinal de clock
                if prepara = '1' then
                    estado <= inicial;
                else
                    estado <= preparacao;
                end if;

            when preparacao =>        -- Zera contador e latch
                estado <= recebimento;

            when recebimento =>        -- Desloca os bits no registrador lendo o dado serial
                if fim = '1' then
                    estado <= final;
                else
                    estado <= recebimento;
                end if;

            when final =>                 -- Fim da recepção serial
                estado <= inicial;

        end case;
    end if;
    end process;

    process (estado)
    begin
        case estado is  -- limpa|carrega|zera|desloca|conta|pronto
            when inicial =>
                saida <= "010001";
            when preparacao =>
                saida <= "001000";
            when recebimento =>
                saida <= "000110";
            when final =>
                saida <= "000001";
        end case;
   end process;
end exemplo;
