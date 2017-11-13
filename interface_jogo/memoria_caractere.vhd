  -- VHDL de uma memoria do jogo da velha
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_caractere is
    port(
      clock             : in std_logic;
      reset             : in std_logic;
      leitura           : in std_logic;
      escrita           : in std_logic;
      jogador           : in std_logic;
      endereco_leitura  : in std_logic_vector(6 downto 0);
      endereco_escrita  : in std_logic_vector(6 downto 0);
      saida             : out std_logic_vector(6 downto 0)
    );
end memoria_caractere;

architecture estrutural of memoria_caractere is
  type memoria is array (0 to 69) of std_logic_vector(6 downto 0);
  constant c_enter: std_logic_vector(6 downto 0) := "0001101";
  constant c_espaco: std_logic_vector(6 downto 0) := "0100000";
  constant c_hifen: std_logic_vector(6 downto 0) := "0101101";
  constant c_mais: std_logic_vector(6 downto 0) := "0101011";
  constant c_pipe: std_logic_vector(6 downto 0) := "1111100";
  constant c_x: std_logic_vector(6 downto 0) := "1011000";
  constant c_o: std_logic_vector(6 downto 0) := "1001111";
  constant c_esc: std_logic_vector(6 downto 0) := "0011011";
  constant c_zero: std_logic_vector(6 downto 0) := "0110000";
  constant c_dois: std_logic_vector(6 downto 0) := "0110010";
  constant c_abrechaves: std_logic_vector(6 downto 0) := "1011011";
  constant c_pontovirgula: std_logic_vector(6 downto 0) := "0111011";
  constant c_J: std_logic_vector(6 downto 0) := "1001010";
  constant c_H: std_logic_vector(6 downto 0) := "1001000";
  signal memoria_tabuleiro: memoria := (c_esc, c_abrechaves, c_dois, c_J,
                                        c_esc, c_abrechaves, c_zero, c_pontovirgula, c_zero, c_H,
                                        c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                                        c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                                        c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                                        c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                                        c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter);
begin
  process (clock, reset, leitura, escrita, jogador)
  begin
    if reset='1' then
      memoria_tabuleiro <= (c_esc, c_abrechaves, c_dois, c_J,
                            c_esc, c_abrechaves, c_zero, c_pontovirgula, c_zero, c_H,
                            c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                            c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                            c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                            c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                            c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter);
    elsif clock'event and clock='1' then
      if leitura='1' then
        saida <= memoria_tabuleiro(to_integer(unsigned(endereco_leitura)));
      elsif escrita='1' then
        if jogador='0' then
          memoria_tabuleiro(to_integer(unsigned(endereco_escrita))) <= c_x;
        else
          memoria_tabuleiro(to_integer(unsigned(endereco_escrita))) <= c_o;
        end if;
      end if;
    end if;
  end process;
end estrutural;
