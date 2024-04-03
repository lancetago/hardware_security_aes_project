library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    
entity regs is
generic (
    size : positive
);
port (
    i_clk : in std_logic;
    i_data : in std_logic_vector(size-1 downto 0);
    o_data : out std_logic_vector(size-1 downto 0)
);
end regs;

architecture Behavioral of regs is

    signal r_curr, r_next : std_logic_vector(size-1 downto 0);

begin

    r_next <= i_data;
    
    process(i_clk) begin
            if (rising_edge(i_clk)) then
                r_curr <= r_next;
            end if;
    end process;
    
    o_data <= r_curr;

end Behavioral;