-- circuito_superamostragem.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circuito_superamostragem is
   generic(
      M: integer := 16     -- para transmissao de 110 bauds com gerador de tick 16 * 110 Hz
   );
   port(
      clock, reset: in std_logic;
      tick: in std_logic;
      load: in std_logic;
      habilita_circuito: out std_logic
   );
end circuito_superamostragem;

architecture arch of circuito_superamostragem is
   signal contagem, prox_contagem: integer;
   signal prox_enable: std_logic;
begin
   process(clock,reset)
   begin
      if (reset='1') then
        contagem <= 0;
      elsif (clock'event and clock='1') then
        if tick = '1' then
          if load = '1' then
            contagem <= (M / 2);
          else
            contagem <= prox_contagem;
          end if;
        end if;
        if prox_enable = '0' then
          if((contagem = (M-1)) and (tick = '1')) then
            prox_enable <= '1';
          end if;
        else
          prox_enable <= '0';
        end if;
      end if;
   end process;
   -- logica de proximo estado
   prox_contagem <= 0 when contagem=(M-1) else contagem + 1;
   -- logica de saida
   habilita_circuito <= prox_enable;
end arch;
