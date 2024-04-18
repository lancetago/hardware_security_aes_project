library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity controller is
port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    o_rcon : out std_logic_vector(7 downto 0); -- round constant
    o_is_final_round : out std_logic; -- checking whether or not to do mixcolumns
    o_done : out std_logic
);
end controller;

architecture Behavioral of controller is
    
    component xtime is
    port (
        i_byte : in std_logic_vector(7 downto 0);
        o_byte : out std_logic_vector(7 downto 0)
    );
    end component;

    signal r_temp, w_feedback : std_logic_vector(7 downto 0) := (others => '0');

begin
    
    process(i_clk) is
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '0') then
                r_temp <= x"01";
            else
                r_temp <= w_feedback;
            end if;
        end if;
    end process;
    
    u1 : xtime
    port map (
        i_byte => r_temp,
        o_byte => w_feedback
    );
    
    process(r_temp)
    begin
        if (r_temp = x"36") then
            o_is_final_round <= '1';
        else
            o_is_final_round <= '0';
        end if;
        
        if (r_temp = x"6c") then
            o_done <= '1';
        else
            o_done <= '0';
        end if;
    end process;
    
    o_rcon <= r_temp;

end Behavioral;
