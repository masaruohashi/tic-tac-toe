-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity interface_modem is
  port(
    clock              : in std_logic;
    reset              : in std_logic;
    liga               : in std_logic;    -- liga o circuito
    enviar             : in std_logic;    -- sinal para habilitar o envio
    dadoSerial         : in std_logic;    -- saida serial para os dados a serem enviados pelo modem
    CTS                : in std_logic;    -- Clear To Send(0)
    CD                 : in std_logic;    -- Carrier Detect(0)
    RD                 : in std_logic;    -- Received Data(1)
    DTR                : out std_logic;   -- Data Terminal Ready(0)
    RTS                : out std_logic;   -- Request To Send(0)
    TD                 : out std_logic;   -- Transmitted Data(1)
    envioOk            : out std_logic;   -- Informa que os dados estão sendo enviados
    temDadoRecebido    : out std_logic;   -- Informa que os dados estão sendo recebidos
    dadoRecebido       : out std_logic    -- entrada serial para os dados recebidos
  );
end interface_modem;

architecture interface of interface_modem is

  component unidade_controle_modem_recepcao is
    port(clock           : in   std_logic;
         reset           : in   std_logic;
         liga            : in   std_logic;
         CD              : in   std_logic;
         RD              : in   std_logic;
         DTR             : out  std_logic;
         temDadoRecebido : out  std_logic;
         saida           : out  std_logic_vector(3 downto 0));  -- controle de estados
  end component;

  component unidade_controle_modem_transmissao is
    port(clock      : in   std_logic;
         reset      : in   std_logic;
         liga       : in   std_logic;
         enviar     : in   std_logic;
         CTS        : in   std_logic;
         DTR        : out  std_logic;
         RTS        : out  std_logic;
         envioOk    : out  std_logic;
         saida      : out  std_logic_vector(3 downto 0));  -- controle de estados
  end component;

  component fluxo_dados_modem_transmissao is
    port(enableTransmissao: in  std_logic;
         dadoSerial       : in  std_logic;
         TD               : out std_logic);
  end component;

  component fluxo_dados_modem_recepcao is
    port(enableRecepcao : in std_Logic;
         RD             : in std_logic;
         dadoRecebido   : out std_logic);
  end component;

signal estadoRecepcao : std_logic_vector(3 downto 0);
signal estadoTransmissao : std_logic_vector(3 downto 0);
signal DTRRecepcao : std_logic;
signal DTRTransmissao : std_logic;
signal enableTransmissao : std_logic;
signal enableRecepcao : std_logic;

begin

  uc_recepcao : unidade_controle_modem_recepcao port map (clock, reset, liga, CD, RD, DTRRecepcao, enableRecepcao, estadoRecepcao);
  uc_transmissao : unidade_controle_modem_transmissao port map (clock, reset, liga, enviar, CTS, DTRTransmissao, RTS, enableTransmissao, estadoTransmissao);

  fd_recepcao    : fluxo_dados_modem_recepcao port map (enableRecepcao, RD, dadoRecebido);
  fd_transmissao : fluxo_dados_modem_transmissao port map (enableTransmissao, dadoSerial, TD);

  DTR <= DTRRecepcao and DTRTransmissao;
  envioOk <= enableTransmissao;
  temDadoRecebido <= enableRecepcao;

end interface;