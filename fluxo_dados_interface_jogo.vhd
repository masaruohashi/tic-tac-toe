-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_interface_jogo is
  port(
    clock             : in  std_logic;
    reset             : in  std_logic;
    escreve_memoria   : in  std_logic;    -- habilita a escrita na memoria
    recebe_dado       : in  std_logic;    -- habilita a recepção de dados na uart
    imprime_tabuleiro : in  std_logic;    -- habilita o circuito de controle de impressao
    entrada_serial    : in  std_logic;    -- entrada de dados do terminal para a uart
    saida_serial      : out std_logic;    -- saida de dados da uart para o terminal
    fim_impressao     : out std_logic;    -- indica o fim da impressao do tabuleiro no terminal
    fim_recepcao      : out std_logic;    -- indica o fim da recepção de um caractere do terminal na uart
    fim_jogo          : out std_logic;    -- indica que o jogo acabou por vitoria ou empate
    jogada_ok         : out std_logic     -- indica que a jogada realizada é valida
  );
end fluxo_dados_interface_jogo;

architecture exemplo of fluxo_dados_interface_jogo is

  component controlador_impressao is
    port(
      clock                   : in std_logic;
      reset                   : in std_logic;
      comeca_impressao        : in std_logic;
      uart_livre              : in std_logic;
      posicao_leitura         : out std_logic_vector(5 downto 0);
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
      endereco_leitura  : in  std_logic_vector(5 downto 0);
      endereco_escrita  : in  std_logic_vector(5 downto 0);
      saida             : out std_logic_vector(6 downto 0);
      jogador           : out std_logic
    );
  end component;

  component mapeador_caractere is
    port(
      caractere       : in  std_logic_vector(6 downto 0);
      posicao_memoria : out std_logic_vector(5 downto 0)
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

signal s_endereco_leitura, s_endereco_escrita: std_logic_vector(5 downto 0);
signal s_entrada_caractere, s_saida_caractere: std_logic_vector(6 downto 0);
signal s_jogadas, s_jogador: std_logic_vector(8 downto 0);
signal s_posicao: std_logic_vector(3 downto 0);
signal s_jogador_atual: std_logic;
signal s_uart_livre: std_logic;
signal s_transmite_dado: std_logic;
signal s_leitura_memoria: std_logic;

begin

  controle_impressao: controlador_impressao port map (clock, reset, imprime_tabuleiro, s_uart_livre, s_endereco_leitura, s_leitura_memoria, s_transmite_dado, fim_impressao);
  memoria: memoria_caractere port map (clock, reset, s_leitura_memoria, escreve_memoria, s_endereco_leitura, s_endereco_escrita, s_saida_caractere, s_jogador_atual);
  mapeador_char: mapeador_caractere port map (s_entrada_caractere, s_endereco_escrita);
  uart_1: uart port map (clock, reset, entrada_serial, recebe_dado, s_transmite_dado, s_saida_caractere, saida_serial, s_entrada_caractere, fim_recepcao, open, s_uart_livre);
  mapeador_jogo: mapeador_jogada port map (s_entrada_caractere, s_posicao);
  jogada_valida: valida_jogada port map (s_entrada_caractere, s_jogadas, jogada_ok);
  jogadas: registrador_jogada port map (clock, reset, escreve_memoria, s_jogador_atual, s_posicao, s_jogadas, s_jogador);
  final_jogo: verifica_fim port map (s_jogador_atual, s_jogadas, s_jogador, fim_jogo);

end exemplo;
