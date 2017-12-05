library ieee;
use ieee.std_logic_1164.all;

entity interface_modem_recepcao is
      port(clock              : in   std_logic;
           Liga               : in   std_logic;
           RESET              : in   std_logic;
           CD                 : in   std_logic;
           RD                 : in   std_logic;
           temDadoRecebido    : out  std_logic;
           DadoRecebido       : out  std_logic;
           DTR                : out  std_logic);
end interface_modem_recepcao;

architecture interface of interface_modem_recepcao is
type tipo_estado is (inicio, aguarda, recebe, fim);
signal estado   : tipo_estado;
   
begin
      process (clock, estado, RESET)
      begin
   
      if RESET = '1' then
            estado <= inicio;
      elsif Liga = '0' then
            estado <= inicio;
      elsif (clock'event and clock = '1') then
            case estado is
                  when inicio =>                  -- Aguarda sinal Liga
                        if Liga = '1' then
                              estado <= aguarda;
                        end if;

                  when aguarda =>        -- Aguarda sinal CD (ativo baixo)
                        if CD = '0' then
                              estado <= recebe;
                        else
                              estado <= aguarda;
                        end if;
                  when recebe =>            -- Recepcao
                        if CD = '1' then
                              estado <= fim;
                        else
                              estado <= recebe;
                        end if;      
                  when fim =>                         -- Fim de recepcao
                        estado <= inicio;
            end case;
      end if;
      end process;
   
      process (estado)
      begin
            case estado is
                  when inicio =>
                        DTR <= '1';
                        temDadoRecebido <= '0';
                  when aguarda =>
                        DTR <= '0';
                        temDadoRecebido <= '0';
                  when recebe =>
                        DTR <= '0';
                        temDadoRecebido <= '1';
                  when fim =>
                        DTR <= '0';
                        temDadoRecebido <= '0';
            end case;
   end process;
      
      DadoRecebido <= RD;
end interface;