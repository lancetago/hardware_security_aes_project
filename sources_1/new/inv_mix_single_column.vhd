library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;


entity inv_mix_single_column is
port (
    i_word : in std_logic_vector(31 downto 0);
    o_word : out std_logic_vector(31 downto 0)
);
end inv_mix_single_column;

architecture Behavioral of inv_mix_single_column is

    component xtime is
    port (
        i_byte : in std_logic_vector(7 downto 0);
        o_byte : out std_logic_vector(7 downto 0)
    );
    end component;
    
    component mix_single_column is
    port (
        i_word : in std_logic_vector(31 downto 0);
        o_word : out std_logic_vector(31 downto 0)
    );
    end component;

    signal w_u, w_v : std_logic_vector(7 downto 0);
    signal w_xtime_u, w_xtime_v : std_logic_vector(7 downto 0);
    signal w_xtime2_u, w_xtime2_v : std_logic_vector(7 downto 0);
    signal w_mix_cols : std_logic_vector(31 downto 0);

begin

    w_u <= i_word(7 downto 0) xor i_word(23 downto 16);
    w_v <= i_word(15 downto 8) xor i_word(31 downto 24);
    
    u1 : xtime
    port map (
        i_byte => w_u,
        o_byte => w_xtime_u
    );
    
    u2 : xtime
    port map (
        i_byte => w_xtime_u,
        o_byte => w_xtime2_u
    );
    
    u3 : xtime
    port map (
        i_byte => w_v,
        o_byte => w_xtime_v
    );
    
    u4 : xtime
    port map (
        i_byte => w_xtime_v,
        o_byte => w_xtime2_v
    );
    
    w_mix_cols(7 downto 0) <= i_word(7 downto 0) xor w_xtime2_u;
    w_mix_cols(15 downto 8) <= i_word(15 downto 8) xor w_xtime2_v;
    w_mix_cols(23 downto 16) <= i_word(23 downto 16) xor w_xtime2_u;
    w_mix_cols(31 downto 24) <= i_word(31 downto 24) xor w_xtime2_v;
    
    u5 : mix_single_column
    port map (
        i_word => w_mix_cols,
        o_word => o_word
    );

end Behavioral;
