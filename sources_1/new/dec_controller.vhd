library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity dec_controller is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        o_rcon : out std_logic_vector(7 downto 0);
        o_first_round : out std_logic;
        o_done : out std_logic
    );
end dec_controller;

architecture Behavioral of dec_controller is

    -- we already know what the rcon constants are going to be, we can
    -- save extra work by putting in a LUT instead of doing calculations again
    -- 22 hex digits = 88 bits
    constant c_rcon_table : std_logic_vector(87 downto 0) := x"0001020408102040801b36";
    signal r_rcon : std_logic_vector(7 downto 0); 

begin

    process(i_clk) is
        variable i : integer range 0 to 11 := 0;
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '0') then
                i := 0;
            else
                i := i + 1;
            end if;
        end if;
        
        r_rcon <= c_rcon_table((i+1)*8-1 downto i*8);
        
        if (r_rcon = x"00") then
            o_done <= '1';
        else
            o_done <= '0';
        end if;
        
        if (r_rcon = x"36") then
            o_first_round <= '1';
        else
            o_first_round <= '0';
        end if;
    end process;
    
    o_rcon <= r_rcon;
end Behavioral;
