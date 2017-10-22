-- VHDL do interface recepcao

library ieee;
use ieee.std_logic_1164.all;

entity interface_recepcao is
  port(
    clock: in  std_logic;
    reset: in std_logic;
    pronto: in std_logic;
    paridade_ok: in std_logic;
    recebe_dado: in std_logic;
    dado_entrada: in  std_logic_vector(11 downto 0);
    tem_dado_rec: out std_logic;
    dado_rec: out std_logic_vector(11 downto 0)
  );
end interface_recepcao;

architecture estrutural of interface_recepcao is

  component unidade_controle_interface_recepcao is
     port(
      clock: in   std_logic;
      reset: in   std_logic;
      pronto: in   std_logic;
      recebe_dado: in std_logic;
      tem_dado_rec: out std_logic;
      habilita_registrador: out std_logic
    );
  end component;

  component fluxo_dados_interface_recepcao is
    port(
      clock: in  std_logic;
      enable: in  std_logic;
      entrada: in  std_logic_vector(11 downto 0);
      saida: out std_logic_vector(11 downto 0)
    );
  end component;

  signal sinal_habilita_registrador: std_logic;

begin

  unidade_controle: unidade_controle_interface_recepcao port map (clock, reset, pronto, recebe_dado, tem_dado_rec, sinal_habilita_registrador);
  fluxo_dados: fluxo_dados_interface_recepcao port map(clock, sinal_habilita_registrador, dado_entrada, dado_rec);

end estrutural;
