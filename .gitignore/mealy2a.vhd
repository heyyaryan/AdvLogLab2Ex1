library ieee;
use ieee.std_logic_1164.all;

entity mealy2a is

	port
	(
		clk		: in	std_logic;
		data_in	: in	std_logic;
		reset		: in	std_logic;
		data_out 	: out	std_logic_vector(1 downto 0)
	);
	
end mealy2a;

architecture rtl of mealy2a is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3);
	
	-- Register to hold the current state
	signal state : state_type;
	signal clk_1hz : std_logic:= '0';
begin
	process(clk)
		variable counter : integer := 0;
		variable edge_toggle : std_logic := '0';
		begin
			if (rising_edge(clk)) then
				counter := counter + 1;
				if (counter = 25000000) then
					edge_toggle := not edge_toggle;
					counter := 0;
				end if;
			end if;
			clk_1hz <= edge_toggle;
	end process;
		
					
	process (clk_1hz, reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk_1hz)) then
			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when s0=>
					if data_in = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					if data_in = '1' then
						state <= s2;
					else
						state <= s1;
					end if;
				when s2=>
					if data_in = '1' then
						state <= s3;
					else
						state <= s2;
					end if;
				when s3=>
					if data_in = '1' then
						state <= s3;
					else
						state <= s1;
					end if;
			end case;
			
		end if;
	end process;
	

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).

	process (state, data_in)
	begin
		case state is
			when s0=>
				if data_in = '1' then
					data_out <= "00";
				else
					data_out <= "01";
				end if;
			when s1=>
				if data_in = '1' then
					data_out <= "01";
				else
					data_out <= "11";
				end if;
			when s2=>
				if data_in = '1' then
					data_out <= "10";
				else
					data_out <= "10";
				end if;
			when s3=>
				if data_in = '1' then
					data_out <= "11";
				else
					data_out <= "10";
				end if;
		end case;
	end process;
	
end rtl;
