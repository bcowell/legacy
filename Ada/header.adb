with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
package body header is
	
	values : array_type := (1..9 => 0);
	known_value : Boolean;

	-- Solve
	-- Start at the top-left grid and assign a possible value to a square.
	procedure solve(puzzle : in out puzzle_type) is
		solved : Boolean := FALSE;
		
		-- Try all possible values for given cell and continue with next cell.
		procedure brute_force(x : in num_range; y : in num_range) is
			nx : num_range := x;
			ny : num_range := y;
			last : Boolean := FALSE;
		begin
			-- determine if this is the last cell or else the next cell coordinates
			if (x = puzzle'Last(1) and then y = puzzle'Last(2)) then
				Last := True;
			elsif x = puzzle'Last(1) then
				nx := puzzle'First (1);
				ny := y + 1;
			else
				nx := x + 1;
			end if;
			
			-- only need to try values for nonvalid cell entries (0)
			if (puzzle(x,y) = 0) then
				-- try all possible values
				for k in 1..9 loop
					puzzle(x,y) := k;
			   
					if (puzzle_checked(puzzle)) then
						-- the last cell was processed and lead to a valid sudoku
						-- this means all cells have valid entries -> solved.
						if Last then
							Solved := True;
							return;
						else
							-- try next cells
							brute_force(nx,ny);
							-- if we have a solved sudoku, exit procedure.
							if Solved then
								return;
							end if;
						end if;
					end if;
			   
				-- reset the cell, it will be tried later again
				puzzle(x,y) := 0;
				end loop;
			
			elsif Last then
				-- last cell, already valid, it is solved and there is nothing to do
				Solved := True;
			else
				-- this cell already has a value, continue to next
				brute_force(nx,ny);
			end if;
		end brute_force;
		
	begin
		-- only accept valid puzzle inputs
		--if not puzzle_checked(puzzle) then
			--raise Constraint_Error;
		--end if;
		
		-- start with first cell
		brute_force(puzzle'First(1),puzzle'First(1));
		-- tried all combinations without success -> unsolvable.
		
		if not Solved then
			put_line("The puzzle is unsolvable!");
			new_line;
		end if;
	end Solve;


	-- Grid_checked
	-- Go through each grid to make sure none have more than one of the same value
	-- Returns FALSE if an incorrect value is found, TRUE otherwise
	function grid_checked (puzzle : in puzzle_type) return Boolean is
		temp_grid : grid_type;
		x,y,n: integer := 0;
	begin
		loop
			-- Get the values already in the current grid.
			for i in 1..3 loop
				for j in 1..3 loop
					temp_grid(i,j) := puzzle(x+i, y+j);
					if (temp_grid(i,j) /= 0) then
						n := 0;
						for k in 1..3 loop
							for h in 1..3 loop
								if (temp_grid(i,j) = temp_grid(k, h)) then
									n := n + 1;
								end if;
							end loop;
						end loop;
						if (n > 1) then
							return FALSE;
						end if;
					end if;
				end loop;
			end loop;
			
			
			if ((x = 0) and (y = 0)) then
			x := 3;
			elsif ((x = 3) and (y = 0)) then
				x := 6;
			elsif ((x = 6) and (y = 0)) then
				x := 0;
				y := 3;
			elsif ((x = 0) and (y = 3)) then
				x := 3;
			elsif ((x = 3) and (y = 3)) then
				x := 6;
			elsif ((x = 6) and (y = 3)) then
				x := 0;
				y := 6;
			elsif ((x = 0) and (y = 6)) then
				x := 3;
			elsif ((x = 3) and (y = 6)) then
				x := 6;
			elsif ((x = 6) and (y = 6)) then
				x := 9;
				y := 9;
			end if;
			exit when (x = 9 and y = 9);
		end loop;
		return TRUE;
	end grid_checked;

	-- Puzzle_checked
	-- Go through a 3x3 grid and see if its "solved" (i.e. One value filled in each square).
	-- Make sure there's only one element in the array of possibilites of each point
	-- Returns TRUE on solved, FALSE otherwise
	function puzzle_checked (puzzle : in puzzle_type) return Boolean is
		temp_value : Integer; 
		solved : Boolean := FALSE;
	begin
		for i in 1..9 loop
			for j in 1..9 loop
				temp_value := puzzle(i,j);
				solved := check(temp_value, puzzle, i, j);
			end loop;
		end loop;
		return solved;
	end puzzle_checked;
	
	
	-- Check 
    -- See if value has a conflict with rest of the numbers in its column and row
    -- Check if number is in same col or row of puzzle
    -- Return FALSE on conflict, TRUE otherwise
    function check (num : in Integer; puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean is
    n : integer := 0;
    valid : Boolean := FALSE;
    begin
		-- Go through rows of puzzle sharing PosY
		for i in 1..9 loop
			if (num = puzzle(i, posY)) then
				return FALSE;
			end if;
		end loop;
		
		-- Go through cols of puzzle sharing PosX
		for j in 1..9 loop
			if (num = puzzle(posX, j)) then
				return FALSE;
			end if;
		end loop;
		
		valid := grid_checked (puzzle);
		if (valid = FALSE) then
			return FALSE;
		end if;
		
        return TRUE;
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
	
	
	-- Print the puzzle in specified format
	procedure Print_Board (puzzle : in puzzle_type) is
    begin
		put ("-------------------------------");
		new_line;
		put_line("|" & Integer'Image(puzzle(1,1)) & " " & Integer'Image(puzzle(1,2)) & " " & Integer'Image(puzzle(1,3)) & " |" & Integer'Image(puzzle(1,4)) & " " & Integer'Image(puzzle(1,5)) & " " & Integer'Image(puzzle(1,6)) & " |" & Integer'Image(puzzle(1,7)) & " " & Integer'Image(puzzle(1,8)) & " " & Integer'Image(puzzle(1,9)) & " |");
		put_line("|" & Integer'Image(puzzle(2,1)) & " " & Integer'Image(puzzle(2,2)) & " " & Integer'Image(puzzle(2,3)) & " |" & Integer'Image(puzzle(2,4)) & " " & Integer'Image(puzzle(2,5)) & " " & Integer'Image(puzzle(2,6)) & " |" & Integer'Image(puzzle(2,7)) & " " & Integer'Image(puzzle(2,8)) & " " & Integer'Image(puzzle(2,9)) & " |");
		put_line("|" & Integer'Image(puzzle(3,1)) & " " & Integer'Image(puzzle(3,2)) & " " & Integer'Image(puzzle(3,3)) & " |" & Integer'Image(puzzle(3,4)) & " " & Integer'Image(puzzle(3,5)) & " " & Integer'Image(puzzle(3,6)) & " |" & Integer'Image(puzzle(3,7)) & " " & Integer'Image(puzzle(3,8)) & " " & Integer'Image(puzzle(3,9)) & " |");

		put ("-------------------------------");
		new_line;
		
		put_line("|" & Integer'Image(puzzle(4,1)) & " " & Integer'Image(puzzle(4,2)) & " " & Integer'Image(puzzle(4,3)) & " |" & Integer'Image(puzzle(4,4)) & " " & Integer'Image(puzzle(4,5)) & " " & Integer'Image(puzzle(4,6)) & " |" & Integer'Image(puzzle(4,7)) & " " & Integer'Image(puzzle(4,8)) & " " & Integer'Image(puzzle(4,9)) & " |");
		put_line("|" & Integer'Image(puzzle(5,1)) & " " & Integer'Image(puzzle(5,2)) & " " & Integer'Image(puzzle(5,3)) & " |" & Integer'Image(puzzle(5,4)) & " " & Integer'Image(puzzle(5,5)) & " " & Integer'Image(puzzle(5,6)) & " |" & Integer'Image(puzzle(5,7)) & " " & Integer'Image(puzzle(5,8)) & " " & Integer'Image(puzzle(5,9)) & " |");
		put_line("|" & Integer'Image(puzzle(6,1)) & " " & Integer'Image(puzzle(6,2)) & " " & Integer'Image(puzzle(6,3)) & " |" & Integer'Image(puzzle(6,4)) & " " & Integer'Image(puzzle(6,5)) & " " & Integer'Image(puzzle(6,6)) & " |" & Integer'Image(puzzle(6,7)) & " " & Integer'Image(puzzle(6,8)) & " " & Integer'Image(puzzle(6,9)) & " |");

		put ("-------------------------------");
		new_line;
		
		put_line("|" & Integer'Image(puzzle(7,1)) & " " & Integer'Image(puzzle(7,2)) & " " & Integer'Image(puzzle(7,3)) & " |" & Integer'Image(puzzle(7,4)) & " " & Integer'Image(puzzle(7,5)) & " " & Integer'Image(puzzle(7,6)) & " |" & Integer'Image(puzzle(7,7)) & " " & Integer'Image(puzzle(7,8)) & " " & Integer'Image(puzzle(7,9)) & " |");
		put_line("|" & Integer'Image(puzzle(8,1)) & " " & Integer'Image(puzzle(8,2)) & " " & Integer'Image(puzzle(8,3)) & " |" & Integer'Image(puzzle(8,4)) & " " & Integer'Image(puzzle(8,5)) & " " & Integer'Image(puzzle(8,6)) & " |" & Integer'Image(puzzle(8,7)) & " " & Integer'Image(puzzle(8,8)) & " " & Integer'Image(puzzle(8,9)) & " |");
		put_line("|" & Integer'Image(puzzle(9,1)) & " " & Integer'Image(puzzle(9,2)) & " " & Integer'Image(puzzle(9,3)) & " |" & Integer'Image(puzzle(9,4)) & " " & Integer'Image(puzzle(9,5)) & " " & Integer'Image(puzzle(9,6)) & " |" & Integer'Image(puzzle(9,7)) & " " & Integer'Image(puzzle(9,8)) & " " & Integer'Image(puzzle(9,9)) & " |");
		
		put ("-------------------------------");
		new_line;
		
   end Print_Board;
	
	
end header;
