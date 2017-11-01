-- VHDL do modulo verificador de jogada
library ieee;
use ieee.std_logic_1164.all;

entity valida_jogada is
  port(
    clock                 : in  std_logic;
    limpa                 : in  std_logic;
    verifica_jogada       : in  std_logic;
    caractere             : in  std_logic_vector(6 downto 0);
    jogadas               : in  std_logic_vector(8 downto 0);
    jogada_ok             : out std_logic;
    fim_validacao_jogada  : out std_logic
  );
end valida_jogada;

architecture estrutural of valida_jogada is

  component valida_caractere is
    port(
      verifica_jogada       : in  std_logic;
      limpa                 : in  std_logic;
      caractere             : in  std_logic_vector(6 downto 0);
      caractere_valido      : out std_logic;
      fim_valida_caractere  : out std_logic
    );
  end component;

  component valida_posicao is
    port(
      clock           : in  std_logic;
      verifica_jogada : in  std_logic;
      posicao         : in  std_logic_vector(8 downto 0);
      caractere       : in  std_logic_vector(6 downto 0);
      posicao_valida  : out std_logic
    );
  end component;

signal s_caractere_valido, s_posicao_valida, s_fim_valida_caractere : std_logic;

begin
  valida_char : valida_caractere  port map (verifica_jogada, limpa, caractere, s_caractere_valido, s_fim_valida_caractere);
  valida_pos  : valida_posicao    port map (clock, verifica_jogada, jogadas, caractere, s_posicao_valida);

  jogada_ok <= s_caractere_valido AND s_posicao_valida;
  fim_validacao_jogada <= s_fim_valida_caractere;

end estrutural;
