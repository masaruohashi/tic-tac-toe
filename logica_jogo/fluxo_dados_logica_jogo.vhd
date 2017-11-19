-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_logica_jogo is
  port(
    clock               : in  std_logic;
    reset               : in  std_logic;
    jogador_atual       : in  std_logic;                    -- indica o jogador atual do jogo da velha
    escreve_memoria     : in  std_logic;                    -- habilita a escrita na memoria
    entrada_dado        : in  std_logic_vector(6 downto 0); -- entrada de dados para a validacao
    fim_jogo            : out std_logic;                    -- indica que o jogo acabou por vitoria ou empate
    jogada_ok           : out std_logic;                    -- indica que a jogada realizada é valida
    jogador_vencedor    : out std_logic;
    empate              : out std_logic
  );
end fluxo_dados_logica_jogo;

architecture exemplo of fluxo_dados_logica_jogo is

  component mapeador_jogada is
    port(
      caractere : in  std_logic_vector(6 downto 0);
      jogada    : out std_logic_vector(3 downto 0)
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
      fim_jogo: out std_logic;
      jogador_vencedor : out std_logic;
      empate : out std_logic
    );
  end component;

signal s_jogadas, s_jogador: std_logic_vector(8 downto 0);
signal s_posicao: std_logic_vector(3 downto 0);
signal s_jogador_atual: std_logic;

begin

  mapeador_jogo: mapeador_jogada port map (entrada_dado, s_posicao);
  jogadas: registrador_jogada port map (clock, reset, escreve_memoria, s_jogador_atual, s_posicao, s_jogadas, s_jogador);
  jogada_valida: valida_jogada port map (entrada_dado, s_jogadas, jogada_ok);
  final_jogo: verifica_fim port map (s_jogador_atual, s_jogadas, s_jogador, fim_jogo, jogador_vencedor, empate);

  s_jogador_atual <= jogador_atual;

end exemplo;
