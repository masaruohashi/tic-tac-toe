-- VHDL de um verificador de fim de jogo para o jogo da velha

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity verifica_fim is
    port(
      clock: in std_logic;
      enable: in std_logic;
      jogador_atual: in std_logic;
      jogadas: in std_logic_vector(8 downto 0);
      jogador: in std_logic_vector(8 downto 0);
      fim_jogo: out std_logic;
      fim_validacao: out std_logic
    );
end verifica_fim;

architecture exemplo of verifica_fim is
signal sinal_fim, sinal_fim_validacao: std_logic;
signal sinal_jogadas_jogador: std_logic_vector(8 downto 0);
begin
  process (clock, enable, jogador_atual)
  begin

  if clock'event and clock = '1' then
    if enable = '1' then
      if jogador_atual='0' then
        sinal_jogadas_jogador <= jogadas and jogador;
      else
        sinal_jogadas_jogador <= jogadas and (not jogador);
      end if;
      sinal_fim <= ((sinal_jogadas_jogador(0) and sinal_jogadas_jogador(1) and sinal_jogadas_jogador(2)) or
                    (sinal_jogadas_jogador(3) and sinal_jogadas_jogador(4) and sinal_jogadas_jogador(5)) or
                    (sinal_jogadas_jogador(6) and sinal_jogadas_jogador(7) and sinal_jogadas_jogador(8)) or
                    (sinal_jogadas_jogador(0) and sinal_jogadas_jogador(3) and sinal_jogadas_jogador(6)) or
                    (sinal_jogadas_jogador(1) and sinal_jogadas_jogador(4) and sinal_jogadas_jogador(7)) or
                    (sinal_jogadas_jogador(2) and sinal_jogadas_jogador(5) and sinal_jogadas_jogador(8)) or
                    (sinal_jogadas_jogador(0) and sinal_jogadas_jogador(4) and sinal_jogadas_jogador(8)) or
                    (sinal_jogadas_jogador(6) and sinal_jogadas_jogador(4) and sinal_jogadas_jogador(2)));
      sinal_fim_validacao <= '1';
    else
      sinal_fim_validacao <= '0';
    end if;
  end if;
  fim_jogo <= sinal_fim;
  end process;
end exemplo;
