-- uart.vhd
-- VHDL do circuito da UART

library ieee;
use ieee.std_logic_1164.all;

entity uart is
  port(
    clock: in std_logic;
    reset: in std_logic;
    entrada: in std_logic;
    recebe_dado: in std_logic;
    transmite_dado: in std_logic;
    dado_trans: in std_logic_vector(6 downto 0);
    saida: out std_logic;
    dado_rec: out std_logic_vector(6 downto 0);
    tem_dado_rec: out std_logic;
    transm_andamento: out std_logic;
    fim_transmissao: out std_logic
  );
end uart;

architecture estrutural of uart is

  component transmissao_serial is
    port(
      clock: in std_logic;
      reset: in std_logic;
      transmite_dado: in std_logic;
      dados_trans: in std_logic_vector(6 downto 0);
      saida: out std_logic;
      fim_transmissao: out std_logic;
      transmissao_andamento: out std_logic;
      depuracao_tick: out std_logic
    );
  end component;

  component recepcao_serial is
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
  end component;

  signal sinal_dado_rec: std_logic_vector(11 downto 0);

begin

  transmissao: transmissao_serial port map (clock, reset, transmite_dado, dado_trans, saida, fim_transmissao, transm_andamento, open);
  recepcao: recepcao_serial port map(clock, reset, entrada, recebe_dado, sinal_dado_rec, tem_dado_rec, open, open, open, open);

  dado_rec <= sinal_dado_rec(8 downto 2);
  --display_1: hex7seg_en port map(sinal_dado_rec(5), sinal_dado_rec(4), sinal_dado_rec(3), sinal_dado_rec(2), '1', dado_rec(0), dado_rec(1), dado_rec(2), dado_rec(3), dado_rec(4), dado_rec(5), dado_rec(6));
  --display_2: hex7seg_en port map('0', sinal_dado_rec(8), sinal_dado_rec(7), sinal_dado_rec(6), '1', dado_rec(7), dado_rec(8), dado_rec(9), dado_rec(10), dado_rec(11), dado_rec(12), dado_rec(13));

end estrutural;
