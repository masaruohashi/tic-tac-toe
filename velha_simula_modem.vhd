-- VHDL do Jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity velha_simula_modem is
  port(
    clock                 : in std_logic;
    reset                 : in std_logic;
    start                 : in std_logic;
    entrada_serial_1      : in std_logic;
    entrada_serial_2      : in std_logic;
    jogador_1             : in std_logic;
    jogador_2             : in std_logic;
    saida_serial_1        : out std_logic;
    saida_serial_2        : out std_logic;
    jogo_acabado_1        : out std_logic;
    jogo_acabado_2        : out std_logic
  );
end velha_simula_modem;

architecture estrutural of velha_simula_modem is

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
      jogo_acabado          : out std_logic;
      dep_estados_logica    : out std_logic_vector(2 downto 0);
      dep_estados_interface : out std_logic_vector(2 downto 0);
      dep_recebe_dado_oponente: out std_logic
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

  signal CTS_1, CD_1, RD_1, DTR_1, RTS_1, TD_1, RC_1: std_logic;
  signal CTS_2, CD_2, RD_2, DTR_2, RTS_2, TD_2, RC_2: std_logic;

begin

  velha_1: jogo_velha port map (clock, reset, start, entrada_serial_1, jogador_1, CTS_1, CD_1, RD_1, DTR_1, RTS_1, TD_1, saida_serial_1, jogo_acabado_1, open, open);
  modem_1: modem port map (clock, reset, DTR_1, RTS_1, CTS_1, TD_1, RC_2, RC_1, CD_1, RD_1);

  velha_2: jogo_velha port map (clock, reset, start, entrada_serial_2, jogador_2, CTS_2, CD_2, RD_2, DTR_2, RTS_2, TD_2, saida_serial_2, jogo_acabado_2, open, open);
  modem_2: modem port map (clock, reset, DTR_2, RTS_2, CTS_2, TD_2, RC_1, RC_2, CD_2, RD_2);

end estrutural;
