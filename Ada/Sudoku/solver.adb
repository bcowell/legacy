-- Brayden Cowell - 0844864
-- Feb. 19, 2016 
-- Sudoku Solver implemented in Ada

with Ada.Text_IO; use Ada.Text_IO;
with header; use header;

procedure Solver is

	puzzle : puzzle_type;
	
	x, y : Integer;
	
	finished : Boolean := FALSE;
	filename_in, filename_out: string(1..50);
	last1, last2: natural;
	input_file, output_file : File_Type;
	line : String(1..81);
	temp_line : String (1..9);
	
	
	begin
	
	-- Read unsolved puzzle from file.
	loop
		begin
			put_line("Enter an input filename:");
			get_line(filename_in,last1);
			put_line("And enter an output filename:");
			get_line(filename_out, last2);
		
			open(input_file, in_file, filename_in(1..last1));
			
			exit;
		exception
			when Name_Error => put_line("Invalid filename!");
		end;
	end loop;
	while not End_OF_File (Input_File) loop
		-- Read the puzzle in as a string.
		Get(Input_File, line);
		Put_line(line);
		
		x := 1;
		y := 9;
		-- Seperate the whole file into 9 character strings
		for i in 1..9 loop
			temp_line := line(x..y);
			-- Now seperate the 9-char strings into individual chars
			for j in 1..9 loop
				-- And assign each number to its possition in the 9x9 puzzle.
				puzzle(i,j) := character'Pos(temp_line(j)) - 48; -- It's ASCII so subtract the code for 0 (48).
			end loop;
			x := x + 9;
			y := y + 9;
		end loop;
	end loop;
	close(input_file); 
	
	-- Print it out the unsolved puzzle.
	put_line("Unsolved Puzzle: ");
	print_board(puzzle);
	new_line;

	-- Brute force the puzzle.
	solve(puzzle, finished);
	
	if (finished) then
		-- Print it out the solved puzzle.
		put_line("Solved Puzzle: ");
		print_board(puzzle);
		new_line;

		-- Output solved puzzle to file.			
		Create (output_File, Out_File, filename_out);
	
		Set_Output(output_File);
		print_board(puzzle);
		Close (output_file); 
		Set_Output(Standard_Output);
	else
		put_line("Sudoku puzzle has no solution! Did not print output to file!");
	end if;
end Solver;
