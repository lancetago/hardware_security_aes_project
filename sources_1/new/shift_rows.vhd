library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity shift_rows is
port (
    i_data : in std_logic_vector(127 downto 0);
    o_data : out std_logic_vector(127 downto 0)
);
end shift_rows;

architecture Behavioral of shift_rows is

begin

    -- We assign each row as every 4 so that the columns are adjacent to each other
    -- because by doing that, it makes the MixColumns functionality easier since we
    -- can modify groups of words instead of columns which are every 4 bytes

    -- First row is left unchanged
    o_data(8*1-1 downto 8*0) <= i_data(8*1-1 downto 8*0);
    o_data(8*5-1 downto 8*4) <= i_data(8*5-1 downto 8*4);
    o_data(8*9-1 downto 8*8) <= i_data(8*9-1 downto 8*8);
    o_data(8*13-1 downto 8*12) <= i_data(8*13-1 downto 8*12);
    
    -- Second row, each byte is shifted one to the left
    o_data(8*2-1 downto 8*1) <= i_data(8*6-1 downto 8*5);
    o_data(8*6-1 downto 8*5) <= i_data(8*10-1 downto 8*9);
    o_data(8*10-1 downto 8*9) <= i_data(8*14-1 downto 8*13);
    o_data(8*14-1 downto 8*13) <= i_data(8*2-1 downto 8*1);
    
    -- Third row, each byte is shifted two to the left
    o_data(8*3-1 downto 8*2) <= i_data(8*11-1 downto 8*10);
    o_data(8*7-1 downto 8*6) <= i_data(8*15-1 downto 8*14);
    o_data(8*11-1 downto 8*10) <= i_data(8*3-1 downto 8*2);
    o_data(8*15-1 downto 8*14) <= i_data(8*7-1 downto 8*6);
    
    -- Fourth row, each byte is shifted three to the left
    o_data(8*4-1 downto 8*3) <= i_data(8*16-1 downto 8*15);
    o_data(8*8-1 downto 8*7) <= i_data(8*4-1 downto 8*3);
    o_data(8*12-1 downto 8*11) <= i_data(8*8-1 downto 8*7);
    o_data(8*16-1 downto 8*15) <= i_data(8*12-1 downto 8*11);

end Behavioral;
