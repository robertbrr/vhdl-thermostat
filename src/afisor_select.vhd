library ieee;
use ieee.std_logic_1164.all;

entity toggle is 
	port ( T,clk:in std_logic;
	Q: out std_logic);
end entity;

architecture toggle of toggle is
begin
	process(clk)
	variable x:std_logic:='0';
	begin
		if clk='1' and clk'event then
			if T='0' then
				x:=x;
			else
				x:=not x;
			end if;
		end if;
		q<=x;
	end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity separator is
	port(x_5b: in std_logic_vector(4 downto 0);
	x1,x0: out std_logic_vector(3 downto 0));
end entity; 

architecture separator of separator is
type sep is array (0 to 31) of std_logic_vector (7 downto 0);
signal p: sep:=(x"00",x"01",x"02",x"03",x"04",x"05",x"06",x"07",x"08",x"09",
x"10",x"11",x"12",x"13",x"14",x"15",x"16",x"17",x"18",x"19",
x"20",x"21",x"22",x"23",x"24",x"25",x"26",x"27",x"28",x"29",
x"30",x"31");
begin
	process(x_5b)
	variable x:std_logic_vector(7 downto 0);
	begin
	case x_5b is
		when "00000" =>x:=p(0) ;
		when "00001" =>x:=p(1) ;  
		when "00010" =>x:=p(2) ; 
		when "00011" =>x:=p(3) ;
		when "00100" =>x:=p(4) ;
		when "00101" =>x:=p(5) ;
		when "00110" =>x:=p(6) ;
		when "00111" =>x:=p(7) ;
		when "01000" =>x:=p(8) ;
		when "01001" =>x:=p(9) ;
		when "01010" =>x:=p(10) ;
		when "01011" =>x:=p(11) ;
		when "01100" =>x:=p(12) ;
		when "01101" =>x:=p(13) ;
		when "01110" =>x:=p(14) ;
		when "01111" =>x:=p(15) ;
		when "10000" =>x:=p(16) ;
		when "10001" =>x:=p(17) ;  
		when "10010" =>x:=p(18) ; 
		when "10011" =>x:=p(19) ;
		when "10100" =>x:=p(20) ;
		when "10101" =>x:=p(21) ;
		when "10110" =>x:=p(22) ;
		when "10111" =>x:=p(23) ;
		when "11000" =>x:=p(24) ;
		when "11001" =>x:=p(25) ;
		when "11010" =>x:=p(26) ;
		when "11011" =>x:=p(27) ;
		when "11100" =>x:=p(28) ;
		when "11101" =>x:=p(29) ;
		when "11110" =>x:=p(30) ;
		when "11111" =>x:=p(31) ;
		when others =>x:=x"00";
	end case;
	x0<=x(3 downto 0);
	x1<=x(7 downto 4);
	end process;
end architecture;	 

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_2_1_4b is
	port(x0,x1:in std_logic_vector(3 downto 0);
	s: in std_logic;
	y:out std_logic_vector (3 downto 0));
end entity;

architecture mux_4b of mux_2_1_4b is
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

library IEEE;
use ieee.std_logic_1164.all;
entity poarta_sau2 is
	port(a,b: in std_logic;
	y:out std_logic);
end entity ;
architecture sau2 of poarta_sau2 is
begin
	y<=a or b;
end architecture ;

---------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity afisor_select is 
	port(current_time_5b,time_set_5b,current_temp_5b,temp_set_5b:in std_logic_vector(4 downto 0);
	min0,min1: in std_logic_vector (3 downto 0);
	clk,mode,mode2,change :in std_logic;
	a1,a2,a3,a4:out std_logic_vector(3 downto 0));
end entity;

architecture afisor_select of afisor_select is 
component mux_2_1_4b is
	port(x0,x1:in std_logic_vector(3 downto 0);
	s: in std_logic;
	y:out std_logic_vector (3 downto 0));
end component;
component mux_2_1_5b is
	port(x0,x1:in std_logic_vector(4 downto 0);
	s: in std_logic;
	y:out std_logic_vector (4 downto 0));
end component; 	

component separator is
	port(x_5b: in std_logic_vector(4 downto 0);
	x1,x0: out std_logic_vector(3 downto 0));
end component;

component toggle is 
	port ( T,clk:in std_logic;
	Q: out std_logic);
end component;

component debounce is 
	port(clk,r,btn: in std_logic;
	btn_db:out std_logic);
end component;

component poarta_sau2 is
	port(a,b: in std_logic;
	y:out std_logic);
end component;

signal y1,y2: std_logic_vector (4 downto 0);  
signal y3,y4, temp1,temp0,time1,time0: std_logic_vector (3 downto 0);
signal db, change_s,p: std_logic;
begin		   
	C0: poarta_sau2 port map(a=>mode,b=>mode2,y=>p);
	C1: mux_2_1_5b port map(s=>p,x0=>current_temp_5b,x1=>temp_set_5b,y=>y1);
	C2: mux_2_1_5b port map(s=>mode,x0=>current_time_5b,x1=>time_set_5b,y=>y2);
	C3: mux_2_1_4b port map(s=>mode,x0=>min1,x1=>"0000",y=>y3);
	C4: mux_2_1_4b port map(s=>mode,x0=>min0,x1=>"0000",y=>y4);
	C5: separator port map(x_5b=>y1,x1=>temp1,x0=>temp0);
	C6: separator port map(x_5b=>y2,x1=>time1,x0=>time0);
	C7: mux_2_1_4b port map(s=>change_s,x0=>time1,x1=>temp1,y=>a1);
	C8: mux_2_1_4b port map(s=>change_s,x0=>time0,x1=>temp0,y=>a2);
	C9: mux_2_1_4b port map(s=>change_s,x0=>y3,x1=>"1101",y=>a3);
	C10:mux_2_1_4b port map(s=>change_s,x0=>y4,x1=>"1100",y=>a4);
	C11: debounce port map(r=>'0', clk=>clk,btn=>change, btn_db=>db);
	C12: toggle port map(clk=>db,t=>'1',q=>change_s);
	
end architecture;


	
	