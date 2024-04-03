library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity mix_columns is
port (
    i_data : in std_logic_vector(127 downto 0);
    o_data : out std_logic_vector(127 downto 0)
);
end mix_columns;

architecture Behavioral of mix_columns is

    component mix_single_column is
    port (
        i_word : in std_logic_vector(31 downto 0);
        o_word : out std_logic_vector(31 downto 0)
    );
    end component;

begin
    
    u1 : mix_single_column
    port map (
        i_word => i_data(31 downto 0),
        o_word => o_data(31 downto 0)
    );
    
    u2 : mix_single_column
    port map (
        i_word => i_data(63 downto 32),
        o_word => o_data(63 downto 32)
    );
    
    u3 : mix_single_column
    port map (
        i_word => i_data(95 downto 64),
        o_word => o_data(95 downto 64)
    );
    
    u4 : mix_single_column
    port map (
        i_word => i_data(127 downto 96),
        o_word => o_data(127 downto 96)
    );

end Behavioral;
