library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity inv_sub_byte is
    port (
        i_data : in std_logic_vector(127 downto 0);
        o_data : out std_logic_vector(127 downto 0)
    );
end inv_sub_byte;

architecture Behavioral of inv_sub_byte is

    component inv_s_box is
        port (
            i_byte : in std_logic_vector(7 downto 0);
            o_byte : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    gen : for i in 0 to 15 generate
        u1 : inv_s_box
            port map (
                i_byte => i_data((i+1)*8-1 downto i*8),
                o_byte => o_data((i+1)*8-1 downto i*8)
            );
    end generate gen;

end Behavioral;
