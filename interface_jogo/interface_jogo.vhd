-- VHDL da interface de entrada e saida do jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity interface_jogo is
  port(
    clock                 : in std_logic;
    reset                 : in std_logic;
    start                 : in std_logic;
    jogador               : in std_logic;
    fim_recepcao          : in std_logic;
    recebe_dado           : in std_logic;
    guarda_dado           : in std_logic;
    entrada_serial        : in std_logic;
    fim_jogo              : in std_logic;
    jogador_vencedor      : in std_logic;
    empate                : in std_logic;
    CTS                   : in std_logic;
    CD                    : in std_logic;
    RD                    : in std_logic;
    DTR                   : out std_logic;
    RTS                   : out std_logic;
    TD                    : out std_logic;
    jogador_atual         : out std_logic;
    saida_serial          : out std_logic;
    habilita_logica       : out std_logic;
    habilita_verificacao  : out std_logic;
    dado_paralelo         : out std_logic_vector(6 downto 0);
    estados               : out std_logic_vector(2 downto 0)
  );
end interface_jogo;

architecture estrutural of interface_jogo is

  component unidade_controle_interface_jogo is
    port(
      clock               : in std_logic;
      reset               : in std_logic;
      start               : in std_logic;
      jogador             : in std_logic;   -- indica se o jogador é o primeiro a jogar ou o segundo
      fim_impressao       : in std_logic;   -- indica que o tabuleiro terminou de ser impresso
      fim_recepcao        : in std_logic;   -- indica que um caractere terminou de ser recebido
      fim_transmissao     : in std_logic;   -- indica que um caractere terminou de ser eniado para a outra bancada
      fim_jogo            : in std_logic;   -- indica que o jogo acabou
      liga_modem          : out std_logic;  -- indica que a interface do modem deve ser ligada
      imprime_tabuleiro   : out std_logic;  -- habilita a impressao do tabuleiro
      envia_jogada        : out std_logic;  -- habilita o envio da jogada para a outra bancada
      recebe_dado         : out std_logic;  -- habilita a recepção de um caractere do terminal
      jogador_atual       : out std_logic;  -- indica o jogador atual do jogo da velha
      dep_estados         : out std_logic_vector(2 downto 0)
    );
  end component;

  component fluxo_dados_interface_jogo is
    port(
      clock                   : in  std_logic;
      reset                   : in  std_logic;
      jogador_atual           : in  std_logic;                     -- indica o jogador atual do jogo da velha
      escreve_memoria         : in  std_logic;                     -- habilita a escrita na memoria
      recebe_dado_jogador     : in  std_logic;                     -- habilita a recepção de dados do jogador na uart
      imprime_tabuleiro       : in  std_logic;                     -- habilita o circuito de controle de impressao
      enable_fim              : in  std_logic;                     -- habilita a impressao das mensagens de fim de jogo
      jogador_vencedor        : in  std_logic;                     -- indica qual jogador venceu
      empate                  : in  std_logic;                     -- indica se houve empate
      liga_modem              : in  std_logic;                     -- liga a interface do modem para a comunicação com a outra bancada
      envia_dado              : in  std_logic;                     -- habilita o envio de dados para a outra bancada
      entrada_serial_jogador  : in  std_logic;                     -- entrada de dados do terminal para a uart
      CTS                     : in  std_logic;                     -- Clear to send
      CD                      : in  std_logic;                     -- Carrier Detect
      RD                      : in  std_logic;                     -- Received Data
      DTR                     : out std_logic;                     -- Data transfer Ready
      RTS                     : out std_logic;                     -- Request to send
      TD                      : out std_logic;                     -- Transmitted data
      saida_serial_tabuleiro  : out std_logic;                     -- saida de dados da uart para o terminal
      fim_impressao           : out std_logic;                     -- indica o fim da impressao do tabuleiro no terminal
      fim_transmissao         : out std_logic;                     -- indica o fim da tranmissao do dado para a outra bancada
      fim_recepcao_jogador    : out std_logic;                     -- indica o fim da recepção de um caractere do terminal na uart do jogador
      fim_recepcao_oponente   : out std_logic;                     -- indica o fim da recepção de um caractere do terminal na uart do oponente
      dado_paralelo           : out std_logic_vector(6 downto 0)   -- dados a serem verificados pela logica
    );
  end component;

  signal s_fim_impressao, s_imprime_tabuleiro: std_logic;
  signal s_jogador_atual: std_logic;
  signal s_fim_recepcao_jogador, s_fim_recepcao_oponente: std_logic;
  signal s_liga_modem, s_envia_jogada: std_logic;
  signal s_fim_transmissao: std_logic;

begin

  UC: unidade_controle_interface_jogo port map (clock, reset, start, jogador, s_fim_impressao, fim_recepcao, s_fim_transmissao, fim_jogo, s_liga_modem, s_imprime_tabuleiro, s_envia_jogada, habilita_logica, s_jogador_atual, estados);
  FD: fluxo_dados_interface_jogo port map(clock, reset, s_jogador_atual, guarda_dado, recebe_dado, s_imprime_tabuleiro, enable_fim, jogador_vencedor, empate, s_liga_modem, s_envia_jogada, entrada_serial, CTS, CD, RD, DTR, RTS, TD, saida_serial, s_fim_impressao, s_fim_transmissao, s_fim_recepcao_jogador, s_fim_recepcao_oponente, dado_paralelo);

  jogador_atual <= s_jogador_atual;
  habilita_verificacao <= s_fim_recepcao_jogador or s_fim_recepcao_oponente;

end estrutural;
