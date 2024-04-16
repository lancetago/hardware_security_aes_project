library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity inv_key_schedule_round is
    port (
        i_subkey : in std_logic_vector(127 downto 0);
        i_rcon : in std_logic_vector(7 downto 0);
        o_subkey : out std_logic_vector(127 downto 0)
    );
end inv_key_schedule_round;

architecture behavioral of inv_key_schedule_round is

    component s_box is
        port (
            i_byte : in std_logic_vector(7 downto 0);
            o_byte : out std_logic_vector(7 downto 0)
        );
    end component;

    signal w_substituted_subkey : std_logic_vector(31 downto 0);
    signal w_shifted_subkey : std_logic_vector(31 downto 0);
    signal w_w3, w_w2, w_w1, w_w0 : std_logic_vector(31 downto 0);

begin

    w_w3 <= i_subkey(4*32-1 downto 3*32) xor i_subkey(3*32-1 downto 2*32);
    w_w2 <= i_subkey(3*32-1 downto 2*32) xor i_subkey(2*32-1 downto 1*32);
    w_w1 <= i_subkey(2*32-1 downto 1*32) xor i_subkey(1*32-1 downto 0);

    gen : for i in 0 to 3 generate
        u1 : s_box
            port map (
                i_byte => w_w3((i+1)*8-1 downto i*8),
                o_byte => w_substituted_subkey((i+1)*8-1 downto i*8)
            );
    end generate gen;

    w_shifted_subkey <= w_substituted_subkey(7 downto 0) & w_substituted_subkey(31 downto 8);
    w_w0(31 downto 8) <= i_subkey(31 downto 8) xor w_shifted_subkey(31 downto 8);
    w_w0(7 downto 0) <= i_subkey(7 downto 0) xor i_rcon xor w_shifted_subkey(7 downto 0);
    o_subkey <= w_w3 & w_w2 & w_w1 & w_w0;

end architecture behavioral;