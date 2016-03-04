package header is

	type pos_t is record
		Row    : Positive;
		Col : Positive;
	end record;
	
	type puzzle_type is array (1..9, 1..9) of Integer;
	
	procedure Print_Board (puzzle : in puzzle_type);
	function Insert (current : pos_t) return Boolean;
	function check (current : pos_t; num : Integer) return Boolean;
	function Next_Pos (current : pos_t) return pos_t;
	procedure solve (puzzle : in out puzzle_type; finished : in out Boolean);
	
end header;
