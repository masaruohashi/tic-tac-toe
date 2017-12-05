-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_interface_jogo is
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
    envia_dado              : in  std_logic;                     -- habilita o envio de dados para a outra bancada
    entrada_serial_jogador  : in  std_logic;                     -- entrada de dados do terminal para a uart
    entrada_serial_oponente : in  std_logic;                     -- entrada de dados da outra bancada
    saida_serial_oponente   : out std_logic;                     -- saida serial para a outra bancada
    saida_serial_tabuleiro  : out std_logic;                     -- saida de dados da uart para o terminal
    fim_impressao           : out std_logic;                     -- indica o fim da impressao do tabuleiro no terminal
    fim_recepcao_jogador    : out std_logic;                     -- indica o fim da recepção de um caractere do terminal na uart do jogador
    fim_recepcao_oponente   : out std_logic;                     -- indica o fim da recepção de um caractere do terminal na uart do oponente
    dado_paralelo           : out std_logic_vector(6 downto 0);  -- dados a serem verificados pela logica
    dep_recebe_dado_oponente: out std_logic
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

  component registrador_mensagem is
    port(
      clock            : in  std_logic;
      reset            : in  std_logic;
      enable           : in  std_logic;
      jogador_vencedor : in  std_logic;
      empate           : in  std_logic;
      saida            : out std_logic_vector(48 downto 0)
    );
  end component;

  component memoria_caractere is
    port(
      clock             : in std_logic;
      reset             : in std_logic;
      leitura           : in std_logic;
      escrita           : in std_logic;
      jogador           : in std_logic;
      enable_fim        : in std_logic;
      mensagem_fim      : in std_logic_vector(48 downto 0);
      endereco_leitura  : in std_logic_vector(6 downto 0);
      endereco_escrita  : in std_logic_vector(6 downto 0);
      saida             : out std_logic_vector(6 downto 0)
    );
  end component;

  component mapeador_caractere is
    port(
      caractere       : in  std_logic_vector(6 downto 0);
      posicao_memoria : out std_logic_vector(6 downto 0)
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

  component mapeador_entrada_caractere is
    port(
      jogador: in std_logic_vector(6 downto 0);
      oponente: in std_logic_vector(6 downto 0);
      jogador_atual: in std_logic;
      entrada_caractere: out std_logic_vector(6 downto 0)
    );
  end component;

  component mapeador_uart is
  port(
    jogador: in std_logic;
    uart_recebe_dado: in std_logic;
    uart_jogador: out std_logic;
    uart_oponente: out std_logic
  );
  end component;

  component controle_envio_jogada is
    port(
      clock               : in std_logic;
      reset               : in std_logic;
      enviar_jogada       : in std_logic;
      fim_envio           : in std_logic;
      reenviar_dado       : out std_logic
    );
  end component;

signal s_endereco_leitura, s_endereco_escrita: std_logic_vector(6 downto 0);
signal s_entrada_caractere, s_entrada_caractere_jogador, s_entrada_caractere_oponente, s_saida_caractere: std_logic_vector(6 downto 0);
signal s_jogador_atual: std_logic;
signal s_uart_livre: std_logic;
signal s_transmite_dado: std_logic;
signal s_leitura_memoria: std_logic;
signal s_entrada_serial_oponente: std_logic;
signal s_recebe_dado_oponente: std_logic;
signal s_envia_dado_oponente: std_logic;
signal s_saida_serial_jogada: std_logic;
signal s_mensagem_fim: std_logic_vector(48 downto 0);
signal s_jogador_recebe_dado, s_oponente_recebe_dado: std_logic;
signal s_fim_transmissao, s_reenviar_dado: std_logic;

begin

  -- Relacionados à impressão de caracteres
  controle_impressao: controlador_impressao port map (clock, reset, imprime_tabuleiro, s_uart_livre, s_endereco_leitura, s_leitura_memoria, s_transmite_dado, fim_impressao);
  mensagens: registrador_mensagem port map(clock, reset, enable_fim, jogador_vencedor, empate, s_mensagem_fim);
  memoria: memoria_caractere port map (clock, reset, s_leitura_memoria, escreve_memoria, jogador_atual, enable_fim, s_mensagem_fim, s_endereco_leitura, s_endereco_escrita, s_saida_caractere);

  -- Mapeadores
  mapeador_char: mapeador_caractere port map (s_entrada_caractere, s_endereco_escrita);
  mapeia_entrada_caractere: mapeador_entrada_caractere port map (s_entrada_caractere_jogador, s_entrada_caractere_oponente, jogador_atual, s_entrada_caractere);

  -- Entrada e saída de dados
  uart_jogador: uart port map (clock, reset, entrada_serial_jogador, s_jogador_recebe_dado, s_transmite_dado, s_saida_caractere, saida_serial_tabuleiro, s_entrada_caractere_jogador, fim_recepcao_jogador, open, s_uart_livre);
  uart_oponente: uart port map (clock, reset, entrada_serial_oponente, s_oponente_recebe_dado, s_reenviar_dado, s_entrada_caractere_jogador, saida_serial_oponente, s_entrada_caractere_oponente, fim_recepcao_oponente, open, s_fim_transmissao);
  mapeia_uart: mapeador_uart port map (jogador_atual, recebe_dado_jogador, s_jogador_recebe_dado, s_oponente_recebe_dado);
  controla_envio: controle_envio_jogada port map (clock, reset, envia_dado, s_fim_transmissao, s_reenviar_dado);

  dado_paralelo <= s_entrada_caractere;
  dep_recebe_dado_oponente <= s_recebe_dado_oponente;

end exemplo;
