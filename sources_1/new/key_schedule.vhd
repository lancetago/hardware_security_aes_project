-- Implementation for round key schedule based off the Design of Rijndael textbook
-- Store data into registers, use an S-Box LUT, and perform key schedule operations
-- to return the round key

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity key_schedule is
port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_key : in std_logic_vector(127 downto 0);
    i_round_const : in std_logic_vector(7 downto 0);
    o_round_key : out std_logic_vector(127 downto 0)
);
end key_schedule;

architecture Behavioral of key_schedule is

    component regs is
    generic (
        size : positive
    );
    port (
        i_clk : in std_logic;
        i_data : in std_logic_vector(size-1 downto 0);
        o_data : out std_logic_vector(size-1 downto 0)
    );
    end component;

    component key_schedule_round is
    port (
        i_subkey : in std_logic_vector(127 downto 0);
        i_rcon : in std_logic_vector(7 downto 0);
        o_next_subkey : out std_logic_vector(127 downto 0)
    );
    end component;

    signal w_feedback : std_logic_vector(127 downto 0);
    signal w_regs_in : std_logic_vector(127 downto 0);
    signal w_regs_out : std_logic_vector(127 downto 0);

begin
    
    w_regs_in <= i_key when i_rst = '0' else w_feedback;

    u1 : regs
    generic map (
        size => 128
    )
    port map (
        i_clk => i_clk,
        i_data => w_regs_in,
        o_data => w_regs_out 
    );
    
    u2 : key_schedule_round
    port map (
        i_subkey => w_regs_out,
        i_rcon => i_round_const,
        o_next_subkey => w_feedback
    );
    
    o_round_key <= w_regs_out;

end Behavioral;
