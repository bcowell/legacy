with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
package body header is
	
	values : array_type := (1..9 => 0);
	known_value : Boolean;

	m : Integer;
	
	-- Choose value
	-- Find the square with the smallest possibilities
	-- Then choose a random value from its possibilites and test it
	procedure choose_value(grid : in out grid_array_type; temp_grid : in out grid_type; temp_puzzle : in out puzzle_type; knowns : in array_type; posX : in Integer; posY : in Integer; t : in Integer) is
	temp_array : array_type;
	temp_value : Integer;
	puzzle_conflict : Boolean;
	begin
		m := 1;
		for i in 1..3 loop
			for j in 1..3 loop
				if (t = m) then -- Found the minimum to start testing.
					-- Go through its possible values and pick one
					temp_array := grid(i,j);
					for k in 1..9 loop
						if (temp_array(k) /= 0) then
							-- Make sure the possible value is not already in the grid
							for w in 1..9 loop
								if (temp_array(k) = knowns(w)) then
									temp_array(k) := 0; -- Remove the possible value
									grid(i,j) := temp_array;
								end if;
							end loop;
							temp_value := temp_array(k); -- Grab a possible value
							puzzle_conflict := check(temp_value, temp_puzzle, posX+i, posY+j);
							if (puzzle_conflict = FALSE) then
								temp_grid(i,j) := temp_value;
								temp_puzzle(posX+i, posY+j) := temp_value;
							elsif (puzzle_conflict = TRUE) then
								temp_array(k) := 0; -- Remove the possible value
								grid(i,j) := temp_array;
							end if;
						end if;
					end loop;
				end if;
				m := m + 1;
			end loop;
		end loop;
	end choose_value;


	-- Puzzle_checked
	-- Go through a 3x3 grid and see if its "solved" (i.e. One value filled in each square).
	-- Make sure there's only one element in the array of possibilites of each point
	-- Returns TRUE on solved, FALSE otherwise
	function puzzle_checked (puzzle : in puzzle_type) return Boolean is
		n : Integer;
	begin
		for i in 1..9 loop
			for j in 1..9 loop
				if (puzzle(i, j) = 0) then
					return FALSE;
				end if;
			end loop;
		end loop;
		return TRUE;
	end puzzle_checked;


	-- grid_checked
	-- Go through a 3x3 grid and see if its "solved" (i.e. One value filled in each square).
	-- Make sure there's only one element in the array of possibilites of each point
	-- Returns TRUE on solved, FALSE otherwise
	function grid_checked (puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean is
		n : Integer;
	begin
		n := 0;
		for i in 1..3 loop
			for j in 1..3 loop
				if (puzzle(posX+i, posY+j) = 0) then
					return FALSE;
				end if;
			end loop;
		end loop;
		return TRUE;
	end grid_checked;
	
	
	-- Check 
    -- See if value has a conflict with rest of the numbers in its column and row
    -- Check if number is in same col or row of puzzle
    -- Return TRUE on conflict, FALSE otherwise
    function check (num : in Integer; puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean is
    begin
		-- Go through rows of puzzle sharing PosY
		for i in 1..9 loop
			if (num = puzzle(i, posY)) then
				return TRUE;
			end if;
		end loop;
		
		-- Go through cols of puzzle sharing PosX
		for j in 1..9 loop
			if (num = puzzle(posX, j)) then
				return TRUE;
			end if;
		end loop;
		
        return FALSE;
    end check;
   
    
	-- Get all the possibilities for each square in the 3x3 grid
	-- Possible values include those not in the current grid (Can't be in known)
	function possible (knowns : in array_type) return array_type is
	begin
		for k in 1..9 loop -- Go through all the possible numbers
			for m in 1..9 loop -- If the possible number is in the grid
				if (k = knowns(m)) then
					known_value := TRUE; -- Found a number that was already in the 3x3 grid.
				end if;
			end loop;
			
			if (known_value = FALSE) then 
			-- If the number is not in the grid, store all possible values.
				values(k) := k;
			end if;
			
			known_value := FALSE; -- Reset to check if the next number is already in the 3x3 grid
		end loop;
		return values;
	end possible;
	
end header;
