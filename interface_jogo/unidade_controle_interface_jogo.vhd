-- VHDL da Unidade de Controle da interface jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_interface_jogo is
  port(
    clock               : in std_logic;
    reset               : in std_logic;
    start               : in std_logic;
    fim_impressao       : in std_logic;   -- indica que o tabuleiro terminou de ser impresso
    fim_recepcao        : in std_logic;   -- indica que um caractere terminou de ser recebido
    imprime_tabuleiro   : out std_logic;  -- habilita a impressao do tabuleiro
    recebe_dado         : out std_logic;  -- habilita a recepção de um caractere do terminal
    jogador_atual       : out std_logic;  -- indica o jogador atual do jogo da velha
    dep_estados         : out std_logic_vector(2 downto 0)
  );
end unidade_controle_interface_jogo;

architecture comportamental of unidade_controle_interface_jogo is
type tipo_estado is (inicial, imprime, recebe, valida_jogada, guarda, valida_tabuleiro, final);
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
            estado <= imprime;
          else
            estado <= inicial;
          end if;

        when imprime =>                -- Imprime o tabuleiro no terminal
          if fim_impressao = '1' then
            estado <= recebe;
          else
            estado <= imprime;
          end if;

        when recebe =>        -- Espera o dado ser recebido
          if fim_recepcao = '1' then
            estado <= imprime;
          else
            estado <= recebe;
          end if;

        when others =>       -- Default
          estado <= inicial;
      end case;
    end if;
    end process;

    -- logica de saída
    with estado select
      imprime_tabuleiro <= '1' when imprime,
                           '0' when others;

    with estado select
      recebe_dado <= '1' when recebe,
                     '0' when others;

    with estado select
      jogador_atual <= '0' when recebe | guarda,
                       '1' when others;

    process (estado)
    begin
      case estado is
        when inicial =>
          dep_estados <= "000";
        when imprime =>
          dep_estados <= "010";
        when recebe =>
          dep_estados <= "011";
        when final =>
          dep_estados <= "111";
        when others =>
          null;
      end case;
    end process;
end comportamental;
