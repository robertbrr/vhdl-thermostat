library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity  numarator_timp is 
	port(clk: in std_logic; 
	min0,min1: out std_logic_vector (3 downto 0);
	current_time_5b:out std_logic_vector(4 downto 0));
end entity;

architecture numarator_timp of numarator_timp is
begin
	process(clk)
	variable secunde: std_logic_vector(5 downto 0):="000000";
	variable minute0: std_logic_vector(3 downto 0):=x"0";
	variable minute1: std_logic_vector(3 downto 0):=x"0";
	variable ore_5b: std_logic_vector(4 downto 0):="01000";
	begin
		if clk='1' and clk'event then
			secunde:=secunde+1;
			if secunde="111100" then
				secunde:="000000";
				minute0:=minute0+1;
				if minute0="1010" then
					minute0:="0000";
					minute1:=minute1+1;
					if minute1="0110" then
						minute1:="0000";
						ore_5b:=ore_5b+1;
						if ore_5b="11000" then
							ore_5b:="00000";
						end if;
					end if;
				end if;
			end if;
		end if;
		min0<=minute0;
		min1<=minute1;
		current_time_5b<=ore_5b;
	end process;
end architecture;
