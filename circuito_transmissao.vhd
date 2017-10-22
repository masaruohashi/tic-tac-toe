-- VHDL do circuito de transmissao

library ieee;
use ieee.std_logic_1164.all;

entity circuito_transmissao is
  port(
    dados_ascii: in std_logic_vector(6 downto 0);
    tick_rx: in std_logic;
    partida: in std_logic;
    reset: in std_logic;
    clock: in std_logic;
    dado_serial: out std_logic;
    pronto: out std_logic
  );
end circuito_transmissao;

architecture exemplo of circuito_transmissao is

  component fluxo_dados_transmissao is
    port(
      dados_ascii: in std_logic_vector(6 downto 0);
      enable: in std_logic;
      carrega: in std_logic;
      desloca: in std_logic;
      zera: in std_logic;
      conta: in std_logic;
      clock: in std_logic;
      dado_serial: out std_logic;
      saidaQ: out std_logic_vector(11 downto 0);
      fim: out std_logic
    );
  end component;

  component unidade_controle_transmissao is
    port(
      clock: in std_logic;
      comeca: in std_logic;
      fim: in std_logic;
      reseta: in std_logic;
      saida: out std_logic_vector(4 downto 0));  -- carrega|zera|desloca|conta|pronto
  end component;

signal f1: std_logic;
signal f2: std_logic_vector(4 downto 0);
signal f3: std_logic_vector(11 downto 0);

begin

  k1 : unidade_controle_transmissao port map (clock, partida, f1, reset, f2);
  k2 : fluxo_dados_transmissao port map (dados_ascii, tick_rx, f2(4), f2(2), f2(3), f2(1), clock, dado_serial, f3, f1);

  pronto <= f2(0);

end exemplo;
