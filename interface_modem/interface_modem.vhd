library ieee;
use ieee.std_logic_1164.all;

entity interface_modem is
  port(DadoSerial     : in  std_logic;
      Liga            : in  std_logic;
      Enviar          : in  std_logic;
      clock           : in  std_logic;
      reset           : in  std_logic;
      CTS             : in  std_logic;
      CD              : in  std_logic;
      RD              : in  std_logic;
      envioOK         : out std_logic;
      temDadoRecebido : out std_logic;
      DadoRecebido    : out std_logic;
      DTR             : out std_logic;
      RTS             : out std_logic;
      TD              : out std_logic);
end interface_modem;

architecture interface of interface_modem is 
  
  component interface_modem_transmissao is 
    port(Liga        : in  std_logic;
         Enviar      : in  std_logic;
         DadoSerial  : in  std_logic;
         CTS         : in  std_logic;
         clock       : in  std_logic;
         RESET       : in  std_logic;
         DTR         : out std_logic;
         RTS         : out std_logic;
         envioOK     : out std_logic;
         TD          : out  std_logic);
  end component;

  component interface_modem_recepcao is
    port(clock              : in   std_logic;
         Liga               : in   std_logic;
         RESET              : in   std_logic;
         CD                 : in   std_logic;
         RD                 : in   std_logic;
         temDadoRecebido    : out  std_logic;
         DadoRecebido       : out  std_logic;
         DTR                : out  std_logic);
  end component;

signal s1 : std_logic;
signal s2 : std_logic;  
  
begin 
  
  k1 : interface_modem_transmissao  port map (Liga, Enviar, DadoSerial, CTS, clock, RESET, s1, RTS, envioOK, TD);
  k2 : interface_modem_recepcao     port map (clock, Liga, RESET, CD, RD, temDadoRecebido, DadoRecebido, s2);

  DTR <= s1 or s2;
end interface;