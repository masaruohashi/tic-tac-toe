-- VHDL do Jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity jogo_velha is
  port(
    clock                       : in std_logic;
    reset                       : in std_logic;
    start                       : in std_logic;
    entrada_serial_jogador      : in std_logic;
    entrada_serial_oponente     : in std_logic;
    jogador                     : in std_logic;
    saida_serial_tabuleiro        : out std_logic;
    saida_serial_oponente       : out std_logic;
    jogo_acabado                : out std_logic;
    dep_estados_logica          : out std_logic_vector(2 downto 0);
    dep_estados_interface       : out std_logic_vector(2 downto 0);
    dep_recebe_dado_oponente: out std_logic
  );
end jogo_velha;

architecture estrutural of jogo_velha is

  component interface_jogo is
    port(
      clock                   : in std_logic;
      reset                   : in std_logic;
      start                   : in std_logic;
      jogador                 : in std_logic;
      fim_recepcao            : in std_logic;
      recebe_dado             : in std_logic;
      guarda_dado             : in std_logic;
      entrada_serial_jogador  : in std_logic;
      entrada_serial_oponente : in std_logic;
      fim_jogo                : in std_logic;
      jogador_vencedor        : in std_logic;
      empate                  : in std_logic;
      jogador_atual           : out std_logic;
      saida_serial_tabuleiro  : out std_logic;
      saida_serial_oponente   : out std_logic;
      habilita_logica         : out std_logic;
      habilita_verificacao    : out std_logic;
      dado_paralelo           : out std_logic_vector(6 downto 0);
      estados                 : out std_logic_vector(2 downto 0);
      dep_recebe_dado_oponente: out std_logic
    );
  end component;

  component logica_jogo is
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
  end component;

  signal s_fim_recepcao, s_recebe_dado, s_guarda_dado: std_logic;
  signal s_habilita_logica, s_habilita_verificacao: std_logic;
  signal s_jogador_atual: std_logic;
  signal s_jogo_acabado, s_jogador_vencedor, s_empate : std_logic;
  signal s_dado_paralelo: std_logic_vector(6 downto 0);

begin

  logica: logica_jogo port map(clock, reset, s_habilita_logica, s_habilita_verificacao, s_jogador_atual, s_dado_paralelo, s_recebe_dado, s_guarda_dado, s_jogo_acabado, s_jogador_vencedor, s_empate, s_fim_recepcao, dep_estados_logica);
  interface : interface_jogo port map (clock, reset, start, jogador, s_fim_recepcao, s_recebe_dado, s_guarda_dado, entrada_serial_jogador, entrada_serial_oponente, s_jogo_acabado, s_jogador_vencedor, s_empate, s_jogador_atual, saida_serial_tabuleiro, saida_serial_oponente, s_habilita_logica, s_habilita_verificacao, s_dado_paralelo, dep_estados_interface, dep_recebe_dado_oponente);

  jogo_acabado <= s_jogo_acabado;
end estrutural;
