library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity aes_encryption_top is
port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_key : in std_logic_vector(127 downto 0);
    i_plaintext : in std_logic_vector(127 downto 0);
    o_ciphertext : out std_logic_vector(127 downto 0);
    o_done : out std_logic
);
end aes_encryption_top;

architecture Behavioral of aes_encryption_top is

    signal w_temp : std_logic_vector(127 downto 0);
    signal w_sbox_in : std_logic_vector(127 downto 0);
    signal w_sbox_out : std_logic_vector(127 downto 0);
    signal w_shift_rows_out : std_logic_vector(127 downto 0);
    signal w_mix_columns_out : std_logic_vector(127 downto 0);
    signal w_feedback : std_logic_vector(127 downto 0);
    signal w_round_key : std_logic_vector(127 downto 0);
    signal w_rcon : std_logic_vector(7 downto 0);
    signal w_sel : std_logic;

    component controller is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        o_rcon : out std_logic_vector(7 downto 0); -- round constant
        o_is_final_round : out std_logic; -- checking whether or not to do mixcolumns
        o_done : out std_logic
    );
    end component;
    
    component sub_bytes is
    port(
        i_data : in std_logic_vector(127 downto 0);
        o_data : out std_logic_vector(127 downto 0)
    );
    end component;
    
    component mix_columns is
    port (
        i_data : in std_logic_vector(127 downto 0);
        o_data : out std_logic_vector(127 downto 0)
    );
    end component;
    
    component key_schedule is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_key : in std_logic_vector(127 downto 0);
        i_round_const : in std_logic_vector(7 downto 0);
        o_round_key : out std_logic_vector(127 downto 0)
    );
    end component;
    
    component add_round_key is
    port (
        i_state : in std_logic_vector(127 downto 0);
        i_subkey : in std_logic_vector(127 downto 0);
        o_state : out std_logic_vector(127 downto 0)
    );
    end component;
    
    component shift_rows is
    port (
        i_data : in std_logic_vector(127 downto 0);
        o_data : out std_logic_vector(127 downto 0)
    );
    end component;

begin

    w_feedback <= w_mix_columns_out when w_sel = '0' else w_shift_rows_out;
    o_ciphertext <= w_sbox_in;
    
    process(i_clk) is
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '0') then
                w_temp <= i_plaintext;
            else
                w_temp <= w_feedback;
            end if;
        end if;
    end process;
    
    -- Functionality for each round
    u1 : add_round_key
    port map (
        i_state => w_temp,
        i_subkey => w_round_key,
        o_state => w_sbox_in
    );
    
    u2 : sub_bytes
    port map (
        i_data => w_sbox_in,
        o_data => w_sbox_out
    );
    
    u3 : shift_rows
    port map (
        i_data => w_sbox_out,
        o_data => w_shift_rows_out
    );
    
    u4 : mix_columns
    port map (
        i_data => w_shift_rows_out,
        o_data => w_mix_columns_out
    );
    
    -- Controller for determining if we're on the final round or not
    u5 : controller
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        o_rcon => w_rcon,
        o_is_final_round => w_sel,
        o_done => o_done    
    );
    
    -- Key schedule
    u6 : key_schedule
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_key => i_key, 
        i_round_const => w_rcon,
        o_round_key => w_round_key  
    );

end Behavioral;
