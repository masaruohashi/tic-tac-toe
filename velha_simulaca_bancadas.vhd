-- VHDL do jogo da velha utilizando o modem virtual para simulacao.

library ieee;
use ieee.std_logic_1164.all;

entity velha_simula_bancadas is
  port(
    clock             : in  std_logic;
    reset             : in  std_logic;
    start             : in  std_logic;
    entrada_serial_1  : in  std_logic;
    entrada_serial_2  : in  std_logic;
    jogador_1         : in  std_logic;
    jogador_2         : in  std_logic;
    saida_serial_1    : out std_logic;
    saida_serial_2    : out std_logic;
    jogo_acabado_1    : out std_logic;
	  jogo_acabado_2    : out std_logic
  );
end velha_simula_bancadas;

architecture estrutural of velha_simula_bancadas is

  component jogo_velha is
    port(
      clock                 : in std_logic;
      reset                 : in std_logic;
      start                 : in std_logic;
      entrada_serial        : in std_logic;
      jogador               : in std_logic;
      CTS                   : in std_logic;
      CD                    : in std_logic;
      RD                    : in std_logic;
      DTR                   : out std_logic;
      RTS                   : out std_logic;
      TD                    : out std_logic;
      saida_serial          : out std_logic;
      jogo_acabado          : out std_logic
    );
  end component;

  component modem is
  	port ( clock, reset, DTR: in STD_LOGIC;
             -- transmissao
             RTS:               in STD_LOGIC;
             CTS:               out STD_LOGIC;
             TD:                in STD_LOGIC;
             TC:                out STD_LOGIC;
             -- recepcao
             RC:                in STD_LOGIC;
             CD, RD:            out STD_LOGIC);
  end component;

signal s_DTR_1, s_RTS_1, s_CTS_1, s_TD_1, s_CD_1, s_RD_1 : std_Logic;
signal s_DTR_2, s_RTS_2, s_CTS_2, s_TD_2, s_CD_2, s_RD_2 : std_Logic;
signal s_TC, s_RC : std_Logic;

begin

  jogador1 : jogo_velha port map (clock, reset, start, entrada_serial_1, jogador_1, s_CTS_1, s_CD_1, s_RD_1, s_DTR_1, s_RTS_1, s_TD_1, saida_serial_1, jogo_acabado_1);
  modem1   : modem      port map (clock, reset, s_DTR_1, s_RTS_1, s_CTS_1, s_TD_1, s_TC, s_RC, s_CD_1, s_RD_1);
  jogador2 : jogo_velha port map (clock, reset, start, entrada_serial_2, jogador_2, s_CTS_2, s_CD_2, s_RD_2, s_DTR_2, s_RTS_2, s_TD_2, saida_serial_2, jogo_acabado_2);
  modem2   : modem      port map (clock, reset, s_DTR_2, s_RTS_2, s_CTS_2, s_TD_2, s_RC, s_TC, s_CD_2, s_RD_2);

end estrutural;
