-- Brayden Cowell - 0844864
-- Feb. 19, 2016 
-- Sudoku Solver implemented in Ada

with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
with header; use header;


procedure Solver is

	knowns : array_type := (1..9 => 0);
	values : array_type := (1..9 => 0);
	possibilites : array_type := (1..9 => 0);
	temp_array : array_type := (1..9 => 0);
	
	grid : grid_array_type := (1..3 => (1..3 => (1..9 => 0)));
	temp_grid : grid_type := (1..3 => (1..3 => 0));
	temp_puzzle : puzzle_type;
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
	
	puzzle_conflict : Boolean := FALSE;
	check_grid : Boolean := FALSE;
	check_puzzle : Boolean := FALSE;
	x,y,n,m : Integer;

	
	begin
	
	-- Read from file and fill in know values.
	-- filename: string(1..50);
	-- last: natural;
	-- get_line(filename,last);
	--open(infp,in_file,fileN(1..last));
	
	temp_puzzle := puzzle;
	
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
	
	while check_puzzle = FALSE loop
	
		check_grid := FALSE;
	
		for i in 1..3 loop
			for j in 1..3 loop
				temp_grid(i,j) := temp_puzzle(x+i, y+j);
			end loop;
		end loop;
		
		n := 1;
		-- Get the known values already in the 3x3 grid
		for i in 1..3 loop
			for j in 1..3 loop
				case temp_grid(i,j) is 
					when 0 => null;
					when others => knowns(n) := temp_grid(i,j); -- Copy the know values into an array for later
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
				if (temp_grid(i,j) = 0) then
					for k in 1..9 loop
						puzzle_conflict := FALSE;
						if (values(k) /= 0) then
							puzzle_conflict := check(values(k), temp_puzzle, x+i, y+j);
							-- Returns FALSE on conflicts
							if (puzzle_conflict = TRUE) then
								values(k) := 0;
							end if;
						end if;
					end loop;
					grid(i,j) := values;
				else -- Already filled in puzzle, put in first position of the array at the point
					temp_array(1) := temp_puzzle(x+i, y+j);
					grid(i,j) := temp_array;
					temp_grid(i,j) := temp_array(1);
				end if;
				values := possible(knowns);
			end loop;
		end loop;
		
		
		-- Assign possible values for a grid.
		-- DFS look through all possible values of each square in the grid and try them all out
		while check_grid = FALSE loop
		
			n := 1;
			-- Get the known values already in the 3x3 grid
			for i in 1..3 loop
				for j in 1..3 loop
					case temp_grid(i,j) is 
						when 0 => null;
						when others => knowns(n) := temp_grid(i,j); -- Copy the know values into an array for later
					end case;
					n := n+1;
				end loop;
			end loop;
			
			-- Calculate all the possibilites of each point of the 3x3 grid
			-- Not taking into account any conflicts in same rows or cols yet.
			values := possible(knowns);
		
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
								grid(i,j) := temp_array;
								
								temp_grid(i,j) := temp_array(1);
								
								temp_puzzle(x+i, y+j) := temp_array(1);
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
			for k in 1..9 loop
				if (possibilites(k) /= 1) then
					choose_value(grid, temp_grid, temp_puzzle, knowns, x, y, k);
				end if;
			end loop;
			
			-- check if the chosen value is fine
			
				-- if false; remove failed value from spot
				-- if true; update grid with newfound value
			
			-- Print it out the unsolved puzzle.
			for i in 1..9 loop
				for j in 1..9 loop
					put(temp_puzzle(i,j));
				end loop;
				new_line;
			end loop;
			new_line;		
			put(x);
			put(y);
			put_line("---------------------------------");
			check_grid := grid_checked(temp_puzzle, x, y);
		end loop;
		
		check_puzzle := puzzle_checked(temp_puzzle);
		
		--if ((x = 0) and (y = 0)) then
			--x := 3;
		--elsif ((x = 3) and (y = 0)) then
			--x := 6;
		--elsif ((x = 6) and (y = 0)) then
			--x := 0;
			--y := 3;
		--elsif ((x = 0) and (y = 3)) then
			--X := 3;
		--elsif ((x = 3) and (y = 3)) then
			--x := 6;
		--elsif ((x = 6) and (y = 3)) then
			--x := 0;
			--y := 6;
		--elsif ((x = 0) and (y = 6)) then
			--x := 3;
		--elsif ((x = 3) and (y = 6)) then
			--x := 6;
		--end if;

	end loop;

end Solver;
