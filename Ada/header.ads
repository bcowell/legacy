package header is
	type puzzle_type is array (1..9, 1..9) of Integer;
	
	procedure Print_Board (puzzle : in puzzle_type);
end header;
