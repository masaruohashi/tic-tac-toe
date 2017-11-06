-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_interface_jogo is
  port(
    clock                   : in  std_logic;
    reset                   : in  std_logic;
    jogador                 : in  std_logic;    -- sinaliza o jogador atual
    transmite_dado_jogada   : in  std_logic;    -- habilita a transmissão da jogada para a outra bancada
    escreve_memoria         : in  std_logic;    -- habilita a escrita na memoria
    recebe_dado_jogador     : in  std_logic;    -- habilita a recepção de dados do terminal
    recebe_dado_oponente    : in  std_logic;    -- habilita a recepção de dados da outra bancada
    imprime_tabuleiro       : in  std_logic;    -- habilita o circuito de controle de impressao
    entrada_serial          : in  std_logic;    -- entrada de dados do terminal para a uart
    liga_modem              : in  std_logic;    -- habilita o modem para a troca de dados
    CTS                     : in  std_logic;    -- Clear to Send
    CD                      : in  std_logic;    -- Carrier Detect
    RD                      : in  std_logic;    -- Received Data
    DTR                     : out std_logic;    -- Data Transfer Ready
    RTS                     : out std_logic;    -- Request to Send
    TD                      : out std_logic;    -- Transmitted Data
    saida_serial            : out std_logic;    -- saida de dados da uart para o terminal
    fim_impressao           : out std_logic;    -- indica o fim da impressao do tabuleiro no terminal
    fim_recepcao_jogador    : out std_logic;    -- indica o fim da recepção de um caractere do terminal na uart
    fim_recepcao_oponente   : out std_logic;    -- indica o fim da recepção de um caractere da outra bancada na uart
    fim_jogo                : out std_logic;    -- indica que o jogo acabou por vitoria ou empate
    jogada_ok               : out std_logic     -- indica que a jogada realizada é valida
  );
end fluxo_dados_interface_jogo;

architecture exemplo of fluxo_dados_interface_jogo is

  component controlador_impressao is
    port(
      clock                   : in std_logic;
      reset                   : in std_logic;
      comeca_impressao        : in std_logic;
      uart_livre              : in std_logic;
      posicao_leitura         : out std_logic_vector(6 downto 0);
      leitura_memoria         : out std_logic;
      transmite_dado          : out std_logic;
      pronto                  : out std_logic
    );
  end component;

  component memoria_caractere is
    port(
      clock             : in  std_logic;
      reset             : in  std_logic;
      leitura           : in  std_logic;
      escrita           : in  std_logic;
      endereco_leitura  : in  std_logic_vector(6 downto 0);
      endereco_escrita  : in  std_logic_vector(6 downto 0);
      saida             : out std_logic_vector(6 downto 0);
      jogador           : out std_logic
    );
  end component;

  component mapeador_caractere is
    port(
      caractere       : in  std_logic_vector(6 downto 0);
      posicao_memoria : out std_logic_vector(6 downto 0)
    );
  end component;

  component mapeador_jogada is
    port(
      caractere : in  std_logic_vector(6 downto 0);
      jogada    : out std_logic_vector(3 downto 0)
    );
  end component;

  component uart is
    port(
      clock                 : in  std_logic;
      reset                 : in  std_logic;
      entrada               : in  std_logic;
      recebe_dado           : in  std_logic;
      transmite_dado        : in  std_logic;
      dado_trans            : in  std_logic_vector(6 downto 0);
      saida                 : out std_logic;
      dado_rec              : out std_logic_vector(6 downto 0);
      tem_dado_rec          : out std_logic;
      transm_andamento      : out std_logic;
      fim_transmissao       : out std_logic
    );
  end component;

  component valida_jogada is
    port(
      caractere             : in  std_logic_vector(6 downto 0);
      jogadas               : in  std_logic_vector(8 downto 0);
      jogada_ok             : out std_logic
    );
  end component;

  component registrador_jogada is
    port(
      clock               : in  std_logic;
      reset               : in  std_logic;
      guarda_jogada       : in  std_logic;
      jogador             : in  std_logic;
      entrada             : in  std_logic_vector(3 downto 0);
      jogadas_realizadas  : out std_logic_vector(8 downto 0);
      jogadas_jogador     : out std_logic_vector(8 downto 0)
    );
  end component;

  component verifica_fim is
    port(
      jogador_atual: in std_logic;
      jogadas_realizadas: in std_logic_vector(8 downto 0);
      jogador_responsavel: in std_logic_vector(8 downto 0);
      fim_jogo: out std_logic
    );
  end component;

  component mapeador_jogador is
  port(
    jogador             : in std_logic;
    caractere_jogador   : in std_logic_vector(6 downto 0);
    caractere_oponente  : in std_logic_vector(6 downto 0);
    caractere_saida     : out std_logic_vector(6 downto 0)
  );
  end component;

  component interface_modem is
    port(
      clock              : in std_logic;
      reset              : in std_logic;
      liga               : in std_logic;
      enviar             : in std_logic;
      dadoSerial         : in std_logic;
      CTS                : in std_logic;
      CD                 : in std_logic;
      RD                 : in std_logic;
      DTR                : out std_logic;
      RTS                : out std_logic;
      TD                 : out std_logic;
      envioOk            : out std_logic;
      temDadoRecebido    : out std_logic;
      dadoRecebido       : out std_logic
    );
  end component;

signal s_endereco_leitura, s_endereco_escrita: std_logic_vector(6 downto 0);
signal s_entrada_caractere, s_entrada_caractere_jogador, s_entrada_caractere_oponente, s_saida_caractere: std_logic_vector(6 downto 0);
signal s_jogadas, s_jogador: std_logic_vector(8 downto 0);
signal s_posicao: std_logic_vector(3 downto 0);
signal s_jogador_atual: std_logic;
signal s_uart_livre: std_logic;
signal s_transmite_dado_tabuleiro, s_transmite_dado_jogada: std_logic;
signal s_leitura_memoria: std_logic;
signal s_saida_uart_modem: std_logic;
signal s_entrada_serial_oponente: std_logic;

begin
  -- Jogadas e memória do tabuleiro
  jogadas: registrador_jogada port map (clock, reset, escreve_memoria, s_jogador_atual, s_posicao, s_jogadas, s_jogador);
  memoria: memoria_caractere port map (clock, reset, s_leitura_memoria, escreve_memoria, s_endereco_leitura, s_endereco_escrita, s_saida_caractere, s_jogador_atual);
  controle_impressao: controlador_impressao port map (clock, reset, imprime_tabuleiro, s_uart_livre, s_endereco_leitura, s_leitura_memoria, s_transmite_dado_tabuleiro, fim_impressao);

  -- Mapeadores
  mapeador_char: mapeador_caractere port map (s_entrada_caractere, s_endereco_escrita);
  mapeador_jogo: mapeador_jogada port map (s_entrada_caractere, s_posicao);
  mapeador_controle_jogo: mapeador_jogador port map (jogador, s_entrada_caractere_jogador, s_entrada_caractere_oponente, s_entrada_caractere);

  -- Transmissão e recepção de dados
  modem_uart: interface_modem port map (clock, reset, liga_modem, liga_modem, s_saida_uart_modem, CTS, CD, RD, DTR, RTS, TD, open, open, s_entrada_serial_oponente);
  uart_jogador: uart port map (clock, reset, entrada_serial, recebe_dado_jogador, s_transmite_dado_tabuleiro, s_saida_caractere, saida_serial, s_entrada_caractere_jogador, fim_recepcao_jogador, open, s_uart_livre);
  uart_oponente: uart port map (clock, reset, s_entrada_serial_oponente, recebe_dado_oponente, transmite_dado_jogada, s_entrada_caractere_jogador, s_saida_uart_modem, s_entrada_caractere_oponente, fim_recepcao_oponente, open, open);

  -- Validação de dados e verificação de fim
  jogada_valida: valida_jogada port map (s_entrada_caractere, s_jogadas, jogada_ok);
  final_jogo: verifica_fim port map (s_jogador_atual, s_jogadas, s_jogador, fim_jogo);

end exemplo;
