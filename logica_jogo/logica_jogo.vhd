-- VHDL da logica do jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity logica_jogo is
  port(
    clock           : in std_logic;
    reset           : in std_logic;
    start           : in std_logic;
    fim_recepcao    : in std_logic;
    jogador_atual   : in std_logic;
    entrada_dado    : in std_logic_vector(6 downto 0);
    recebe_dado     : out std_logic;
    guarda_dado     : out std_logic;
    jogo_acabado    : out std_logic;
    jogador_vencedor: out std_logic;
    empate          : out std_logic;
    pronto          : out std_logic;
    estados         : out std_logic_vector(2 downto 0)
  );
end logica_jogo;

architecture estrutural of logica_jogo is

  component unidade_controle_logica_jogo is
    port(
      clock               : in std_logic;
      reset               : in std_logic;
      start               : in std_logic;
      fim_recepcao        : in std_logic;
      jogada_ok           : in std_logic;
      fim_jogo            : in std_logic;
      recebe_dado         : out std_logic;
      insere_dado         : out std_logic;
      jogo_acabado        : out std_logic;
      pronto              : out std_logic;
      estados             : out std_logic_vector(2 downto 0)
    );
  end component;

  component fluxo_dados_logica_jogo is
    port(
      clock               : in  std_logic;
      reset               : in  std_logic;
      jogador_atual       : in  std_logic;
      escreve_memoria     : in  std_logic;
      entrada_dado        : in  std_logic_vector(6 downto 0);
      fim_jogo            : out std_logic;
      jogada_ok           : out std_logic;
      jogador_vencedor    : out std_logic;
      empate              : out std_logic
    );
  end component;

  signal s_guarda_dado: std_logic;            -- relacionados a recepção do dado
  signal s_fim_jogo, s_jogada_ok: std_logic;  -- relacionados a validações/verificações

begin

  UC: unidade_controle_logica_jogo port map (clock, reset, start, fim_recepcao, s_jogada_ok, s_fim_jogo, recebe_dado, s_guarda_dado, jogo_acabado, pronto, estados);
  FD: fluxo_dados_logica_jogo port map(clock, reset, jogador_atual, s_guarda_dado, entrada_dado, s_fim_jogo, s_jogada_ok, jogador_vencedor, empate);

  guarda_dado <= s_guarda_dado;
end estrutural;
