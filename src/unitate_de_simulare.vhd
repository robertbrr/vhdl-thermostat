library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity unitate_de_simulare is
	port(cu,cd,clk,ld: in std_logic;
	temp:in std_logic_vector(4 downto 0);
	current_temp_5b: out std_logic_vector(4 downto 0));
end entity;

architecture us of unitate_de_simulare is
begin
	process(clk,ld)
	variable cnt: std_logic_vector(1 downto 0):="00";
	variable x: std_logic_vector (4 downto 0):="00000";
	begin
		if ld='1' then
			x:=temp;
			cnt:="00";
		else
			if clk='1' and clk'event then
				if cu='1' and cd='0' then
				    cnt:=cnt+1;
				    if cnt="11" then
				        x:=x+1;
				        cnt:="00";
				    end if;
				elsif cu='0' and cd='1' then
				    cnt:=cnt+1;
				    if cnt="11" then
				        x:=x-1;
				        cnt:="00";
				        end if;
				else cnt:="00";
				end if;	
			end if;
		end if;
		current_temp_5b<=x;
	end process;
end architecture;
		
		
					
			
		
	