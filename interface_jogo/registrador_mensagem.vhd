library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_mensagem is
  port(
    clock            : in  std_logic;
    reset            : in  std_logic;
    enable           : in  std_logic;
    jogador_vencedor : in  std_logic;
    empate           : in  std_logic;
    saida            : out std_logic_vector(48 downto 0)
  );
end registrador_mensagem;

architecture comportamental of registrador_mensagem is
signal s_vitoria: std_logic_vector(48 downto 0) := "1010110110100111101001101111111001011010011100001"; -- mensagem "vitoria"
signal s_derrota: std_logic_vector(48 downto 0) := "1000100110010111100101110010110111111101001100001"; -- mensagem "derrota"
signal s_empate : std_logic_vector(48 downto 0) := "1000101110110111100001100001111010011001010100000"; -- mensagem "empate "
begin
  process(clock, reset, empate, jogador_vencedor)
  begin
    if reset='1' then
      saida <= "0100000010000001000000100000010000001000000100000";   -- saida recebe 7 caracteres 'espaco'
    elsif clock'event and clock='1' then
      if enable='1' then
        if empate='1' then
          saida <= s_empate;              -- saida recebe a palavra 'empate' + 1 caractere 'espaco'
        elsif jogador_vencedor='0' then
          saida <= s_vitoria;             -- saida recebe a palavra 'vitoria'
        else
          saida <= s_derrota;             -- saida recebe a palavra 'derrota'
        end if;
      end if;
    end if;
  end process;
end comportamental;
