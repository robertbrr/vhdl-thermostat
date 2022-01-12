library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux_4_1 is 
	port(x0,x1,x2,x3: in std_logic_vector(3 downto 0);
	sel: in std_logic_vector(1 downto 0);
	y: out std_logic_vector (3 downto 0));
end entity;

architecture mux4 of mux_4_1 is
begin
	process(sel,x0,x1,x2,x3)
	begin
		case sel is
			when "00"=>y<=x0;
			when "01"=>y<=x1;
			when "10"=>y<=x2;
			when "11"=>y<=x3;
			when others=>y<=x3;
		end case;
	end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity nr16 is
	port(clk:in std_logic;
	q:out std_logic_vector (1 downto 0));
end entity;

architecture nr16 of nr16 is
begin
	process(clk)
	variable x:std_logic_vector(15 downto 0):=x"0000";
	begin
		if clk='1' and clk'event then
			x:=x+1;
		end if;
		q<=x(15 downto 14);
	end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bcd_to_7seg is
	port(x:in std_logic_vector(3 downto 0);
	y:out std_logic_vector (7 downto 0));
end entity;

architecture bcd_to_7 of bcd_to_7seg is
begin
	process(x)
	begin
		case x is
			when "0000" =>y <= "00000011";--ultimul bit pt dp
			when "0001" =>y <= "10011111"; 
			when "0010" =>y <= "00100101"; 
			when "0011" =>y <= "00001101"; 
			when "0100" =>y <= "10011001"; 
			when "0101" =>y <= "01001001"; 
			when "0110" =>y <= "01000001"; 
			when "0111" =>y <= "00011111";
			when "1000" =>y <= "00000001"; 
			when "1001" =>y <= "00001001";
			when "1100" =>y <= "01100011";--litera C pentru Celsius
			when "1101" =>y <= "00111001";-- simbolul pentru grade
			when others =>y <= "11111111";
		end case;
	end process;
end architecture;


---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity afisor is
	port(a1,a2,a3,a4: in std_logic_vector (3 downto 0);
	clk:in std_logic;
	anod: out std_logic_vector(3 downto 0);
	catod:out std_logic_vector(7 downto 0));
end entity;

architecture afisoare of afisor is
component bcd_to_7seg is
	port(x:in std_logic_vector(3 downto 0);
	y:out std_logic_vector (7 downto 0));
end component;
component mux_4_1 is 
	port(x0,x1,x2,x3: in std_logic_vector(3 downto 0);
	sel: in std_logic_vector(1 downto 0);
	y: out std_logic_vector (3 downto 0));
end component;
component nr16 is
	port(clk:in std_logic;
	q:out std_logic_vector (1 downto 0));
end component;

signal M1,M2:std_logic_vector(3 downto 0);
signal N1: std_logic_vector (1 downto 0);
signal N2: std_logic_vector (3 downto 0);
begin
	C1: nr16 port map(clk=>clk,q=>N1);
	C2: mux_4_1 port map(x0=>a4,x1=>a3,x2=>a2,x3=>a1,sel=>N1,y=>N2);
	C3: bcd_to_7seg port map(x=>N2,y=>catod);
	C4: mux_4_1 port map(x0=>"1110",x1=>"1101",x2=>"1011",x3=>"0111",sel=>N1,y=>anod);
end architecture;


	
