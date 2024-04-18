library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity aes_top is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_key : in std_logic_vector(127 downto 0);
        i_ciphertext : in std_logic_vector(127 downto 0);
        o_plaintext : out std_logic_vector(127 downto 0);
        o_done : out std_logic;
    );
end aes_top;

architecture Top of aes_top is

begin


end Top;
