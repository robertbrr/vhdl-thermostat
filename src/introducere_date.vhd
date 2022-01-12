library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity nr_introd_temp is
	port(clk,rst:in std_logic;
	temp_set_5b: out std_logic_vector(4 downto 0));
end entity;

architecture int_temp of nr_introd_temp is
begin
	process(clk,rst)
	variable x: std_logic_vector(4 downto 0):="00000";
	begin
		if rst='1' then
			x:="00000";
		else
			if clk='1' and clk'event then
				x:=x+1;	
			end if;
		end if;
		temp_set_5b<=x;
	end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity nr_introd_time is
	port(clk,rst:in std_logic;
	time_set_5b: out std_logic_vector(4 downto 0));
end entity;

architecture int_time of nr_introd_time is
begin
	process(clk,rst)
	variable x: std_logic_vector(4 downto 0):="00000";
	begin
		if rst='1' then
			x:="00000";
		else
			if clk='1' and clk'event then
				x:=x+1;
				if x="11000" then
					x:="00000";
					end if;
			end if;
		end if;
		time_set_5b<=x;
	end process;
end architecture;
library IEEE;
use IEEE.std_logic_1164.all;

entity introducere_date is
	port(time_up,temp_up,rst,clk:in std_logic;
	time_set_5b,temp_set_5b: out std_logic_vector (4 downto 0));
end entity;
library IEEE;
use IEEE.std_logic_1164.all;
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bistabil_D is
	port(D,R,clk : in std_logic;
	Q: out std_logic);
end entity;

architecture bist_D of bistabil_D is
begin
	process(clk,R)
	begin
		if R='1' then 
			Q<='0';
		elsif clk'event and clk='1' then
				Q<=D;
		end if;
	end process;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
entity poarta_si_3 is
	port(a,b,c: in std_logic;
	y: out std_logic);
end entity;

architecture flux of poarta_si_3 is
begin 
	y<=(a and b and c);
end architecture ;

library IEEE;
use IEEE.std_logic_1164.all;
entity debounce is 
	port(clk,r,btn: in std_logic;
	btn_db:out std_logic);
end entity;

architecture struct of debounce is

component poarta_si_3 is
	port(a,b,c: in std_logic;
	y: out std_logic);
end component;
component bistabil_D is
	port(D,R,clk : in std_logic;
	Q: out std_logic);
end component;

signal q1,q2,q3: std_logic;
begin 
	C1: bistabil_D port map(D=>btn, R=>r, clk=>clk, Q=>q1);
	C2: bistabil_D port map(D=>q1, R=>r, clk=>clk, Q=>q2);
	C3: bistabil_D port map(D=>q2, R=>r, clk=>clk, Q=>q3);
	C4: poarta_si_3 port map(a=>q1, b=>q2, c=>q3, y=>btn_db);
end architecture;
---------------------------------------------------------
architecture int_data of introducere_date is

component nr_introd_time is
	port(clk,rst:in std_logic;
	time_set_5b: out std_logic_vector(4 downto 0));
end component; 

component nr_introd_temp is
	port(clk,rst:in std_logic;
	temp_set_5b: out std_logic_vector(4 downto 0));
end component;

component debounce is 
	port(clk,r,btn: in std_logic;
	btn_db:out std_logic);
end component;
component nr16 is
	port(clk:in std_logic;
	q:out std_logic_vector (1 downto 0));
end	component;

signal f,p,d1,d2:std_logic;
begin  
	C0: nr16 port map(clk=>clk,q(0)=>f,q(1)=>p);
	C1: debounce port map(clk=>p,r=>rst,btn=>time_up,btn_db=>d1);
	C2: debounce port map(clk=>p,r=>rst,btn=>temp_up,btn_db=>d2);
	C3: nr_introd_time port map (clk=>d1,rst=>rst,time_set_5b=>time_set_5b);
	C4: nr_introd_temp port map (clk=>d2,rst=>rst,temp_set_5b=>temp_set_5b);
end architecture;


			
	