-- unidade_controle_interface_transmissao.vhd
-- unidade de controle da interface para a transmissao serial
library IEEE;
use IEEE.std_logic_1164.all;

entity unidade_controle_interface_transmissao is
  port(
    clock: in STD_LOGIC;
    reset: in STD_LOGIC;
    transmite_dado: in STD_LOGIC;
    pronto: in STD_LOGIC;
    transmissao_andamento: out STD_LOGIC
  );
end;

architecture comportamental of unidade_controle_interface_transmissao is
type Tipo_estado is (inicial, transmite, final);  -- estados
signal Eatual,              -- estado atual
       Eprox: Tipo_estado;  -- proximo estado
begin

  process (clock, reset) -- memoria de estado
  begin
    if reset = '1' then
      Eatual <= inicial;
    elsif CLOCK'event and CLOCK = '1' then
      Eatual <= Eprox;
	end if;
  end process;

  process (transmite_dado, pronto, Eatual) -- logica de proximo estado
  begin
    case Eatual is
      when inicial =>
        if transmite_dado = '1' then
          Eprox <= transmite;
        else
          Eprox <= inicial;
        end if;
      when transmite =>
        if pronto='1' then
          Eprox <= final;
        else
          Eprox <= transmite;
        end if;
	   when final =>
	     if transmite_dado = '0' then
		    Eprox <= inicial;
	     else
		    Eprox <= final;
	  end if;
      when others =>
        Eprox <= inicial;
    end case;
  end process;

  with Eatual select  -- logica de saida (Moore)
    transmissao_andamento <=
      '0' when inicial,
      '1' when transmite,
		'0' when final;

end comportamental;
