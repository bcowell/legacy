with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
package body header is
	
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
