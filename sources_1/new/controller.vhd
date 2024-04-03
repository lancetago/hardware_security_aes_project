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

    component regs is
    generic (
        size : positive
    );
    port (
        i_clk : in std_logic;
        i_data : in std_logic_vector(size-1 downto 0);
        o_data : out std_logic_vector(size-1 downto 0)
    );
    end component;
    
    component xtime is
    port (
        i_byte : in std_logic_vector(7 downto 0);
        o_byte : out std_logic_vector(7 downto 0)
    );
    end component;

    signal w_in, w_out, w_feedback : std_logic_vector(7 downto 0) := (others => '0');

begin

    w_in <= x"01" when i_rst = '0' else w_feedback;
    
    u1 : regs
    generic map (
        size => 8
    )
    port map (
        i_clk => i_clk,
        i_data => w_in,
        o_data => w_out
    );
    
    u2 : xtime
    port map (
        i_byte => w_out,
        o_byte => w_feedback
    );
    
    process(w_out)
    begin
        if (w_out = x"36") then
            o_is_final_round <= '1';
        else
            o_is_final_round <= '0';
        end if;
        
        if (w_out = x"6c") then
            o_done <= '1';
        else
            o_done <= '0';
        end if;
    end process;
    
    o_rcon <= w_out;

end Behavioral;
