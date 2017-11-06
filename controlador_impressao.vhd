-- VHDL do controlador de impressao do tabuleiro

library ieee;
use ieee.std_logic_1164.all;

entity controlador_impressao is
  port(
    clock                   : in std_logic;
    reset                   : in std_logic;
    comeca_impressao        : in std_logic;
    uart_livre              : in std_logic;
    posicao_leitura         : out std_logic_vector(6 downto 0);
    leitura_memoria         : out std_logic;
    transmite_dado          : out std_logic;
    pronto                  : out std_logic
  );
end controlador_impressao;

architecture exemplo of controlador_impressao is

  component unidade_controle_tabuleiro is
    port(
      clock               : in std_logic;
      reset               : in std_logic;
      start               : in std_logic;
      fim_contagem        : in std_logic;
      uart_livre          : in std_logic;
      transmite_dado      : out std_logic;
      atualiza_caractere  : out std_logic;
      pronto              : out std_logic
    );
  end component;

  component contador_tabuleiro is
    port(
      clock     : in  std_logic;
      zera      : in  std_logic;
      conta     : in  std_logic;
      contagem  : out std_logic_vector(6 downto 0);
      fim       : out std_logic
    );
  end component;

  signal sinal_pronto, sinal_atualiza_caractere, sinal_fim_contagem: std_logic;

begin

  unidade_controle: unidade_controle_tabuleiro port map (clock, reset, comeca_impressao, sinal_fim_contagem, uart_livre, transmite_dado, sinal_atualiza_caractere, sinal_pronto);
  fluxo_dados: contador_tabuleiro port map (clock, sinal_pronto, sinal_atualiza_caractere, posicao_leitura, sinal_fim_contagem);

  pronto <= sinal_pronto;
  leitura_memoria <= sinal_atualiza_caractere;

end exemplo;
