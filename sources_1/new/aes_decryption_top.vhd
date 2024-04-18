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
    
    component inv_key_schedule is
        port (
            i_clk : in std_logic;
            i_rst : in std_logic;
            i_key : in std_logic_vector(127 downto 0);
            i_rcon : in std_logic_vector(7 downto 0);
            o_key : out std_logic_vector(127 downto 0)
        );
    end component;
        
    component dec_controller is
        port (
            i_clk : in std_logic;
            i_rst : in std_logic;
            o_rcon : out std_logic_vector(7 downto 0);
            o_first_round : out std_logic;
            o_done : out std_logic
        );
    end component;

    signal r_temp : std_logic_vector(127 downto 0);
    signal w_inv_mixcols_i : std_logic_vector(127 downto 0);
    signal w_inv_mixcols_o : std_logic_vector(127 downto 0);
    signal w_inv_shift_rows : std_logic_vector(127 downto 0);
    signal w_inv_sub_byte : std_logic_vector(127 downto 0);
    signal w_feedback : std_logic_vector(127 downto 0);
    signal w_round_key : std_logic_vector(127 downto 0);
    signal w_rcon : std_logic_vector(7 downto 0);
    signal w_first_round : std_logic;

begin
    
    process(i_clk) is
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '0') then
                r_temp <= i_ciphertext;
            else
                r_temp <= w_feedback;
            end if;
        end if;
    end process;
    
    u1 : add_round_key
    port map (
        i_state => r_temp,
        i_subkey => w_round_key,
        o_state => w_inv_mixcols_i
    );
    
    u2 : inv_mix_columns
    port map (
        i_data => w_inv_mixcols_i,
        o_data => w_inv_mixcols_o
    );
    
    w_inv_shift_rows <= w_inv_mixcols_i when w_first_round = '1' else w_inv_mixcols_o;
    
    u3 : inv_shift_rows
    port map (
        i_data => w_inv_shift_rows,
        o_data => w_inv_sub_byte
    );
    
    u4 : inv_sub_byte
    port map (
        i_data => w_inv_sub_byte,
        o_data => w_feedback
    );
    
    u5 : inv_key_schedule
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_key => i_key,
        i_rcon => w_rcon,
        o_key => w_round_key
    );
    
    u6 : dec_controller
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        o_rcon => w_rcon,
        o_first_round => w_first_round,
        o_done => o_done
    );
    
    o_plaintext <= w_inv_mixcols_i;

end Behavioral;
