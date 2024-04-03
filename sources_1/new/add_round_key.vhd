-- Subkey is combined with the state where the subkey comes from the key schedule.
-- The subkey is added by combining of the state with the corresponding byte of the subkey
-- using bitwise xor.

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity add_round_key is
    port (
        i_state : in std_logic_vector(127 downto 0);
        i_subkey : in std_logic_vector(127 downto 0);
        o_state : out std_logic_vector(127 downto 0)
    );
end add_round_key;

architecture Behavioral of add_round_key is

begin

    o_state <= i_state xor i_subkey;

end Behavioral;
