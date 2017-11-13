-- VHDL da Unidade de Controle da interface jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_logica_jogo is
  port(
    clock               : in std_logic;
    reset               : in std_logic;
    start               : in std_logic;
    fim_recepcao        : in std_logic;   -- indica que um caractere terminou de ser recebido
    jogada_ok           : in std_logic;   -- indica que o caractere recebido é valido
    fim_jogo            : in std_logic;   -- indica que o jogo acabou
    recebe_dado         : out std_logic;  -- habilita a recepção de um dado
    insere_dado         : out std_logic;  -- habilita a inserção do dado na memoria
    jogo_acabado        : out std_logic;  -- indica que o jogo acabou
    pronto              : out std_logic;  -- indica que a jogada terminou de ser processada
    estados             : out std_logic_vector(2 downto 0)
  );
end unidade_controle_logica_jogo;

architecture comportamental of unidade_controle_logica_jogo is
type tipo_estado is (inicial, recebe, valida_jogada, guarda, valida_tabuleiro, aguarda, final);
signal estado   : tipo_estado;

begin
  process (clock, estado, reset)
  begin
    if reset = '1' then
        estado <= inicial;
    elsif (clock'event and clock = '1') then
      case estado is
        when inicial =>               -- Aguarda sinal de start
          if start = '1' then
            estado <= recebe;
          else
            estado <= inicial;
          end if;

        when recebe =>                -- Espera o dado ser recebido
          if fim_recepcao = '1' then
            estado <= valida_jogada;
          else
            estado <= recebe;
          end if;

        when valida_jogada =>         -- Verifica se o caractere é valido
          if jogada_ok = '0' then
            estado <= recebe;
          else
            estado <= guarda;
          end if;

        when guarda =>                -- Guarda o dado no tabuleiro
          estado <= valida_tabuleiro;

        when valida_tabuleiro =>      -- Verifica se o jogo acabou
          if fim_jogo = '1' then
            estado <= final;
          else
            estado <= aguarda;
          end if;

        when aguarda =>               -- Prepara a interface do jogo
          estado <= inicial;

        when final =>                 -- Fim do jogo
          estado <= final;

        when others =>                -- Default
          estado <= inicial;
      end case;
    end if;
  end process;

  -- logica de saída
  with estado select
    recebe_dado <= '1' when recebe,
                   '0' when others;

  with estado select
    insere_dado <= '1' when guarda,
                    '0' when others;

  with estado select
    jogo_acabado <= '1' when final,
                    '0' when others;

  with estado select
    pronto <= '1' when aguarda,
              '0' when others;

  process(estado)
  begin
    case estado is
      when inicial => estados <= "000";
      when recebe => estados <= "001";
      when valida_jogada => estados <= "010";
      when guarda => estados <= "011";
      when valida_tabuleiro => estados <= "100";
      when aguarda => estados <= "101";
      when final => estados <= "110";
      when others => null;
    end case;
  end process;
end comportamental;
