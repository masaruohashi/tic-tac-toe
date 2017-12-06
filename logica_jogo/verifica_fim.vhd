-- VHDL de um verificador de fim de jogo para o jogo da velha

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity verifica_fim is
    port(
      jogador_atual: in std_logic;                          -- jogador atual de acordo com a memoria do tabuleiro
      jogadas_realizadas: in std_logic_vector(8 downto 0);  -- vetor com as jogadas(1 ocupado, 0 aberto)
      jogador_responsavel: in std_logic_vector(8 downto 0); -- vetor com o jogador(1 jogador 1, 0 jogador 0)
      fim_jogo: out std_logic;                              -- indica o fim do jogo
      jogador_vencedor : out std_logic;                     -- indica o jogador vencedor
      empate : out std_logic                                -- indica se houve empate
    );
end verifica_fim;

architecture exemplo of verifica_fim is
signal sinal_fim: std_logic;
signal sinal_jogadas_jogador: std_logic_vector(8 downto 0);
signal sinal_jogador_vencedor, sinal_empate: std_logic;
begin
  process (jogador_atual)
  begin
    if jogador_atual='1' then
      sinal_jogadas_jogador <= jogadas_realizadas and jogador_responsavel;
    else
      sinal_jogadas_jogador <= jogadas_realizadas and (not jogador_responsavel);
    end if;
    sinal_fim <= ((sinal_jogadas_jogador(0) and sinal_jogadas_jogador(1) and sinal_jogadas_jogador(2)) or
                  (sinal_jogadas_jogador(3) and sinal_jogadas_jogador(4) and sinal_jogadas_jogador(5)) or
                  (sinal_jogadas_jogador(6) and sinal_jogadas_jogador(7) and sinal_jogadas_jogador(8)) or
                  (sinal_jogadas_jogador(0) and sinal_jogadas_jogador(3) and sinal_jogadas_jogador(6)) or
                  (sinal_jogadas_jogador(1) and sinal_jogadas_jogador(4) and sinal_jogadas_jogador(7)) or
                  (sinal_jogadas_jogador(2) and sinal_jogadas_jogador(5) and sinal_jogadas_jogador(8)) or
                  (sinal_jogadas_jogador(0) and sinal_jogadas_jogador(4) and sinal_jogadas_jogador(8)) or
                  (sinal_jogadas_jogador(6) and sinal_jogadas_jogador(4) and sinal_jogadas_jogador(2)));
    fim_jogo <= sinal_fim;
  end process;

  process (sinal_fim, jogadas_realizadas)
  begin
    if sinal_fim = '1' then
      sinal_jogador_vencedor <= jogador_atual;
    elsif(jogadas_realizadas(8)='1' and jogadas_realizadas(7)='1' and jogadas_realizadas(6)='1' and jogadas_realizadas(5)='1' and jogadas_realizadas(4)='1' and jogadas_realizadas(3)='1' and jogadas_realizadas(2)='1' and jogadas_realizadas(1)='1' and jogadas_realizadas(0)='1')then
      sinal_empate <= '1';
    end if;
    jogador_vencedor <= sinal_jogador_vencedor;
    empate <= sinal_empate;
  end process;
end exemplo;
