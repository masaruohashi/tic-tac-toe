-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity valida_posicao is
  port(
    clock           : in  std_logic;
    verifica_jogada : in  std_logic;
    posicao         : in  std_logic_vector(8 downto 0);
    caractere       : in  std_logic_vector(6 downto 0);
    posicao_valida  : out std_logic
  );
end valida_posicao;

architecture estrutural of valida_posicao is

  component mux is
    port(
      clock           : in  std_logic;
      verifica_jogada : in  std_logic;
      entrada         : in  std_logic_vector(8 downto 0);
      seletor         : in  std_logic_vector(6 downto 0);
      saida           : out std_logic
    );
  end component;

  signal s_caractere_valido, s_posicao_valida, s_saida : std_logic;

  begin
    mux1  : mux port map (clock, verifica_jogada, posicao, caractere, s_saida);

    posicao_valida <= NOT s_saida;

  end estrutural;
