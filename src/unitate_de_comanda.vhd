library ieee;
use ieee.std_logic_1164.all;

entity unitate_de_comanda is
	port(above,below,good,clk:in std_logic;
	temp_type,enter,enter_limit:in std_logic;
	CU,CD,MODE,MODE2,CSmin,CSmax,WEmin,WEmax,reset,LD,LED_loaded_temp: out std_logic);
end entity;

architecture ucm of unitate_de_comanda is

signal stare:std_logic_vector(3 downto 0):=x"0";
signal nxstare:std_logic_vector(3 downto 0):=x"0";
begin
ACTUALIZEAZA_STARE: process (clk)
	begin
		if clk ='1' and clk'event then
		STARE <= NXSTARE;
		end if;
	end process ACTUALIZEAZA_STARE;	

TRANSITIONS: process (STARE,temp_type,above,below,good,enter_limit,enter)
	begin
		LD<='0'; CSmin<='0'; CSmax<='0'; Reset<='0'; CU<='0'; CD<='0';
		WEmin<='0'; WEmax<='0'; MODE<='0';LED_loaded_temp<='0';MODE2<='0';
		case STARE is
			when x"0" => Reset<='1';
			if enter_limit='0' then
			    if enter='1' then
				    NXSTARE<=x"1";
				else
				    NXSTARE<=x"0";
				    end if;
			else
			    MODE<='1';
				NXSTARE<=x"6";
			end if;
			when x"1" => MODE2<='1';
			if enter='0' then	
				LD<='1'; NXSTARE<=x"2";
			else
				NXSTARE<=x"1";
				end if;
			when x"2"=>CSmin<='1';CSmax<='1';LED_loaded_temp<='1';
			NXSTARE<=x"3";
			when x"3"=>CSmin<='1';CSmax<='1';
			if above='1' and below='0' then
				NXSTARE<=x"4";
			elsif above ='0' and below='1' then
				NXSTARE <=x"5";
			else
				NXSTARE<=x"0";
			end if;	
			when x"4"=> CSmin<='1';CSmax<='1';CD<='1';
			if good='0' then NXSTARE<=x"4";
				else
				CD<='0';
				NXSTARE<=x"0";
			end if;
			when x"5"=> CSmin<='1';CSmax<='1';CU<='1';
			if good='0' then NXSTARE<=x"5";
				else
				CU<='0';
				NXSTARE<=x"0";
			end if;
			when x"6" => MODE<='1';
			if enter_limit='0' then NXSTARE<=x"7";
			else NXSTARE<=x"6"; end if;
			when x"7" => MODE<='1';LED_loaded_temp<='1';
			if temp_type='0' then
				NXSTARE<=x"8";
			else
				NXSTARE<=x"9";
			end if;
			when x"8" => CSmin<='1'; WEmin<='1'; MODE<='1';
			LED_loaded_temp<='1';
			NXSTARE<=x"2";
			when x"9" => CSmax<='1'; WEmax<='1';MODE <='1';	   
			LED_loaded_temp<='1';
			NXSTARE<=x"2";
			when others=>NXSTARE<=x"0";
		end case;
	end process TRANSITIONS;
end architecture;
			