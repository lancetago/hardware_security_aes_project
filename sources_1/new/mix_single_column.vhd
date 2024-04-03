library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity mix_single_column is
port (
    i_word : in std_logic_vector(31 downto 0);
    o_word : out std_logic_vector(31 downto 0)
);
end mix_single_column;

architecture Behavioral of mix_single_column is

    component xtime is
    port (
        i_byte : in std_logic_vector(7 downto 0);
        o_byte : out std_logic_vector(7 downto 0)
    );
    end component;

    signal w_t : std_logic_vector(7 downto 0);
    signal w_v0, w_v1, w_v2, w_v3 : std_logic_vector(7 downto 0);
    signal w_xtime_v0, w_xtime_v1, w_xtime_v2, w_xtime_v3 : std_logic_vector(7 downto 0);

begin

    -- 4.1.2: The Design of Rijndael
    -- t = a[0] xor a[1] xor a[2] xor a[3]
    w_t <= i_word(31 downto 24) xor i_word(23 downto 16) xor i_word(15 downto 8) xor i_word(7 downto 0);
    w_v0 <= i_word(7 downto 0) xor i_word(15 downto 8);
    w_v1 <= i_word(15 downto 8) xor i_word(23 downto 16);
    w_v2 <= i_word(23 downto 16) xor i_word(31 downto 24);
    w_v3 <= i_word(31 downto 24) xor i_word(7 downto 0);
    
    u1 : xtime
    port map (
        i_byte => w_v0,
        o_byte => w_xtime_v0
    );
    
    u2 : xtime
    port map (
        i_byte => w_v1,
        o_byte => w_xtime_v1
    ); 
    
    u3 : xtime
    port map (
        i_byte => w_v2,
        o_byte => w_xtime_v2
    );
    
    u4 : xtime
    port map (
        i_byte => w_v3,
        o_byte => w_xtime_v3
    );
    
    o_word(7 downto 0) <= i_word(7 downto 0) xor w_xtime_v0 xor w_t;
    o_word(15 downto 8) <= i_word(15 downto 8) xor w_xtime_v1 xor w_t;
    o_word(23 downto 16) <= i_word(23 downto 16) xor w_xtime_v2 xor w_t;    
    o_word(31 downto 24) <= i_word(31 downto 24) xor w_xtime_v3 xor w_t;

end Behavioral;
