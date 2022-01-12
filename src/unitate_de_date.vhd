library ieee;   
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all; 
 
entity memorie_ram_min is 
  port (clk : in std_logic;  
        WE_min,CS_min  : in std_logic;   
        A_min   : in std_logic_vector(4 downto 0);   
        I_min : in std_logic_vector(4 downto 0);   
        D_min  : out std_logic_vector(4 downto 0));   
end entity;   
architecture ram_min of memorie_ram_min is   
type MEMORIE is array (0 to 31) of std_logic_vector(4 downto 0 );
signal p: MEMORIE :=(others=>"10101");  
begin   
  process (WE_min,CS_min,clk)   
  begin
	if cs_min='1' then
    if (clk'event and clk = '1') then   
      if (we_min = '1') then   
        p(conv_integer(A_min)) <= I_min ; 
        else
        D_min <= p(conv_integer(A_min));   
      end if;   
    end if; 
    else
    D_min<="ZZZZZ";
	end if;
  end process;     
end architecture; 

library ieee;   
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all; 
 
entity memorie_ram_max is 
  port (clk : in std_logic;  
        WE_max,CS_max  : in std_logic;   
        A_max   : in std_logic_vector(4 downto 0);   
        I_max : in std_logic_vector(4 downto 0);   
        D_max  : out std_logic_vector(4 downto 0));   
end entity;   
architecture ram_max of memorie_ram_max is   
type MEMORIE is array (0 to 31) of std_logic_vector(4 downto 0 );
signal p: MEMORIE :=(others=>"11000");  
begin   
  process (WE_max,CS_max,clk)   
  begin
	if cs_max='1' then
        if (clk'event and clk = '1') then   
            if (we_max = '1') then   
             p(conv_integer(A_max)) <= I_max;
                else
             D_max<=p(conv_integer(A_max));   
             end if;   
         end if; 
         else
         D_max<="ZZZZZ";
	end if;
  end process;     
end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_2_1_5b is
	port(x0,x1:in std_logic_vector(4 downto 0);
	s: in std_logic;
	y:out std_logic_vector (4 downto 0));
end entity;

architecture mux_5b of mux_2_1_5b is
begin
	process(x0,x1,s)
	begin
		if s='0' then 
			y<=x0;
		else
			y<=x1;
		end if;
	end process;
end architecture;
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity unitate_de_date is
	port(CSmin,CSmax,WEmin,WEmax,clk,mode: in std_logic;
	current_time_5b,time_set_5b,temp_set_5b:in std_logic_vector(4 downto 0);
	min_t,max_t: out std_logic_vector(4 downto 0));
end entity;

architecture data of unitate_de_date is
component memorie_RAM_min is
	port(A_min : in std_logic_vector(4 downto 0);
	I_min: in std_logic_vector (4 downto 0);
	WE_min, CS_min, clk : in std_logic;
	D_min :out std_logic_vector(4 downto 0));
end component;
component memorie_RAM_max is
	port(A_max : in std_logic_vector(4 downto 0);
	I_max: in std_logic_vector (4 downto 0);
	WE_max, CS_max, clk : in std_logic;
	D_max :out std_logic_vector(4 downto 0));
end component;
component mux_2_1_5b is
	port(x0,x1:in std_logic_vector(4 downto 0);
	s: in std_logic;
	y:out std_logic_vector (4 downto 0));
end component;
signal d1:std_logic_vector (4 downto 0);
begin
	C1: mux_2_1_5b port map (x0=>current_time_5b,x1=>time_set_5b,s=>mode,y=>d1);
	C2: memorie_RAM_min port map(A_min=>d1,I_min=>temp_set_5b,WE_min=>WEmin,CS_min=>CSmin,clk=>clk,D_min=>min_t);
	C3: memorie_RAM_max port map(A_max=>d1,I_max=>temp_set_5b,WE_max=>WEmax,CS_max=>CSmax,clk=>clk,D_max=>max_t);
end architecture;