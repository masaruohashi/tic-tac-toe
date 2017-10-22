  -- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_transmissao is
  port(dados_ascii  : in  std_logic_vector(6 downto 0);
      enable     : in std_logic;
      carrega    : in  std_logic;
      desloca    : in  std_logic;
      zera      : in  std_logic;
      conta      : in  std_logic;
      clock      : in  std_logic;
      dado_serial  : out std_logic;
      saidaQ      : out std_logic_vector(11 downto 0);
      fim        : out std_logic);
end fluxo_dados_transmissao;

architecture exemplo of fluxo_dados_transmissao is

  component registrador_deslocamento_transmissao is
    port(clock      : in  std_logic;
        enable     : in std_logic;
        load       : in  std_logic;
        shift      : in  std_logic;
        RIN        : in  std_logic;
        entrada    : in  std_logic_vector(6 downto 0);
        bit_out    : out std_logic;
        saida      : out std_logic_vector(11 downto 0));
  end component;

  component contador_transmissao is
    port(clock     : in  std_logic;
        enable    : in std_logic;
        zera      : in  std_logic;
        conta     : in  std_logic;
        contagem  : out std_logic_vector(3 downto 0);
        fim       : out std_logic);
  end component;

signal s1 : std_logic_vector(11 downto 0);
signal s2 : std_logic;
signal s3 : std_logic_vector(3 downto 0);

begin
  g1 : registrador_deslocamento_transmissao port map (clock, enable, carrega, desloca, s2, dados_ascii, dado_serial, s1);
  g2 : contador_transmissao port map (clock, enable, zera, conta, s3, fim);

  saidaQ <= s1;
end exemplo;
