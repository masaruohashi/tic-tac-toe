-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_recepcao is
  port(
    dado_serial   : in  std_logic;
    desloca       : in  std_logic;
    zera          : in  std_logic;
    limpa         : in  std_logic;
    carrega       : in  std_logic;
    final         : in  std_logic;
    conta         : in  std_logic;
    clock         : in  std_logic;
    enable        : in  std_logic;
    dados_ascii   : out std_logic_vector(11 downto 0);
    fim           : out std_logic;
    paridade_ok   : out std_logic;
    s_contagemdep : out std_logic_vector(2 downto 0)
  );
end fluxo_dados_recepcao;

architecture exemplo of fluxo_dados_recepcao is

  component registrador_deslocamento_recepcao is
    port(
      clock       : in  std_logic;
      enable      : in  std_logic;
      shift       : in  std_logic;
      RIN         : in  std_logic;
      saida       : out std_logic_vector(11 downto 0)
    );
  end component;

  component contador_16_recepcao is
    port(
      clock     : in  std_logic;
      enable    : in  std_logic;
      zera      : in  std_logic;
      conta     : in  std_logic;
      contagem  : out std_logic_vector(3 downto 0);
      fim       : out std_logic
    );
  end component;

  component detector_erro_paridade is
    port(
      entrada       : in  std_logic_vector(11 downto 0);
      clock         : in  std_logic;
      enable        : in  std_logic;
      reset         : in  std_logic;
      paridade_ok : out std_logic
    );
  end component;

  component hex7seg_en is
    port (
      x3, x2, x1, x0 : in std_logic;
      enable         : in std_logic;
      a,b,c,d,e,f,g  : out std_logic
    );
  end component;

signal s_fim: std_logic;
signal s_saida_ascii: std_logic_vector(11 downto 0);
signal s_contagem: std_logic_vector(2 downto 0);
signal s_limpa: std_logic;

begin

  REGI_1    : registrador_deslocamento_recepcao port map (clock, enable, desloca, dado_serial, s_saida_ascii);
  CONT16_1  : contador_16_recepcao port map (clock, enable, s_limpa, conta, open, s_fim);
  ERRPAR_1  : detector_erro_paridade port map (s_saida_ascii, clock, final, zera, paridade_ok);

  fim <= s_fim;
  s_limpa <= limpa or zera;
  s_contagemdep <= s_contagem;
  dados_ascii <= s_saida_ascii;
end exemplo;
