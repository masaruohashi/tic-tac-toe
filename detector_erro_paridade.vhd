-- VHDL de um circuito verificador de paridade.
-- Realiza a verficacao da paridade dos dados recebidos.
-- Eh zerado durante o estado de preparacao.

library ieee;
use ieee.std_logic_1164.all;

entity detector_erro_paridade is
  port(
    entrada       : in  std_logic_vector(11 downto 0);
    clock         : in  std_logic;
    enable        : in  std_logic;
    reset         : in  std_logic;
    paridade_ok   : out std_logic
  );
end detector_erro_paridade;

architecture comportamental of detector_erro_paridade is
begin

  process (clock, entrada, enable, reset)
    begin

    if clock'event and clock = '1' then
      if reset = '1' then
        paridade_ok <= '0';
      elsif enable = '1' then
      -- faz a verificacao da paridade do dado ASCII recebido
      -- se for 1, a paridade esta correta,
      -- se for 0, houve ruido na transmissao e o dado eh invalido.
        paridade_ok <=  (entrada(8) xor entrada(7) xor entrada(6) xor
                          entrada(5) xor entrada(4) xor entrada(3) xor
                          entrada(2)) xnor entrada(9);
      end if;
    end if;
  end process;

end comportamental;
