-- Brayden Cowell - 0844864
-- Feb. 19, 2016 
-- Sudoku Solver implemented in Ada

with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
with header; use header;

procedure Solver is

	puzzle : puzzle_type;
	
	x, y : Integer;
	
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
	solve(puzzle);
	
	-- Print it out the solved puzzle.
	put_line("Solved Puzzle: ");
	print_board(puzzle);
	new_line;

	-- Output solved puzzle to file.		

end Solver;
