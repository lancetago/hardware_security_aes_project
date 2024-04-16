library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity aes_decryption_top is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_key : in std_logic_vector(127 downto 0);
        i_ciphertext : in std_logic_vector(127 downto 0);
        o_plaintext : out std_logic_vector(127 downto 0);
        o_done : out std_logic
    );
end aes_decryption_top;

architecture Behavioral of aes_decryption_top is
    
    component add_round_key is
        port (
            i_state : in std_logic_vector(127 downto 0);
            i_subkey : in std_logic_vector(127 downto 0);
            o_state : out std_logic_vector(127 downto 0)
        );
    end component;
    
    component inv_mix_columns is
        port (
            i_data : in std_logic_vector(127 downto 0);
            o_data : out std_logic_vector(127 downto 0)
        );
    end component;
    
    component inv_shift_rows is
        port (
            i_data : in std_logic_vector(127 downto 0);
            o_data : out std_logic_vector(127 downto 0)
        );
    end component;
    
    component inv_sub_byte is
        port (
            i_data : in std_logic_vector(127 downto 0);
            o_data : out std_logic_vector(127 downto 0)
        );
    end component;

    signal w_mux_output : std_logic_vector(127 downto 0);
    signal w_reg_output : std_logic_vector(127 downto 0);
    signal w_inv_mixcols_i : std_logic_vector(127 downto 0);
    signal w_inv_mixcols_o : std_logic_vector(127 downto 0);
    signal w_inv_shift_rows : std_logic_vector(127 downto 0);
    signal w_inv_sub_byte : std_logic_vector(127 downto 0);
    signal w_feedback : std_logic_vector(127 downto 0);
    signal w_round_key : std_logic_vector(127 downto 0);
    signal w_rcon : std_logic_vector(7 downto 0);
    signal w_first_round : std_logic;

begin

    

end Behavioral;
