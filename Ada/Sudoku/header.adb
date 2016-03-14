With Ada.Text_IO; use Ada.Text_IO;

package body header is

	temp_puzzle : puzzle_type;
	
	--------------------------------------------------------------------
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
	--------------------------------------------------------------------
	
	
	--------------------------------------------------------------------
	-- Brute-Force insertion of empty squares until finished.
	function Insert (current : pos_t) return Boolean is
	begin
	
		-- Check if were done puzzle
		if ((current.row > 9) or (current.col > 9)) then
			return TRUE;
		end if;
		
		-- If the number is already filled, move to the next.
		if (temp_puzzle(current.row, current.col) /= 0) then
			-- Recall with the next position.
			return (Insert(next_pos(current)));
		end if;
	
		-- Brute force
		for i in 1..9 loop
			-- If the number at position doesn't cause an error.
			if (check(current, i)) then
				-- put_line("Insert " & integer'image(i) & " at " & integer'image(current.row) & integer'image(current.col));
				-- new_line;
				temp_puzzle(current.row, current.col) := i; -- Fill the number in.
				-- Recursively call until the puzzle is solved.
				if (Insert(next_pos(current))) then
					return TRUE;
				end if;
			end if;
		end loop;
		
		temp_puzzle(current.row, current.col) := 0;
		return FALSE;	
	end Insert;
	--------------------------------------------------------------------

	
	--------------------------------------------------------------------
	-- Check
	-- Look for conflicts in either the current 3x3 or in the same col/row 
	-- return FALSE on conflict, otherwise return TRUE
	function check (current : pos_t; num : Integer) return Boolean is
		x, y : Integer := 0;
	begin
		-- Look through the 3x3 grid
			x := ((current.row - 1) / 3) * 3;
			y := ((current.col - 1) / 3) * 3;
			for i in 1..3 loop
				for j in 1..3 loop
					if (num = temp_puzzle(x+i, y+j)) then
						return FALSE;
					end if;
				end loop;
			end loop;			

		-- Go through rows and check for same number
 		for i in 1..9 loop
 			if (num = temp_puzzle(i, current.col)) then
				return FALSE;
 			end if;
 		end loop;
 		
 		-- Go through cols and check for same number 
 		for j in 1..9 loop
 			if (num = temp_puzzle(current.row, j)) then
				return FALSE;
 			end if;
 		end loop;
 		
 		return TRUE;
	end check;
	--------------------------------------------------------------------
	
	
	--------------------------------------------------------------------
	-- Move to the next square in the puzzle.
	function Next_Pos (current : pos_t) return pos_t is
		next : pos_t := current;
	begin
		-- Move to next square in the same row
		if next.Row < 9 then
			next.Row := next.Row + 1;
		else -- If we are at the end of the row, move to the first row of the next col.
			next.Row := 1;
			next.Col := next.Col + 1;
		end if;
		return next;
	end Next_Pos;
	--------------------------------------------------------------------

	
	--------------------------------------------------------------------
	-- Start the brute-force, every insert() calls check before placing the correct number into the puzzle.
	procedure solve (puzzle : in out puzzle_type; finished : in out Boolean) is
		current : pos_t;
	begin
		temp_puzzle := puzzle; -- Make a duplicate copy of the puzzle
		current.row := 1; current.col := 1; -- Start at the very top-left.
		
		finished := insert(current);
		puzzle := temp_puzzle;
	end solve;
	--------------------------------------------------------------------

end header;
