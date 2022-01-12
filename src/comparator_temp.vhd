library IEEE;
use IEEE.std_logic_1164.all;

entity comparator_5 is 
	port(a,b:in std_logic_vector (4 downto 0);
	f1,f2,f3: out std_logic);
end entity;

architecture comparator_5 of comparator_5 is
begin
	process(a,b)
	begin
		if a>b then f1<='0';f2<='0';f3<='1';
		elsif a=b then f1<='0';f2<='1';f3<='0';
		elsif a<b then f1<='1';f2<='0';f3<='0';
		else f1<='0';f2<='0';f3<='0';
		end if;
	end process;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity poarta_sau3 is
	port(x0,x1,x2: in std_logic;
	y:out std_logic);
end entity;

architecture poarta_sau3 of poarta_sau3 is 
begin
	y<=x0 or x1 or x2;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity poarta_si_2 is
	port(x0,x1: in std_logic;
	y:out std_logic);
end entity;

architecture poarta_si_2 of poarta_si_2 is 
begin
	y<=x0 and x1;
end architecture;


--------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity comparator_temp is 
	port(max_t,min_t,current_temp_5b: in std_logic_vector(4 downto 0);
	above,good,below : out std_logic);
end entity ;

architecture struct_comparator of comparator_temp is
component comparator_5 is 
	port(a,b:in std_logic_vector (4 downto 0);
	f1,f2,f3: out std_logic);
end component; 
component  poarta_sau3 is
	port(x0,x1,x2: in std_logic;
	y:out std_logic);
end component; 

component  poarta_si_2 is
	port(x0,x1: in std_logic;
	y:out std_logic);
end component;
signal m2,m3,n1,n2,j: std_logic;
begin
	C1: comparator_5 port map(a=>max_t,b=>current_temp_5b,f1=>above,f2=>m2,f3=>m3);
	C2: comparator_5 port map(a=>min_t, b=>current_temp_5b,f1=>n1,f2=>n2,f3=>below);
	C3:	poarta_si_2 port map(x0=>m3,x1=>n1,y=>j);
	C4: poarta_sau3 port map(x0=>m2,x1=>n2,x2=>j,y=>good);
end architecture;





		 