library ieee;
use ieee.std_logic_1164.all;

entity termostat is
	port(time_up,temp_up,clk_100Mhz:in std_logic;
	temp_type,change,enter,enter_limit: in std_logic;
	anod:out std_logic_vector(3 downto 0);
	catod:out std_logic_vector(7 downto 0);
	LED_racire,LED_incalzire,LED_loaded_temp: out std_logic);
end entity;
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity divizor_de_frecventa is
	port(clk0:in std_logic;
	clk1: out std_logic);
end entity;

architecture divizor_de_frecventa of divizor_de_frecventa is
begin
	process(clk0)
	variable x: std_logic_vector (27 downto 0):=x"0000000";
	variable y: std_logic:='0';
	begin
	if clk0='1' and clk0'event then
		x:=x+1;
		if x=x"2FAF080" and y='0' then
		    x:=x"0000000";
			y:='1';
		elsif x=x"2FAF080" and y='1' then
			x:=x"0000000";
			y:='0';
		end if;
	end if;
	clk1<=y;
	end process;
end architecture ;

architecture thermo of termostat is

component numarator_timp is 
	port(clk: in std_logic; 
	min0,min1: out std_logic_vector (3 downto 0);
	current_time_5b:out std_logic_vector(4 downto 0));
end component;

component unitate_de_date is
	port(CSmin,CSmax,WEmin,WEmax,clk,mode: in std_logic;
	current_time_5b,time_set_5b,temp_set_5b:in std_logic_vector(4 downto 0);
	min_t,max_t: out std_logic_vector(4 downto 0));
end component;	 

component comparator_temp is 
	port(max_t,min_t,current_temp_5b: in std_logic_vector(4 downto 0);
	above,good,below : out std_logic);
end component;

component unitate_de_simulare is
	port(cu,cd,clk,ld: in std_logic;
	temp:in std_logic_vector(4 downto 0);
	current_temp_5b: out std_logic_vector(4 downto 0));
end component;	

component introducere_date is
	port(time_up,temp_up,rst,clk:in std_logic;
	time_set_5b,temp_set_5b: out std_logic_vector (4 downto 0));
end component;

component afisor is
	port(a1,a2,a3,a4: in std_logic_vector (3 downto 0);
	clk:in std_logic;
	anod: out std_logic_vector(3 downto 0);
	catod:out std_logic_vector(7 downto 0));
end component;

component afisor_select is 
	port(current_time_5b,time_set_5b,current_temp_5b,temp_set_5b:in std_logic_vector(4 downto 0);
	min0,min1: in std_logic_vector (3 downto 0);
	clk, mode,mode2, change :in std_logic;
	a1,a2,a3,a4:out std_logic_vector(3 downto 0));
end component;		

component unitate_de_comanda is
	port(above,below,good,clk:in std_logic;
	temp_type,enter,enter_limit:in std_logic;
	CU,CD,MODE,MODE2,CSmin,CSmax,WEmin,WEmax,reset,LD,LED_loaded_temp: out std_logic);
end component;

component divizor_de_frecventa is
	port(clk0:in std_logic;
	clk1: out std_logic);
end component;

signal min0_s,min1_s:std_logic_vector(3 downto 0);
signal tmp_set_5b,tim_set_5b,max,min,current_tim_5b,current_tmp_5b: std_logic_vector(4 downto 0);
signal clk_1Hz:std_logic;
signal aa1,aa2,aa3,aa4: std_logic_vector(3 downto 0);
signal above_s,below_s,good_s,cu_s,cd_s,mode_s,csmin_s,csmax_s,wemin_s,wemax_s,reset_s,ld_s,mode2_s	:std_logic;
begin
    C1: divizor_de_frecventa port map(clk0=>clk_100Mhz,clk1=>clk_1Hz);
	C2: introducere_date port map(rst=>reset_s,time_up=>time_up,temp_up=>temp_up,clk=>clk_100MHZ,temp_set_5b=>tmp_set_5b,time_set_5b=>tim_set_5b);
	C3:	numarator_timp port map(clk=>clk_1Hz,min0=>min0_s,min1=>min1_s,current_time_5b=>current_tim_5b);
	C4: unitate_de_simulare port map(ld=>LD_s,cu=>cu_s,cd=>cd_s,clk=>clk_1Hz,temp=>tmp_set_5b,current_temp_5b=>current_tmp_5b);
	C5: afisor_select port map(mode2=>mode2_s,clk=>clk_100Mhz,mode=>mode_s,change=>change,current_time_5b=>current_tim_5b,current_temp_5b=>current_tmp_5b,time_set_5b=>tim_set_5b, temp_set_5b=>tmp_set_5b,min1=>min1_s,min0=>min0_s,a1=>aa1,a2=>aa2,a3=>aa3,a4=>aa4);
	C6: afisor port map (a1=>aa1,a2=>aa2,a3=>aa3,a4=>aa4,clk=>clk_100MHZ,anod=>anod,catod=>catod);
	C7:	unitate_de_date port map (clk=>clk_1Hz,CSmin=>CSmin_s,CSmax=>CSmax_s,WEmin=>WEmin_s,WEmax=>WEmax_s,current_time_5b=>current_tim_5b,temp_set_5b=>tmp_set_5b,time_set_5b=>tim_set_5b,mode=>mode_s,max_t=>max,min_t=>min);
	C8: comparator_temp port map (max_t=>max,min_t=>min,current_temp_5b=>current_tmp_5b,above=>above_s,below=>below_s,good=>good_s);
	C9: unitate_de_comanda port map (enter=>enter,enter_limit=>enter_limit,above=>above_s,below=>below_s,good=>good_s,clk=>clk_1Hz,temp_type=>temp_type,cu=>cu_s,cd=>cd_s,mode=>mode_s,mode2=>mode2_s,csmin=>csmin_s,csmax=>csmax_s,wemin=>wemin_s,wemax=>wemax_s,reset=>reset_s,ld=>ld_s,LED_loaded_temp=>LED_loaded_temp);		
	LED_racire<=cd_s;
	LED_incalzire<=cu_s;
end architecture;








	