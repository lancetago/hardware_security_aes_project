library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity aes_encryption_top_tb is
end aes_encryption_top_tb;

architecture Behavioral of aes_encryption_top_tb is

    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '1';
    signal i_key : std_logic_vector(127 downto 0) := (others => '0');
    signal i_plaintext : std_logic_vector(127 downto 0) := (others => '0');
    signal o_ciphertext : std_logic_vector(127 downto 0) := (others => '0');
    signal o_done : std_logic := '0';
    
    constant clk_period : time := 10 ns;

    component aes_encryption_top is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_key : in std_logic_vector(127 downto 0);
        i_plaintext : in std_logic_vector(127 downto 0);
        o_ciphertext : out std_logic_vector(127 downto 0);
        o_done : out std_logic
    );
    end component;

begin

    uut : aes_encryption_top
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_key => i_key,
        i_plaintext => i_plaintext,
        o_ciphertext => o_ciphertext,
        o_done => o_done
    );

    -- clock process
    process begin
        i_clk <= '0';
        wait for clk_period/2;
        i_clk <= '1';
        wait for clk_period/2;
    end process;

    -- simulation process
    process begin
		-- Initialize Inputs
		i_plaintext <= x"340737e0a29831318d305a88a8f64332";
		i_key <= x"3c4fcf098815f7aba6d2ae2816157e2b";
		i_rst <= '0';
		-- Hold reset state for one cycle		
		wait for clk_period;
		i_rst <= '1';
		wait until o_done = '1';
		wait for clk_period/2;
		if (o_ciphertext = x"320b6a19978511dcfb09dc021d842539") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		report "---------- Output must be: -------";
		report "320b6a19978511dcfb09dc021d842539";
		--------------------------------------------
		-- Initialize Inputs	
		i_plaintext <= x"00000000000000000000000000000000";
		i_key <= x"00000000000000000000000000000000";
		i_rst <= '0';
		-- Hold reset state for one cycle		
		wait for clk_period;
		i_rst <= '1';
		wait until o_done = '1';
		wait for clk_period/2;			
		if (o_ciphertext = x"2e2b34ca59fa4c883b2c8aefd44be966") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		report "---------- Output must be: -------";
		report "2e2b34ca59fa4c883b2c8aefd44be966";
		--------------------------------------------
		-- A test vector taken from: https://csrc.nist.gov/CSRC/media/Projects/Cryptographic-Standards-and-Guidelines/documents/examples/AES_Core128.pdf
		-- Initialize Inputs	
		i_plaintext <= x"2a179373117e3de9969f402ee2bec16b";
		i_key <= x"3c4fcf098815f7aba6d2ae2816157e2b";
		i_rst <= '0';
		-- Hold reset state for one cycle		
		wait for clk_period;
		i_rst <= '1';
		wait until o_done = '1';
		wait for clk_period/2;			
		if (o_ciphertext = x"97ef6624f3ca9ea860367a0db47bd73a") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		report "---------- Output must be: -------";
		report "97ef6624f3ca9ea860367a0db47bd73a";
		wait;
    end process;

end Behavioral;
