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
	
	possibles : puzzle_array_type := (1..9 => (1..9 => (1..9 => 0)));
	temp_grid : grid_type := (1..3 => (1..3 => 0));
	temp_puzzle : puzzle_type;
	puzzle : puzzle_Type;
	
	puzzle_conflict : Boolean := FALSE;
	check_grid : Boolean := FALSE;
	check_puzzle : Boolean := FALSE;
	x,y,n,m,s : Integer;
	posX, posY : Integer;
	
	filename: string(1..50);
	last: natural;
	input_file : File_Type;
	line : String(1..81);
	temp_line : String (1..9);
	
	
	begin
	
	-- Read unsolved puzzle from file.
	put_line("Enter an input filename:");
	get_line(filename,last);
	open(input_file, in_file, filename(1..last));
	
	while not End_OF_File (Input_File) loop
		-- Read the puzzle in as a string.
		Get(Input_File, line);
		Put_line(line);
		
		posX := 1;
		posY := 9;
		-- Seperate the whole string into 9 character stings
		for i in 1..9 loop
			--put_line(line((posX)..(posY)));
			temp_line := line(posX .. posY);
			-- Now seperate the 9-char strings into individual chars
			for j in 1..9 loop
				-- And assign each number to its possition in the 9x9 puzzle.
				-- put(character'Pos(temp_line(j)) - 48);
				puzzle(i,j) := character'Pos(temp_line(j)) - 48; -- It's ASCII so subtract the code for 0 (48).
			end loop;
			posX := posX + 9;
			posY := posY + 9;
		end loop;
		New_Line;
	end loop;
	close(input_file); 
	
	temp_puzzle := puzzle;
	
	-- Print it out the unsolved puzzle.
	put_line("Unsolved Puzzle: ");
	print_board(puzzle);
	new_line;

	x := 0;
	y := 0;
	
	-- Go through each grid 
	-- Calculate possibilites
	loop
		for b in 1..9 loop
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
			
			-- Now we have the possibilites from any square.
			-- Let's narrow each one down.
			for i in 1..3 loop
				for j in 1..3 loop
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
					
				 -- If we have no value given, narrow its possibilites.
					if (temp_grid(i,j) = 0) then
						for k in 1..9 loop
							puzzle_conflict := FALSE;
							if (values(k) /= 0) then
								puzzle_conflict := check(values(k), temp_puzzle, x+i, y+j);
								-- Also check for numbers of the same value in the current grid.
								for u in 1..3 loop
									for d in 1..3 loop
										if (values(k) = temp_grid(u,d)) then
											puzzle_conflict := TRUE;
										end if;
									end loop;
								end loop;
								if (puzzle_conflict = TRUE) then
									values(k) := 0;
								end if;
							end if;
							possibles(x+i, y+j) := values;
						end loop;
					end if;
					values := possible(knowns);
				end loop;
			end loop;

			n := 1;
			-- Get the known values already in the 3x3 grid
			for o in 1..3 loop
				for p in 1..3 loop
					case temp_grid(o,p) is 
						when 0 => null;
						when others => knowns(n) := temp_grid(o,p); -- Copy the know values into an array for later
					end case;
					n := n+1;
				end loop;
			end loop;
			
			values := possible(knowns);

			s := 0;
			m := 1;
			
			-- If there is only one possible number, fill it in.
			for i in 1..3 loop
				for j in 1..3 loop
					temp_array := possibles(x+i, y+j);
					for k in 1..9 loop
						if (temp_array(k) /= 0) then
							s := s + 1;
						end if;
					end loop;
					-- If a possible number is the only value and is in a possible value move it to the front
					if (s = 1) then
						for h in 1..9 loop
							if (temp_array(h) /= 0) then
								temp_grid(i,j) := temp_array(h);
								temp_puzzle(x+i, y+j) := temp_array(h);
								puzzle(x+i, y+j) := temp_array(h);
								
								temp_array(h) := 0;
								possibles(x+i, y+j) := temp_array;
							end if;
						end loop;

					end if;
					-- Save the number of possibilites of each point, so we can pick the minimum later.
					possibilites(m) := s;
					s := 0;
					m := m + 1;
				end loop;
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
	
	puzzle := temp_puzzle;
	
	-- Print puzzle and possibilites
	put_line("Puzzle: ");
	print_board(temp_puzzle);
	new_line;
	
	temp_puzzle := puzzle; -- Copy original
	-- Start from top left grid (nx = 1, ny = 1)
	solve(temp_puzzle);
	
	-- Print it out the solved puzzle.
	put_line("Solved Puzzle: ");
	print_board(temp_puzzle);
	new_line;		

end Solver;
