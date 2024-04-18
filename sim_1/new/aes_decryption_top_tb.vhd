library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity aes_decryption_top_tb is

end aes_decryption_top_tb;
architecture Testbench of aes_decryption_top_tb is

    component aes_decryption_top is
        port (
            i_clk : in std_logic;
            i_rst : in std_logic;
            i_key : in std_logic_vector(127 downto 0);
            i_ciphertext : in std_logic_vector(127 downto 0);
            o_plaintext : out std_logic_vector(127 downto 0);
            o_done : out std_logic
        );
    end component;
    
    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '0';
    signal i_key : std_logic_vector(127 downto 0) := (others => '0');
    signal i_ciphertext : std_logic_vector(127 downto 0) := (others => '0');
    
    signal o_plaintext : std_logic_vector(127 downto 0) := (others => '0');
    signal o_done : std_logic := '0';
    
    constant clk_period : time := 8 ns;

begin

    uut : aes_decryption_top
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_key => i_key,
        i_ciphertext => i_ciphertext,
        o_plaintext => o_plaintext,
        o_done => o_done
    );
    
    clk : process is
    begin
        i_clk <= '0';
        wait for clk_period/2;
        i_clk <= '1';
        wait for clk_period/2;
    end process;
    
    sim : process is
    begin
		i_ciphertext <= x"320b6a19978511dcfb09dc021d842539";
		i_key <= x"a60c63b6c80c3fe18925eec9a8f914d0";
		i_rst <= '0';
		-- Hold reset state for one cycle		
		wait for clk_period * 1;
		i_rst <= '1';
		wait until o_done = '1';
		wait for clk_period/2;			
		if (o_plaintext = x"340737e0a29831318d305a88a8f64332") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		report "---------- Output must be: -------";
		report "340737e0a29831318d305a88a8f64332";		

		i_ciphertext <= x"2e2b34ca59fa4c883b2c8aefd44be966";
		i_key <= x"8e188f6fcf51e92311e2923ecb5befb4";
		i_rst <= '0';
		-- Hold reset state for one cycle		
		wait for clk_period * 1;
		i_rst <= '1';
		wait until o_done = '1';
		wait for clk_period/2;			
		if (o_plaintext = x"00000000000000000000000000000000") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		report "---------- Output must be: -------";
		report "00000000000000000000000000000000";
		wait;
    end process;

end Testbench;
