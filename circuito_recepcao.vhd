-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity circuito_recepcao is
  port(
    dado_serial   : in  std_logic;
    reset         : in  std_logic;
    clock         : in  std_logic;
    tick          : in  std_logic;
    dados_ascii   : out std_logic_vector(11 downto 0);    -- Depuracao
    saidas_estado : out std_logic_vector(5 downto 0);    -- Depuracao
    pronto        : out std_logic;
    paridade_ok   : out std_logic;
    dep_habilita_recepcao: out std_logic
  );
end circuito_recepcao;

architecture exemplo of circuito_recepcao is

  component fluxo_dados_recepcao is
    port(
      dado_serial   : in  std_logic;
      desloca       : in  std_logic;
      zera          : in  std_logic;
      limpa         : in  std_logic;
      carrega       : in  std_logic;
      final         : in  std_logic;
      conta         : in  std_logic;
      clock         : in  std_logic;
      enable        : in  std_logic;
      dados_ascii   : out std_logic_vector(11 downto 0);
      fim           : out std_logic;
      paridade_ok : out std_logic;
      s_contagemdep : out std_logic_vector(2 downto 0)
    );
  end component;

  component unidade_controle_recepcao is
    port(
      clock    : in   std_logic;
      prepara  : in   std_logic;
      fim      : in   std_logic;
      reseta   : in   std_logic;
      pronto   : out  std_logic;
      saida    : out  std_logic_vector(5 downto 0)
    );  -- limpa|carrega|zera|desloca|conta|pronto
  end component;

  component contador_8_recepcao is
    port(
      clock       : in  std_logic;
      load        : in  std_logic;
      zera        : in  std_logic;
      conta       : in  std_logic;
      contagem    : out std_logic_vector(2 downto 0);
      cout   : out std_logic
    );
  end component;

  component circuito_superamostragem is
     generic(
        M: integer := 16
     );
     port(
        clock, reset: in std_logic;
        tick: in std_logic;
        load: in std_logic;
        habilita_circuito: out std_logic
     );
  end component;

signal s_fim: std_logic;
signal s_habilita_circuito: std_logic;
signal f2: std_logic_vector(5 downto 0);     --sinais internos de controle: carrega, zera, desloca, conta, final
signal s_contagem: std_logic_vector(2 downto 0);

begin

    unidade_controle: unidade_controle_recepcao port map(clock, dado_serial, s_fim, reset, pronto, f2);
    fluxo_dados: fluxo_dados_recepcao port map(dado_serial, f2(2), f2(3), f2(5), f2(4), f2(0), f2(1), clock, s_habilita_circuito, dados_ascii, s_fim, paridade_ok, s_contagem);

    -- circuito de superamostragem para a recepção
    superamostragem: circuito_superamostragem generic map(M => 16) port map(clock, reset, tick, f2(4), s_habilita_circuito);

    saidas_estado     <= f2;
    dep_habilita_recepcao <= s_habilita_circuito;

end exemplo;
