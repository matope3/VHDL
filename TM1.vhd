use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity compteur_16 is
    port(
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;
        deb : out std_logic;
        out_count : out std_logic_vector (3 downto 0)
    );
end compteur_16;



architecture comptage of compteur_16 is

    signal out_count_temp : std_logic_vector (3 downto 0) := "0000"; -- signal interne pour ne pas lire out_count

begin 

    out_count <= out_count_temp; -- on assigne le signal interne au véritable signal de sortie
    deb <= '1' when out_count_temp  = "1111" else '0'; -- equivalent if en expression concurrente car hors d'un process !

    process(clk) -- à chaque changement d'état de la clock on réveille le process
    begin

        if clk'event and clk = '1' then -- à chaque front montant de clock
            if rst = '1' then -- priorité au reset sur le enable
                out_count_temp <= "0000";
            elsif enable = '1' then -- on incrémente le compteur si enable est activé 
                if out_count_temp = "1111" then
                    out_count_temp <= "0000"; -- on gère le débordement

                else
                    out_count_temp <= std_logic_vector(unsigned(out_count_temp) + 1);
                
                end if;
            end if;
        end if;
    end process;
end architecture;


-- TESTBENCH

entity test_compteur_16 is
end entity;

architecture tb of test_compteur_16 is

    signal clock : std_logic;
    signal reset : std_logic;
    signal activation : std_logic;
    signal debordement : std_logic;
    signal sortie : std_logic_vector (3 downto 0);

begin

    compteur : entity work.compteur_16(comptage)
        port map (clock, reset, activation, debordement, sortie);
    
    -- émulation des signaux en entrée :

    clock <= not(clock) after 10 ns; -- Génération d'un signal de clock simple
    activation <= '0' , '1' after 300 ns;
    reset <= '1' , '0' after 100 ns, '1' after 400 ns, '0' after 500 ns;

end architecture;


