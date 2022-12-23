library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity serialReceiver is
Port(
clk,din : in std_logic;
dout : out std_logic_vector(6 downto 0);
data_valid ,err: out std_logic
);
end serialReceiver;


architecture behav of serialReceiver is
signal temp : std_logic_vector (6 downto 0);
begin
process(clk,temp)
variable parity : std_logic ;
variable stopbit : std_logic;
variable flag : std_logic := '0';
variable i : integer :=0;
variable count  : integer := 0;
begin
if (clk'event and clk = '1') then
	if flag = '0' and din = '1' then
		flag := '1';
	elsif flag = '1' and i<7 then
		temp(i) <= din;
		i := i + 1;
			if din = '1' then
				count := count +1;
			end if;
	elsif i = 7 then
		parity := din;
		i := i + 1;

	elsif i = 8 then
		i := i+1;
		stopbit := din;
	end if;
end if;
if (i = 9 ) then
	if (count mod 2 = 0 and (parity = '0')) or (count mod 2 = 1 and (parity = '1')) then
				if (stopbit = '1') then
					data_valid <= '1';
					err <= '0';
					dout <= temp;
				else
				data_valid <= '0';
					err <= '1';
				end if;
		else
					data_valid <= '0';
					err <= '1';
		end if;
end if;
end process;
end behav;