-- VHDL do Jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity jogo_velha is
  port(
    clock: in std_logic;
    reset: in std_logic;
    entrada_serial: in std_logic;
    start: in std_logic;
    saida_serial: out std_logic;
    dep_estados: out std_logic_vector(2 downto 0);
    dep_fim_recepcao: out std_logic
  );
end jogo_velha;

architecture estrutural of jogo_velha is
  component unidade_controle_interface_jogo is
     port(
      clock: in std_logic;
      reset: in std_logic;
      start: in std_logic;
      fim_impressao: in std_logic;
      fim_recepcao: in std_logic;
      fim_validacao_jogada: in std_logic;
      fim_validacao_tabuleiro: in std_logic;
      jogada_ok: in std_logic;
      fim_jogo: in std_logic;
      uart_livre: in std_logic;
      imprime_tabuleiro: out std_logic;
      atualiza_caractere: out std_logic;
      recebe_dado: out std_logic;
      limpa_contador: out std_logic;
      insere_dado: out std_logic;
      verifica_jogada: out std_logic;
      verifica_tabuleiro: out std_logic;
      dep_estados: out std_logic_vector(2 downto 0)
    );
  end component;

  component fluxo_dados_interface_jogo is
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
      verificar_fim: in std_logic;
      saida_serial: out std_logic;
      fim_tabuleiro: out std_logic;
      fim_recepcao: out std_logic;
      uart_livre: out std_logic;
      fim_validacao_tabuleiro: out std_logic;
      fim_jogo: out std_logic;
      dep_endereco_leitura: out std_logic_vector(5 downto 0);
      dep_endereco_escrita: out std_logic_vector(5 downto 0)
    );
  end component;

  signal s_fim_impressao, s_uart_livre, s_imprime_tabuleiro, s_atualiza_caractere, s_limpa_contador: std_logic;
  signal s_fim_recepcao, s_recebe_dado, s_insere_dado: std_logic;
  signal s_verifica_tabuleiro, s_fim_validacao_tabuleiro, s_fim_jogo: std_logic;
begin

    unidade_controle : unidade_controle_interface_jogo port map (clock, reset, start, s_fim_impressao, s_fim_recepcao, '1', s_fim_validacao_tabuleiro, '1', s_fim_jogo, s_uart_livre, s_imprime_tabuleiro, s_atualiza_caractere, s_recebe_dado, s_limpa_contador, s_insere_dado, open, s_verifica_tabuleiro, dep_estados);
    fluxo_dados: fluxo_dados_interface_jogo port map(clock, reset, s_limpa_contador, s_atualiza_caractere, s_atualiza_caractere, s_insere_dado, s_recebe_dado, s_imprime_tabuleiro, entrada_serial, s_verifica_tabuleiro, saida_serial, s_fim_impressao, s_fim_recepcao, s_uart_livre, open, open);

    dep_fim_recepcao <= s_fim_recepcao;

end estrutural;
