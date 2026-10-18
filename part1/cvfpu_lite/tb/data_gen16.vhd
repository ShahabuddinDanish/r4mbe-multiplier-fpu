library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity data_gen16 is  
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    D0    : out std_logic_vector(15 downto 0);
    D1    : out std_logic_vector(15 downto 0);
    D2    : out std_logic_vector(15 downto 0);
    VOUT  : out std_logic;
    END_SIM : out std_logic);
end entity data_gen16;

architecture beh of data_gen16 is

  constant tco : time := 1 ns;

  type tval_t is array (0 to 9) of std_logic_vector(15 downto 0);
  constant ctvalA : tval_t := (
    ('0' & conv_std_logic_vector(15+3, 5) & conv_std_logic_vector(7, 3) & conv_std_logic_vector(0, 10-3)), -- 15
    ('0' & conv_std_logic_vector(15+7, 5) & conv_std_logic_vector(19, 5) & conv_std_logic_vector(0, 10-5)), -- 204
    ('0' & conv_std_logic_vector(15+10, 5) & conv_std_logic_vector(0, 10)), -- 1024
    ('1' & conv_std_logic_vector(15+3, 5) & conv_std_logic_vector(7, 3) & conv_std_logic_vector(0, 10-3)), -- -15
    ('1' & conv_std_logic_vector(15+7, 5) & conv_std_logic_vector(19, 5) & conv_std_logic_vector(0, 10-5)), -- -204
    ('0' & conv_std_logic_vector(15+6, 5) & conv_std_logic_vector(0, 3) & conv_std_logic_vector(67, 10-3)), -- 68.1875 (0-10101-0001000011)
    ('0' & conv_std_logic_vector(15-2, 5) & conv_std_logic_vector(10, 5) & conv_std_logic_vector(13, 10-5)), -- 0.331299 (0-01101-0101001101)
    ('0' & conv_std_logic_vector(15+9, 5) & conv_std_logic_vector(27, 5) & conv_std_logic_vector(18, 10-5)), -- 953 (0-11000-1101110010)
    ('1' & conv_std_logic_vector(15+5, 5) & conv_std_logic_vector(9, 5) & conv_std_logic_vector(16, 10-5)), -- -41.5 (1-10100-0100110000)
    ('0' & conv_std_logic_vector(15, 5) & conv_std_logic_vector(10, 5) & conv_std_logic_vector(28, 10-5)) -- 1.33984 (0-01111-0101011100)    
    );  

  constant ctvalB : tval_t := (
    ('0' & conv_std_logic_vector(15+7, 5) & conv_std_logic_vector(19, 5) & conv_std_logic_vector(0, 10-5)), -- 204
    ('0' & conv_std_logic_vector(15+10, 5) & conv_std_logic_vector(0, 10)), -- 1024
    ('1' & conv_std_logic_vector(15+3, 5) & conv_std_logic_vector(7, 3) & conv_std_logic_vector(0, 10-3)), -- -15
    ('1' & conv_std_logic_vector(15+7, 5) & conv_std_logic_vector(19, 5) & conv_std_logic_vector(0, 10-5)), -- -204
    ('1' & conv_std_logic_vector(15+10, 5) & conv_std_logic_vector(0, 10)), -- -1024
    ('0' & conv_std_logic_vector(15+3, 5) & conv_std_logic_vector(0, 3) & conv_std_logic_vector(90, 10-3)), -- 8.70312 (0-10010-0001011010)
    ('0' & conv_std_logic_vector(15+5, 5) & conv_std_logic_vector(28, 5) & conv_std_logic_vector(30, 10-5)), -- 60.9375 (0-10100-1110011110)
    ('0' & conv_std_logic_vector(15+2, 5) & conv_std_logic_vector(13, 5) & conv_std_logic_vector(22, 10-5)), -- 5.71094 (0-10001-0110110110)
    ('0' & conv_std_logic_vector(15+7, 5) & conv_std_logic_vector(0, 5) & conv_std_logic_vector(19, 10-5)), -- 130.375 (0-10110-0000010011)
    ('1' & conv_std_logic_vector(15+9, 5) & conv_std_logic_vector(31, 5) & conv_std_logic_vector(5, 10-5)) -- -1010.5 (1-11000-1111100101)
    );  
  
  signal cnt : integer := 0;
  signal sEnd_sim : std_logic;

  signal sEnd_sim_pipe : std_logic_vector(5 downto 0);
  
begin  -- architecture beh

  process (CLK, RST_n) is
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      cnt <= 0;  
      D0 <= (others => '0');
      D1 <= (others => '0');
      D2 <= (others => '0');
      VOUT <= '0';
      sEnd_sim <= '0';
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if (cnt < 10) then
        cnt <= cnt + 1 after tco;
        D0 <= ctvalA(cnt) after tco;
        D1 <= ctvalB(cnt) after tco;
        VOUT <= '1' after tco;
        sEnd_sim <= '0' after tco;          
      else
        VOUT <= '0' after tco;
        sEnd_sim <= '1' after tco;
      end if;
    end if;
  end process;

  process (CLK, RST_n) is
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      sEnd_sim_pipe <= (others => '0');
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      sEnd_sim_pipe(0) <= sEnd_sim after tco;
      sEnd_sim_pipe(5 downto 1) <= sEnd_sim_pipe(4 downto 0) after tco;
    end if;
  end process;

  END_SIM <= sEnd_sim_pipe(5);

end beh;

