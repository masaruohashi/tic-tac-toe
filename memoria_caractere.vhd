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
      entrada_dados: in std_logic_vector(6 downto 0);
      endereco_leitura: in std_logic_vector(5 downto 0);
      endereco_escrita: in std_logic_vector(5 downto 0);
      saida: out std_logic_vector(6 downto 0)
    );
end memoria_caractere;

architecture estrutural of memoria_caractere is
   type memoria is array (58 downto 0) of std_logic_vector(6 downto 0);
   constant c_enter: std_logic_vector(6 downto 0) := "0001101";
   constant c_espaco: std_logic_vector(6 downto 0) := "0100000";
   constant c_hifen: std_logic_vector(6 downto 0) := "0101101";
   constant c_mais: std_logic_vector(6 downto 0) := "0101011";
   constant c_pipe: std_logic_vector(6 downto 0) := "1111100";
   signal memoria_tabuleiro: memoria := (c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                                         c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                                         c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                                         c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                                         c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco);
begin
  process (clock, reset, leitura, escrita)
  begin
    if reset='1' then
      memoria_tabuleiro <= (c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                            c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                            c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_enter,
                            c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_mais, c_hifen, c_hifen, c_hifen, c_enter,
                            c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco, c_pipe, c_espaco, c_espaco, c_espaco);
    elsif clock'event and clock='1' then
      if leitura='1' then
        saida <= memoria_tabuleiro(to_integer(unsigned(endereco_leitura)));
      elsif escrita='1' then
        memoria_tabuleiro(to_integer(unsigned(endereco_escrita))) <= "1011000";
      end if;
    end if;
  end process;
end estrutural;
