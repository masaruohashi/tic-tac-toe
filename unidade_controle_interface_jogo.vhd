-- VHDL da Unidade de Controle da interface jogo da velha

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_interface_jogo is
   port(
    clock: in std_logic;
    reset: in std_logic;
    start: in std_logic;
    fim_impressao: in std_logic;
    fim_recepcao: in std_logic;
    uart_livre: in std_logic;
    imprime_tabuleiro: out std_logic;
    atualiza_caractere: out std_logic;
    recebe_dado: out std_logic;
    limpa_contador: out std_logic;
    insere_dado: out std_logic;
    dep_estados: out std_logic_vector(2 downto 0)
  );
end unidade_controle_interface_jogo;

architecture comportamental of unidade_controle_interface_jogo is
type tipo_estado is (inicial, prepara, imprime, recebe, guarda);
signal estado   : tipo_estado;

begin
    process (clock, estado, reset)
    begin

    if reset = '1' then
        estado <= inicial;

    elsif (clock'event and clock = '1') then
      case estado is
        when inicial =>                -- Aguarda sinal de start
          if start = '1' then
            estado <= prepara;
          else
            estado <= inicial;
          end if;

        when prepara =>
          if fim_impressao = '1' then
            estado <= recebe;
          else
            estado <= imprime;
          end if;

        when imprime =>                -- Imprime o tabuleiro no terminal
          if uart_livre = '1' then
            estado <= prepara;
          else
            estado <= imprime;
          end if;

        when recebe =>        -- Espera o dado ser recebido
          if fim_recepcao = '1' then
            estado <= guarda;
          else
            estado <= recebe;
          end if;

        when guarda =>        -- Guarda o dado no tabuleiro
          estado <= prepara;

        when others =>       -- Default
          estado <= inicial;
      end case;
    end if;
    end process;

    -- logica de saída
    with estado select
      imprime_tabuleiro <= '1' when imprime,
                           '0' when others;
    with estado select
      recebe_dado <= '1' when recebe,
                     '0' when others;

    with estado select
      insere_dado <= '1' when guarda,
                     '0' when others;

    with estado select
      limpa_contador <= '1' when recebe,
                        '0' when others;

    with estado select
      atualiza_caractere <= '1' when prepara,
                            '0' when others;

    process (estado)
    begin
      case estado is
        when inicial =>
          dep_estados <= "000";
        when prepara =>
          dep_estados <= "001";
        when imprime =>
          dep_estados <= "010";
        when recebe =>
          dep_estados <= "011";
        when guarda =>
          dep_estados <= "100";
        when others =>
          null;
      end case;
    end process;
end comportamental;
