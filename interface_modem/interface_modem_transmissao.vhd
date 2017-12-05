library ieee;
use ieee.std_logic_1164.all;

entity interface_modem_transmissao is
    port(Liga           : in  std_logic;
          Enviar         : in  std_logic;
          DadoSerial    : in  std_logic;
          CTS             : in  std_logic;
          clock            : in  std_logic;
          RESET        : in  std_logic;
          DTR                : out std_logic;
          RTS          : out std_logic;
          envioOK      : out std_logic;
          TD           : out  std_logic);
end interface_modem_transmissao;

architecture interface of interface_modem_transmissao is
type tipo_estado is (inicio, aguarda, prepara, transmite, fim);
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
            when inicio =>            -- Aguarda sinal Liga
                if Liga = '1' then
                    estado <= aguarda;
                end if;

            when aguarda =>        -- Aguarda sinal Enviar
                if Enviar = '1' then
                    estado <= prepara;
                else
                    estado <= aguarda;
                end if;
            when prepara =>        -- Aguarda sinal CTS (ativo baixo)
                if CTS = '0' then
                    estado <= transmite;
                else
                    estado <= prepara;
                end if;
               
            when transmite =>        -- Transmissao
                if Enviar = '0' then
                    estado <= fim;
                else
                    estado <= transmite;
                end if;
                              
            when fim =>                 -- Fim de transmissao
                estado <= inicio;
        end case;
    end if;
    end process;
   
    process (estado)
    begin
        case estado is
            when inicio =>
                DTR <= '1';
                RTS <= '1';
                envioOK <= '0';
           when aguarda =>
                DTR <= '0';
                RTS <= '1';
                envioOK <= '0';
            when prepara =>
                DTR <= '0';
                RTS <= '0';
                envioOK <= '0';
            when transmite =>
                DTR <= '0';
                RTS <= '0';
                envioOK <= '1';
            when fim =>
                DTR <= '0';
                RTS <= '1';
                envioOK <= '0';
        end case;
   end process;
    
    TD <= DadoSerial;
end interface;