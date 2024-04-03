library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity sub_bytes is
port(
    i_data : in std_logic_vector(127 downto 0);
    o_data : out std_logic_vector(127 downto 0)
);
end sub_bytes;

architecture Behavioral of sub_bytes is

    component s_box is
    port (
        i_byte : in std_logic_vector(7 downto 0);
        o_byte : out std_logic_vector(7 downto 0)
    );
    end component;

begin

    sbox : for i in 0 to 15 generate
        u1 : s_box
        port map (
            i_byte => i_data((i+1)*8-1 downto i*8),
            o_byte => o_data((i+1)*8-1 downto i*8)
        );
    end generate sbox;

end Behavioral;
