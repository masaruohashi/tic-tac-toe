-- VHDL da Unidade de Controle da interface jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_interface_jogo is
  port(
    clock               : in std_logic;
    reset               : in std_logic;
    start               : in std_logic;
    jogador             : in std_logic;   -- indica se o jogador é o primeiro a jogar ou o segundo
    fim_impressao       : in std_logic;   -- indica que o tabuleiro terminou de ser impresso
    fim_recepcao        : in std_logic;   -- indica que um caractere terminou de ser recebido
    fim_transmissao     : in std_logic;   -- indica que um caractere terminou de ser eniado para a outra bancada
    liga_modem          : out std_logic;   -- indica que a interface do modem deve ser ligada
    imprime_tabuleiro   : out std_logic;  -- habilita a impressao do tabuleiro
    envia_jogada        : out std_logic;  -- habilita o envio da jogada para a outra bancada
    recebe_dado         : out std_logic;  -- habilita a recepção de um caractere do terminal
    jogador_atual       : out std_logic;  -- indica o jogador atual do jogo da velha
    dep_estados         : out std_logic_vector(2 downto 0)
  );
end unidade_controle_interface_jogo;

architecture comportamental of unidade_controle_interface_jogo is
type tipo_estado is (inicial, imprime_oponente, recebe_jogador, envia_caractere, imprime_jogador, recebe_oponente);
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
            if jogador='0' then
              estado <= imprime_oponente;
            else
              estado <= imprime_jogador;
            end if;
          else
            estado <= inicial;
          end if;

        when imprime_oponente =>                -- Imprime o tabuleiro no terminal
          if fim_impressao = '1' then
            estado <= recebe_jogador;
          else
            estado <= imprime_oponente;
          end if;

        when recebe_jogador =>        -- Espera o dado ser recebido do terminal
          if fim_recepcao = '1' then
            estado <= envia_caractere;
          else
            estado <= recebe_jogador;
          end if;

        when envia_caractere =>
          if fim_transmissao = '1' then
            estado <= imprime_jogador;
          else
            estado <= envia_caractere;
        end if;

        when imprime_jogador =>                -- Imprime o tabuleiro no terminal
          if fim_impressao = '1' then
            estado <= recebe_oponente;
          else
            estado <= imprime_jogador;
          end if;

        when recebe_oponente =>        -- Espera o dado ser recebido da outra bancada
          if fim_recepcao = '1' then
            estado <= imprime_oponente;
          else
            estado <= recebe_jogador;
          end if;

        when others =>       -- Default
          estado <= inicial;
      end case;
    end if;
    end process;

    -- logica de saída
    with estado select
      imprime_tabuleiro <= '1' when imprime_oponente | imprime_jogador,
                           '0' when others;

    with estado select
      recebe_dado <= '1' when recebe_jogador | recebe_oponente,
                     '0' when others;

    with estado select
      envia_jogada <= '1' when envia_caractere,
                      '0' when others;

    with estado select
      jogador_atual <= '1' when imprime_oponente | recebe_oponente,
                       '0' when others;

    with estado select
      liga_modem <= '1' when envia_caractere | recebe_oponente,
                    '0' when others;

    process (estado)
    begin
      case estado is
        when inicial =>
          dep_estados <= "000";
        when imprime_oponente =>
          dep_estados <= "010";
        when recebe_jogador =>
          dep_estados <= "011";
        when others =>
          null;
      end case;
    end process;
end comportamental;
