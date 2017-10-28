-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_interface_jogo is
  port(
    clock: in std_logic;
    reset: in std_logic;
    limpa: in std_logic;
    conta: in std_logic;
    leitura: in std_logic;
    escrita: in std_logic;
    recebe_dado: in std_logic;
    transmite_dado: in std_logic;
    entrada_serial: in std_logic;
    saida_serial: out std_logic;
    fim_tabuleiro: out std_logic;
    fim_recepcao: out std_logic;
    uart_livre: out std_logic;
    dep_endereco_leitura: out std_logic_vector(5 downto 0);
    dep_endereco_escrita: out std_logic_vector(5 downto 0)
  );
end fluxo_dados_interface_jogo;

architecture exemplo of fluxo_dados_interface_jogo is

  component contador_tabuleiro is
      port(
        clock     : in  std_logic;
        zera      : in  std_logic;
        conta     : in  std_logic;
        contagem  : out std_logic_vector(5 downto 0);
        fim       : out std_logic
      );
  end component;

  component memoria_caractere is
      port(
        clock: in std_logic;
        reset: in std_logic;
        leitura: in std_logic;
        escrita: in std_logic;
        entrada_dados: in std_logic_vector(6 downto 0);
        endereco_leitura: in std_logic_vector(5 downto 0);
        endereco_escrita: in std_logic_vector(5 downto 0);
        saida: out std_logic_vector(6 downto 0)
      );
  end component;

  component mapeador_caractere is
    port(
      caractere: in std_logic_vector(6 downto 0);
      posicao_memoria: out std_logic_vector(5 downto 0)
    );
  end component;

  component uart is
    port(
      clock: in std_logic;
      reset: in std_logic;
      entrada: in std_logic;
      recebe_dado: in std_logic;
      transmite_dado: in std_logic;
      dado_trans: in std_logic_vector(6 downto 0);
      saida: out std_logic;
      dado_rec: out std_logic_vector(6 downto 0);
      tem_dado_rec: out std_logic;
      transm_andamento: out std_logic;
      fim_transmissao: out std_logic;
      dep_tick_rx: out std_logic;
      dep_tick_tx: out std_logic;
      dep_estado_recepcao: out std_logic_vector(5 downto 0);
      dep_habilita_recepcao: out std_logic
    );
  end component;

  component registrador_jogada is
    port(
      clock: in std_logic;
      reset: in std_logic;
      guarda_jogada: in std_logic;
      entrada: in std_logic_vector(6 downto 0);
      dados: out std_logic_vector(8 downto 0)
    );
  end component;

signal s_limpa: std_logic;
signal s_endereco_leitura, s_endereco_escrita: std_logic_vector(5 downto 0);
signal s_entrada_caractere, s_saida_caractere: std_logic_vector(6 downto 0);
signal s_jogadas: std_logic_vector(8 downto 0);

begin
  contador: contador_tabuleiro port map (clock, s_limpa, conta, s_endereco_leitura, fim_tabuleiro);
  memoria: memoria_caractere port map (clock, reset, leitura, escrita, (others => '0'), s_endereco_leitura, s_endereco_escrita, s_saida_caractere);
  mapeador: mapeador_caractere port map (s_entrada_caractere, s_endereco_escrita);
  uart_1: uart port map (clock, reset, entrada_serial, recebe_dado, transmite_dado, s_saida_caractere, saida_serial, s_entrada_caractere, fim_recepcao, open, uart_livre, open, open, open, open);
  jogadas: registrador_jogada port map (clock, reset, escrita, s_entrada_caractere, s_jogadas);

  s_limpa <= reset or limpa;
  dep_endereco_leitura <= s_endereco_leitura;
  dep_endereco_escrita <= s_endereco_escrita;
end exemplo;
