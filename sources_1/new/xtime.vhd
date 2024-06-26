library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity xtime is
port (
    i_byte : in std_logic_vector(7 downto 0);
    o_byte : out std_logic_vector(7 downto 0)
);
end xtime;

architecture Behavioral of xtime is

	signal w_shifted_byte : std_logic_vector(7 downto 0);
	signal w_conditional_xor : std_logic_vector(7 downto 0);

begin

    w_shifted_byte <= i_byte(6 downto 0) & "0";
	w_conditional_xor <= "000" & i_byte(7) & i_byte(7) & "0" & i_byte(7) & i_byte(7);
	o_byte <= w_shifted_byte xor w_conditional_xor;

end Behavioral;
