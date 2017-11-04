  -- VHDL de uma memoria do jogo da velha
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_caractere is
    port(
      clock: in std_logic;
      reset: in std_logic;
      leitura: in std_logic;
      escrita: in std_logic;
      endereco_leitura: in std_logic_vector(5 downto 0);
      endereco_escrita: in std_logic_vector(5 downto 0);
      saida: out std_logic_vector(6 downto 0);
      jogador: out std_logic
    );
end memoria_caractere;

architecture estrutural of memoria_caractere is
  signal sinal_jogador: std_logic := '0';
  type memoria is array (0 to 59) of std_logic_vector(6 downto 0);
  constant c_enter: std_logic_vector(6 downto 0) := "0001101";
  constant c_espaco: std_logic_vector(6 downto 0) := "0100000";
  constant c_hifen: std_logic_vector(6 downto 0) := "0101101";
  constant c_mais: std_logic_vector(6 downto 0) := "0101011";
  constant c_pipe: std_logic_vector(6 downto 0) := "1111100";
  constant c_x: std_logic_vector(6 downto 0) := "1011000";
  constant c_o: std_logic_vector(6 downto 0) := "1001111";
  signal memoria_tabuleiro: memoria := (c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                                        c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                                        c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                                        c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                                        c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter);
begin
  process (clock, reset, leitura, escrita)
  begin
    if reset='1' then
      sinal_jogador <= '0';
      memoria_tabuleiro <= (c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                            c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                            c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                            c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                            c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter);
    elsif clock'event and clock='1' then
      if leitura='1' then
        saida <= memoria_tabuleiro(to_integer(unsigned(endereco_leitura)));
      elsif escrita='1' then
        if sinal_jogador='0' then
          memoria_tabuleiro(to_integer(unsigned(endereco_escrita))) <= c_x;
        else
          memoria_tabuleiro(to_integer(unsigned(endereco_escrita))) <= c_o;
        end if;
        sinal_jogador <= not sinal_jogador;
      end if;
    end if;
    jogador <= sinal_jogador;
  end process;
end estrutural;
