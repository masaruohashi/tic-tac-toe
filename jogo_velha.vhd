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
    fim: out std_logic;
    dep_estados: out std_logic_vector(2 downto 0)
  );
end jogo_velha;

architecture estrutural of jogo_velha is

  component unidade_controle_interface_jogo is
    port(
      clock               : in std_logic;
      reset               : in std_logic;
      start               : in std_logic;
      fim_impressao       : in std_logic;
      fim_recepcao        : in std_logic;
      jogada_ok           : in std_logic;
      fim_jogo            : in std_logic;
      imprime_tabuleiro   : out std_logic;
      recebe_dado         : out std_logic;
      insere_dado         : out std_logic;
      jogo_acabado        : out std_logic;
      dep_estados         : out std_logic_vector(2 downto 0)
    );
  end component;

  component fluxo_dados_interface_jogo is
    port(
      clock             : in  std_logic;
      reset             : in  std_logic;
      escreve_memoria   : in  std_logic;
      recebe_dado       : in  std_logic;
      imprime_tabuleiro : in  std_logic;
      entrada_serial    : in  std_logic;
      saida_serial      : out std_logic;
      fim_impressao     : out std_logic;
      fim_recepcao      : out std_logic;
      fim_jogo          : out std_logic;
      jogada_ok         : out std_logic
    );
  end component;

  signal s_fim_impressao, s_imprime_tabuleiro: std_logic;         -- relacionados a impressão do tabuleiro
  signal s_fim_recepcao, s_recebe_dado, s_insere_dado: std_logic; -- relacionados a recepção do dado
  signal s_fim_jogo, s_jogada_ok: std_logic;                      -- relacionados a validações/verificações

begin

    unidade_controle : unidade_controle_interface_jogo port map (clock, reset, start, s_fim_impressao, s_fim_recepcao, s_jogada_ok, s_fim_jogo, s_imprime_tabuleiro, s_recebe_dado, s_insere_dado, fim, dep_estados);
    fluxo_dados: fluxo_dados_interface_jogo port map(clock, reset, s_insere_dado, s_recebe_dado, s_imprime_tabuleiro, entrada_serial, saida_serial, s_fim_impressao, s_fim_recepcao, s_fim_jogo, s_jogada_ok);

end estrutural;
