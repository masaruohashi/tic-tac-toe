-- VHDL da interface de entrada e saida do jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity interface_jogo is
  port(
    clock                 : in std_logic;
    reset                 : in std_logic;
    start                 : in std_logic;
    fim_recepcao          : in std_logic;
    recebe_dado           : in std_logic;
    guarda_dado           : in std_logic;
    entrada_serial        : in std_logic;
    enable_fim            : in std_logic;
    jogador_vencedor      : in std_logic;
    empate                : in std_logic;
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
      fim_impressao       : in std_logic;
      fim_recepcao        : in std_logic;
      imprime_tabuleiro   : out std_logic;
      recebe_dado         : out std_logic;
      jogador_atual       : out std_logic;
      dep_estados         : out std_logic_vector(2 downto 0)
    );
  end component;

  component fluxo_dados_interface_jogo is
    port(
      clock             : in  std_logic;
      reset             : in  std_logic;
      jogador_atual     : in  std_logic;
      escreve_memoria   : in  std_logic;
      recebe_dado       : in  std_logic;
      imprime_tabuleiro : in  std_logic;
      entrada_serial    : in  std_logic;
      enable_fim        : in  std_logic;
      jogador_vencedor  : in  std_logic;
      empate            : in  std_logic;
      saida_serial      : out std_logic;
      fim_impressao     : out std_logic;
      fim_recepcao      : out std_logic;
      dado_paralelo     : out std_logic_vector(6 downto 0)
    );
  end component;

  signal s_fim_impressao, s_imprime_tabuleiro: std_logic;
  signal s_jogador_atual: std_logic;

begin

  UC: unidade_controle_interface_jogo port map (clock, reset, start, s_fim_impressao, fim_recepcao, s_imprime_tabuleiro, habilita_logica, s_jogador_atual, estados);
  FD: fluxo_dados_interface_jogo port map(clock, reset, s_jogador_atual, guarda_dado, recebe_dado, s_imprime_tabuleiro, entrada_serial, enable_fim, jogador_vencedor, empate, saida_serial, s_fim_impressao, habilita_verificacao, dado_paralelo);

  jogador_atual <= s_jogador_atual;

end estrutural;
