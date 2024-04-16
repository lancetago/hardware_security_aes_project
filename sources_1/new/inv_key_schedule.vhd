library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity inv_key_schedule is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_key : in std_logic_vector(127 downto 0);
        i_rcon : in std_logic_vector(7 downto 0);
        o_key : out std_logic_vector(127 downto 0)
    );
end inv_key_schedule;

architecture Behavioral of inv_key_schedule is
    
    component inv_key_schedule_round is
        port (
            i_subkey : in std_logic_vector(127 downto 0);
            i_rcon : in std_logic_vector(7 downto 0);
            o_subkey : out std_logic_vector(127 downto 0)
        );
    end component;

    signal w_feedback : std_logic_vector(127 downto 0);
    signal w_temp : std_logic_vector(127 downto 0);

begin

    process(i_clk) is
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '0') then
                w_temp <= i_key;
            else
                w_temp <= w_feedback;
            end if;
        end if;
    end process;
    
    u1 : inv_key_schedule_round
    port map (
        i_subkey => w_temp,
        i_rcon => i_rcon,
        o_subkey => w_feedback
    ); 
    
    o_key <= w_temp;

end Behavioral;
