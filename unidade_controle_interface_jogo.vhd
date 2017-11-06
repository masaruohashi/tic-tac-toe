-- VHDL da Unidade de Controle da interface jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_interface_jogo is
  port(
    clock                 : in std_logic;
    reset                 : in std_logic;
    start                 : in std_logic;
    CTS                   : in std_logic;   -- Clear to Send
    CD                    : in std_logic;   -- Carrier Detect
    primeiro              : in std_logic;   -- indica se o é o primeiro a jogar
    fim_impressao         : in std_logic;   -- indica que o tabuleiro terminou de ser impresso
    fim_recepcao_jogador  : in std_logic;   -- indica que um caractere terminou de ser recebido do terminal
    fim_recepcao_oponente : in std_logic;   -- indica que um caractere terminou de ser recebido da outra bancada
    jogada_ok             : in std_logic;   -- indica que o caractere recebido é valido
    fim_jogo              : in std_logic;   -- indica que o jogo acabou
    jogador               : out std_logic;  -- indica o jogador atual
    liga_modem            : out std_logic;  -- habilita a interface do modem
    imprime_tabuleiro     : out std_logic;  -- habilita a impressao do tabuleiro
    envia_dados_jogador   : out std_logic;  -- habilita o envio da jogada para a outra bancada
    recebe_dado_jogador   : out std_logic;  -- habilita a recepção de um caractere do terminal
    recebe_dado_oponente  : out std_logic;  -- habilita a recepção de um caractere da outra bancada
    insere_dado           : out std_logic;  -- habilita a inserção da jogada na memoria
    jogo_acabado          : out std_logic;  -- indica que o jogo acabou
    dep_estados           : out std_logic_vector(3 downto 0)
  );
end unidade_controle_interface_jogo;

architecture comportamental of unidade_controle_interface_jogo is
type tipo_estado is (
  inicial, prepara, imprime_oponente, recebe_jogador, valida_jogada, guarda_jogador,
  envia_jogada, imprime_jogador, recebe_oponente, guarda_oponente, valida_tabuleiro, final
);
signal estado   : tipo_estado;

begin
    process (clock, estado, reset)
    begin

    if reset = '1' then
        estado <= inicial;

    elsif (clock'event and clock = '1') then
      case estado is
        when inicial =>                -- Aguarda sinal de start
          if start = '0' then
            estado <= inicial;
          else
            estado <= prepara;
          end if;

        when prepara =>                 -- Aguarda configuração do modem
          if(CTS='0' and CD='0') then
            if primeiro = '1' then
              estado <= imprime_oponente;
            else
              estado <= imprime_jogador;
            end if;
          else
            estado <= prepara;
          end if;

        when imprime_oponente =>                -- Imprime o tabuleiro no terminal
          if fim_impressao = '1' then
            estado <= recebe_jogador;
          else
            estado <= imprime_oponente;
          end if;

        when recebe_jogador =>        -- Espera o dado ser recebido
          if fim_recepcao_jogador = '1' then
            estado <= valida_jogada;
          else
            estado <= recebe_jogador;
          end if;

        when valida_jogada =>         -- Valida o caractere enviado do terminal
          if jogada_ok = '0' then
            estado <= recebe_jogador;
          else
            estado <= guarda_jogador;
          end if;

        when guarda_jogador =>        -- Guarda o dado no tabuleiro
          estado <= imprime_jogador;

        when envia_jogada =>            -- Envia a jogada para a outra bancada
          estado <= imprime_jogador;

        when imprime_jogador =>      -- Imprime o tabuleiro no terminal
          if fim_impressao = '1' then
            estado <= recebe_oponente;
          else
            estado <= imprime_jogador;
          end if;

        when recebe_oponente =>         -- Recebe a jogada da outra bancada
          if fim_recepcao_oponente = '1' then
            estado <= guarda_oponente;
          else
            estado <= recebe_oponente;
          end if;

        when guarda_oponente =>         -- Guarda a jogada da outra bancada
          estado <= valida_tabuleiro;

        when valida_tabuleiro =>        -- Verifica se o jogo acabou
          if fim_jogo = '1' then
            estado <= final;
          else
            estado <= imprime_oponente;
          end if;

        when final =>                   -- Final do jogo
          estado <= final;

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
      recebe_dado_jogador <= '1' when recebe_jogador,
                             '0' when others;

    with estado select
      recebe_dado_oponente <= '1' when recebe_oponente,
                              '0' when others;

    with estado select
      envia_dados_jogador <= '1' when envia_jogada,
                             '0' when others;

    with estado select
      insere_dado <= '1' when guarda_jogador | guarda_oponente,
                     '0' when others;

    with estado select
      jogo_acabado <= '1' when final,
                      '0' when others;

    with estado select
      liga_modem <= '0' when inicial | final,
                    '1' when others;

    with estado select
      jogador <= '0' when inicial | prepara | imprime_oponente | recebe_jogador | valida_jogada | guarda_jogador,
                 '1' when others;

    process (estado)
    begin
      case estado is
        when inicial =>
          dep_estados <= "0000";
        when prepara =>
          dep_estados <= "1111";
        when imprime_oponente =>
          dep_estados <= "0001";
        when recebe_jogador =>
          dep_estados <= "0010";
        when valida_jogada =>
          dep_estados <= "0011";
        when guarda_jogador =>
          dep_estados <= "0100";
        when imprime_jogador =>
          dep_estados <= "0101";
        when envia_jogada =>
          dep_estados <= "0110";
        when recebe_oponente =>
          dep_estados <= "0111";
        when guarda_oponente =>
          dep_estados <= "1000";
        when valida_tabuleiro =>
          dep_estados <= "1001";
        when final =>
          dep_estados <= "1010";
        when others =>
          null;
      end case;
    end process;
end comportamental;
