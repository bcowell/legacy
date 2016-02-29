-- Brayden Cowell - 0844864
-- Feb. 19, 2016 
-- Sudoku Solver implemented in Ada

with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;

procedure Solver is

	type array_type is array (1..9) of Integer;
	type puzzle_type is array (1..9, 1..9) of Integer;
	type grid_array_type is array (1..3, 1..3) of array_type; -- Create a 3x3 grid able to store an array of 9 possibilites
	type grid_type is array (1..3, 1..3) of Integer;

	knowns : array_type := (1..9 => 0);
	values : array_type := (1..9 => 0);
	possibilites : array_type := (1..9 => 0);
	temp_array : array_type := (1..9 => 0);
	
	grid : grid_array_type := (1..3 => (1..3 => (1..9 => 0)));
	temp_grid : grid_type := (1..3 => (1..3 => 0));
	puzzle : puzzle_Type := (
	(0,0,0, 2,6,0, 7,0,1),
	(6,8,0, 0,7,0, 0,9,0),
	(1,9,0, 0,0,4, 5,0,0),
	(8,2,0, 1,0,0, 0,4,0),
	(0,0,4, 6,0,2, 9,0,0),
	(0,5,0, 0,0,3, 0,2,8),
	(0,0,9, 3,0,0, 0,7,4),
	(0,4,0, 0,5,0, 0,3,6),
	(7,0,3, 0,1,8, 0,0,0));
	
	known_value : Boolean;
	puzzle_conflict : Boolean;
	check_grid : Boolean;
	
	temp_value : Integer;
	x,y,n,m,t : Integer;


	-- Solved_check
	-- Go through a 3x3 grid and see if its "solved" (i.e. One value filled in each square).
	-- Returns TRUE on solved, FALSE otherwise
	function grid_checked (grid : in grid_array_type; puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean is
		n : Integer;
	begin
		for i in 1..3 loop
			for j in 1..3 loop
				-- Make sure there's only one element in the array of possibilites of each point
				n := 0;
				for k in 1..9 loop
					if (values(k) /= 0) then
						n := n + 1;
					end if;
				end loop;
				if (n > 1) then
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
			-- If the number is not in the grid, store all possible values as a string.
				values(k) := k;
			end if;
			
			known_value := FALSE; -- Reset to check if the next number is already in the 3x3 grid
		end loop;
		return values;
	end possible;

	
	begin
	
	-- Read from file and fill in know values.
	-- filename: string(1..50);
	-- last: natural;
	-- get_line(filename,last);
	--open(infp,in_file,fileN(1..last));
	
	
	-- Print it out the unsolved puzzle.
	-- for i in 1..9 loop
		-- for j in 1..9 loop
			-- put(puzzle (i,j));
		-- end loop;
		-- new_line;
	-- end loop;
	-- new_line;

	x := 0;
	y := 0;
	n := 1;
	
	-- Search
	-- DFS look through all possible values of each square in the grid and try them all out
	loop -- while (grid has > 1 value)
			-- Calculate all possible values of each square
	
		-- Get the known values already in the 3x3 grid
		for i in 1..3 loop
			for j in 1..3 loop
				case puzzle(x+i, y+j) is 
					when 0 => null;
					when others => knowns(n) := puzzle(x+i, y+j); -- Copy the know values into an array for later
				end case;
				n := n+1;
			end loop;
		end loop;
		
		-- Calculate all the possibilites of each point of the 3x3 grid
		-- Not taking into account any conflicts in same rows or cols yet.
		values := possible(knowns);
		
		-- Narrow down possibilities even more by checking if there are any conflicts in cols / rows of the entire puzzle
		for i in 1..3 loop
			for j in 1..3 loop
				if (puzzle(x+i, y+j) = 0) then
					for k in 1..9 loop
						puzzle_conflict := FALSE;
						if (values(k) /= 0) then
							puzzle_conflict := check(values(k), puzzle, x+i, y+j);
							-- Returns FALSE on conflicts
							if (puzzle_conflict = TRUE) then
								values(k) := 0;
							end if;
						end if;
					end loop;
					grid(i,j) := values;
				else -- Already filled in puzzle, put in first position of the array at the point
					temp_array(1) := puzzle(x+i, y+j);
					grid(i,j) := temp_array;
					temp_grid(i,j) := temp_array(1);
				end if;
				values := possible(knowns);
			end loop;
		end loop;
		
		n := 0;
		m := 1;
		
		-- If there is only one possible number, fill it in.
		for i in 1..3 loop
			for j in 1..3 loop
				temp_array := grid(i,j);
				for k in 1..9 loop
					if (temp_array(k) /= 0) then
						n := n + 1;
					end if;
				end loop;
				-- If a possible number is the only value and is in a possible value move it to the front
				if (n = 1) then
					for h in 2..9 loop
						if (temp_array(h) /= 0) then
							temp_array(1) := temp_array(h);
							temp_array(h) := 0;
							grid(x+i, y+j) := temp_array;
							temp_grid(x+i, y+j) := temp_array(1);
						end if;
					end loop;
				end if;
				-- Save the number of possibilites of each point, so we can pick the minimum later.
				possibilites(m) := n;
				n := 0;
				m := m + 1;
			end loop;
		end loop;
		
		-- Now we have a 3x3 array with each point being an array of possible solutions
		-- Points with one solution are an array of 1..9 with the first filled and the rest 0.

		-- Choose an empty square with the least possibilities
		-- Go through the possibilites and find the smallest
		m := 9;
		t := 0;
		for k in 1..9 loop
			if ((possibilites(k) /= 1) and (m > possibilites(k))) then
				m := possibilites(k);
			end if;
		end loop;
		-- Find the first instance of the smallest possibility.
		for k in 1..9 loop
			if (possibilites(k) = m) then
				t := k;
			end if;
		end loop;
		
		-- pick a value for the current square
		m := 1;
		for i in 1..3 loop
			for j in 1..3 loop
				if (t = m) then -- Found the minimum to start testing.
					-- Go through its possible values and pick one
					temp_array := grid(x+i, y+j);
					for k in 1..9 loop
						if (temp_array(k) /= 0) then
							temp_value := temp_array(k); -- Grab a possible value
							temp_grid(x+i, y+j) := temp_value; -- Add it into place in a temp_grid
						end if;
					end loop;
				end if;
				m := m + 1;
			end loop;
		end loop;
		
		
		for i in 1..3 loop
			for j in 1..3 loop
				put(temp_grid(x+i, y+j));
			end loop;
			new_line;
		end loop;
		new_line;
		new_line;
		
		-- check if the chosen value is fine
		
			-- if false; remove failed value from spot
			-- if true; update grid with newfound value
		check_grid := grid_checked(grid, puzzle, x, y);
		exit when check_grid = TRUE;
	end loop;
   
   
	-- Print out solved puzzle
	-- for i in 1..9 loop
		-- for j in 1..9 loop
			-- put(puzzle (i,j));
		-- end loop;
		-- new_line;
	-- end loop;
	
end Solver;
