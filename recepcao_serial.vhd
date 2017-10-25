-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity recepcao_serial is
  port(
    clock: in  std_logic;
    reset: in  std_logic;
    entrada: in  std_logic;
    recebe_dado: in std_logic;
    dado_rec: out std_logic_vector(11 downto 0);
    tem_dado_rec: out std_logic;
    dep_paridade_ok: out std_logic;
    dep_tick_rx: out std_logic;
    dep_estados: out std_logic_vector(5 downto 0);
    dep_habilita_recepcao: out std_logic
  );
end recepcao_serial;

architecture estrutural of recepcao_serial is

  component circuito_recepcao is
    port(
      dado_serial   : in  std_logic;
      reset         : in  std_logic;
      clock         : in  std_logic;
      tick          : in  std_logic;
      dados_ascii   : out std_logic_vector(11 downto 0);
      saidas_estado : out std_logic_vector(5 downto 0);
      pronto        : out std_logic;
      paridade_ok   : out std_logic;
      dep_habilita_recepcao : out std_logic
    );
  end component;

  component interface_recepcao is
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
  end component;

  component gerador_tick is
     generic(
        M: integer := 454545     -- para transmissao de 110 bauds
     );
     port(
        clock, reset: in std_logic;
        tick: out std_logic
     );
  end component;

  signal sinal_tick: std_logic;
  signal sinal_dados_ascii: std_logic_vector(11 downto 0);
  signal sinal_pronto: std_logic;
  signal sinal_paridade_ok: std_logic;

begin

    circuito : circuito_recepcao port map (entrada, reset, clock, sinal_tick, sinal_dados_ascii, dep_estados, sinal_pronto, sinal_paridade_ok, dep_habilita_recepcao);
    gera_tick: gerador_tick generic map (M => 2) port map(clock, reset, sinal_tick);
    interface: interface_recepcao port map (clock, reset, sinal_pronto, sinal_paridade_ok, recebe_dado, sinal_dados_ascii, tem_dado_rec, dado_rec);

    dep_paridade_ok <= sinal_paridade_ok;
    dep_tick_rx <= sinal_tick;

end estrutural;
