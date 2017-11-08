-- transmissao_serial
-- VHDL do circuito de tranmissao serial completo

library ieee;
use ieee.std_logic_1164.all;

entity transmissao_serial is
  port(
    clock: in std_logic;
    reset: in std_logic;
    transmite_dado: in std_logic;
    dados_trans: in std_logic_vector(6 downto 0);
    saida: out std_logic;
    transmissao_andamento: out std_logic;
    fim_transmissao: out std_logic;
    depuracao_tick: out std_logic
  );
end transmissao_serial;

architecture estrutural of transmissao_serial is

  component unidade_controle_interface_transmissao is
    port(
      clock: in std_logic;
      reset: in std_logic;
      transmite_dado: in std_logic;
      pronto: in std_logic;
      transmissao_andamento: out std_logic
    );
  end component;

  component circuito_transmissao is
    port(
      dados_ascii: in std_logic_vector(6 downto 0);
      tick_rx: in std_logic;
      partida: in std_logic;
      reset: in std_logic;
      clock: in std_logic;
      dado_serial: out std_logic;
      pronto: out std_logic
    );
  end component;

  component gerador_tick is
     generic(
        M: integer := 19200
     );
     port(
        clock, reset: in std_logic;
        tick: out std_logic
     );
  end component;

  signal sinal_pronto: std_logic;
  signal sinal_transmissao_andamento: std_logic;
  signal sinal_tick: std_logic;

begin

  uc_interface_transmissao: unidade_controle_interface_transmissao port map (clock, reset, transmite_dado, sinal_pronto, sinal_transmissao_andamento);
  transmissao: circuito_transmissao port map(dados_trans, sinal_tick, sinal_transmissao_andamento, reset, clock, saida, sinal_pronto);
  gera_tick: gerador_tick generic map (M => 454545) port map(clock, reset, sinal_tick);
  --para teste usar a linha abaixo de comentar a de cima
  --gera_tick: gerador_tick generic map (M => 16) port map(clock, reset, sinal_tick);

  depuracao_tick <= sinal_tick;
  transmissao_andamento <= sinal_transmissao_andamento;
  fim_transmissao <= sinal_pronto;

end estrutural;
