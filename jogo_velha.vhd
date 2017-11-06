-- VHDL do Jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity jogo_velha is
  port(
    clock           : in std_logic;
    reset           : in std_logic;
    entrada_serial  : in std_logic;     -- entrada serial de dados do terminal
    start           : in std_logic;     -- começo do jogo
    primeiro        : in std_logic;     -- indica o primeiro jogador
    CTS             : in  std_logic;    -- Clear to Send
    CD              : in  std_logic;    -- Carrier Detect
    RD              : in  std_logic;    -- Received Data
    DTR             : out std_logic;    -- Data Transfer Ready
    RTS             : out std_logic;    -- Request to Send
    TD              : out std_logic;    -- Transmitted Data
    saida_serial    : out std_logic;    -- saida serial de dados para o teminal
    fim             : out std_logic;    -- fim do jogo
    dep_estados     : out std_logic_vector(3 downto 0)
  );
end jogo_velha;

architecture estrutural of jogo_velha is

  component unidade_controle_interface_jogo is
    port(
      clock                 : in std_logic;
      reset                 : in std_logic;
      start                 : in std_logic;
      CTS                   : in std_logic;
      CD                    : in std_logic;
      primeiro              : in std_logic;
      fim_impressao         : in std_logic;
      fim_recepcao_jogador  : in std_logic;
      fim_recepcao_oponente : in std_logic;
      jogada_ok             : in std_logic;
      fim_jogo              : in std_logic;
      jogador               : out std_logic;
      liga_modem            : out std_logic;
      imprime_tabuleiro     : out std_logic;
      envia_dados_jogador   : out std_logic;
      recebe_dado_jogador   : out std_logic;
      recebe_dado_oponente  : out std_logic;
      insere_dado           : out std_logic;
      jogo_acabado          : out std_logic;
      dep_estados           : out std_logic_vector(3 downto 0)
    );
  end component;

  component fluxo_dados_interface_jogo is
    port(
      clock                   : in  std_logic;
      reset                   : in  std_logic;
      jogador                 : in  std_logic;
      transmite_dado_jogada   : in  std_logic;
      escreve_memoria         : in  std_logic;
      recebe_dado_jogador     : in  std_logic;
      recebe_dado_oponente    : in  std_logic;
      imprime_tabuleiro       : in  std_logic;
      entrada_serial          : in  std_logic;
      liga_modem              : in  std_logic;
      CTS                     : in  std_logic;
      CD                      : in  std_logic;
      RD                      : in  std_logic;
      DTR                     : out std_logic;
      RTS                     : out std_logic;
      TD                      : out std_logic;
      saida_serial            : out std_logic;
      fim_impressao           : out std_logic;
      fim_recepcao_jogador    : out std_logic;
      fim_recepcao_oponente   : out std_logic;
      fim_jogo                : out std_logic;
      jogada_ok               : out std_logic
    );
  end component;

  signal s_fim_impressao, s_imprime_tabuleiro, s_envia_dados_jogador: std_logic;  -- relacionados ao envio de dados pela uart
  signal s_recebe_dado_jogador, s_recebe_dado_oponente, s_insere_dado: std_logic; -- relacionados a recepção do dado
  signal s_fim_recepcao_jogador, s_fim_recepcao_oponente: std_logic;              -- relacionados ao fim da recepção
  signal s_fim_jogo, s_jogada_ok: std_logic;                                      -- relacionados a validações/verificações
  signal s_jogador: std_logic;                                                    -- relacionados ao jogador atual
  signal s_liga_modem: std_logic;                                                 -- relacionados ao modem

begin

    unidade_controle : unidade_controle_interface_jogo port map (
      clock, reset, start, CTS, CD, primeiro, s_jogador, s_fim_impressao, s_fim_recepcao_jogador, s_fim_recepcao_oponente, s_jogada_ok, s_fim_jogo,
      s_liga_modem, s_imprime_tabuleiro, s_envia_dados_jogador, s_recebe_dado_jogador, s_recebe_dado_oponente, s_insere_dado, fim, dep_estados
    );

    fluxo_dados: fluxo_dados_interface_jogo port map(
      clock, reset, s_jogador, s_envia_dados_jogador, s_insere_dado, s_recebe_dado_jogador, s_recebe_dado_oponente, s_imprime_tabuleiro, entrada_serial,
      s_liga_modem, CTS, CD, RD, DTR, RTS, TD, saida_serial, s_fim_impressao, s_fim_recepcao_jogador, s_fim_recepcao_oponente, s_fim_jogo, s_jogada_ok
    );

end estrutural;
