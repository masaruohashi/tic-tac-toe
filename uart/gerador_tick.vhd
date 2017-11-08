-- gerador_tick.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gerador_tick is
   generic(
      M: integer := 454545     -- para transmissao de 110 bauds
   );
   port(
      clock, reset: in std_logic;
      tick: out std_logic
   );
end gerador_tick;

architecture arch of gerador_tick is
   signal contagem, prox_contagem: integer;
begin
   process(clock,reset)
   begin
      if (reset='1') then
        contagem <= 0;
      elsif (clock'event and clock='1') then
        contagem <= prox_contagem;
      end if;
   end process;
   -- logica de proximo estado
   prox_contagem <= 0 when contagem=(M-1) else contagem + 1;
   -- logica de saida
   tick <= '1' when contagem=(M-1) else '0';
end arch;
