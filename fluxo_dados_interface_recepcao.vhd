-- VHDL do Fluxo de Dados interface recepcao

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_interface_recepcao is
  port(
    clock: in  std_logic;
    enable: in  std_logic;
    entrada: in  std_logic_vector(11 downto 0);
    saida: out std_logic_vector(11 downto 0)
  );
end fluxo_dados_interface_recepcao;

architecture exemplo of fluxo_dados_interface_recepcao is

  component registrador_dado_recebido is
    port(
      clock: in  std_logic;
      enable: in  std_logic;
      clear: in std_logic;
      entrada: in  std_logic_vector(11 downto 0);
      saida: out std_logic_vector(11 downto 0)
    );
  end component;

begin

  registrador_saida: registrador_dado_recebido port map (clock, enable, '0', entrada, saida);

end exemplo;
