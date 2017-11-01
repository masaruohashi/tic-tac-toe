-- VHDL do modulo verificador de jogada
library ieee;
use ieee.std_logic_1164.all;

entity valida_jogada is
  port(
    caractere             : in  std_logic_vector(6 downto 0);
    jogadas               : in  std_logic_vector(8 downto 0);
    jogada_ok             : out std_logic
  );
end valida_jogada;

architecture estrutural of valida_jogada is

  component valida_caractere is
    port(
      caractere             : in  std_logic_vector(6 downto 0);
      caractere_valido      : out std_logic
    );
  end component;

  component valida_posicao is
    port(
      posicao         : in  std_logic_vector(8 downto 0);
      caractere       : in  std_logic_vector(6 downto 0);
      posicao_valida  : out std_logic
    );
  end component;

signal s_caractere_valido, s_posicao_valida, s_fim_valida_caractere : std_logic;

begin
  valida_char : valida_caractere  port map (caractere, s_caractere_valido);
  valida_pos  : valida_posicao    port map (jogadas, caractere, s_posicao_valida);

  jogada_ok <= s_caractere_valido AND s_posicao_valida;

end estrutural;
