library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

------------------------------------- COMPTEUR MODULO N -------------------------------------------------------

entity compteur_N is
    Generic (
        C_NB_BIT_COUNTER : integer;
        C_MODULO : integer
        );
        
    Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        enable : in STD_LOGIC;
        max : out STD_LOGIC;
        out_count : out STD_LOGIC_VECTOR (C_NB_BIT_COUNTER - 1 downto 0)
        );
end compteur_N;



architecture arch_compteur_N of compteur_N

out_count_temp : STD_LOGIC_VECTOR (C_NB_BIT_COUNTER - 1 downto 0) := others => '0';

begin

    process (clk)
    begin

        if (clk'event and clk ='1') then
            if (rst = '1') then
                out_count_temp <= others => '0';
            elsif (enable = '1') then
                if (out_count_temp = (STD_LOGIC_VECTOR(unsigned(C_MODULO - 1)) ) then
                    out_count_temp <= others => '0';
                    
                else
                    out_count_temp <= STD_LOGIC_VECTOR(unsigned(out_count_temp)+1);
                end if
            end if
        end if  
    end process

    max <= '1' when out_count_temp = (STD_LOGIC_VECTOR(unsigned(C_MODULO - 1)) else '0';

end architecture;


----------------------------------------------------------TESTBENCH COMPTEUR 10-----------------------------------------------------------------


entity test_compteur_10 is
end;
    
architecture tb of test_compteur_10 is

    signal tb_clk : in STD_LOGIC;
    signal tb_rst : in STD_LOGIC;
    signal tb_enable : in STD_LOGIC;
    signal tb_max : out STD_LOGIC;
    signal tb_out_count : out STD_LOGIC_VECTOR (C_NB_BIT_COUNTER - 1 downto 0)

    begin 
        compteur10 : entity work.compteur_N(arch_compteur_N)
            generic map(C_NB_BIT_COUNTER => 4 , C_MODULO => 10);  -- Compteur modulo 10 à 4 bits
            port map(tb_clk, tb_rst, tb_enable, tb_max, tb_out_count);

        tb_clk <= not(tb_clk) after 5 ns; -- Génération d'un signal de clock simple de période 10 ns
        tb_enable <= '0' , '1' after 50 ns, '0' after 220 ns;
        tb_rst <= '1' , '0' after 30 ns, '1' after 210 ns, '0' after 240 ns;
    end;

end architecture;

