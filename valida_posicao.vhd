-- VHDL do modulo verificador da posicao da jogada.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

  signal trinta_um  : std_logic_vector(5 downto 0) := "110001";

  begin
    posicao_valida <= NOT posicao(to_integer(unsigned(caractere) - unsigned(trinta_um(5 downto 0))));

  end estrutural;
