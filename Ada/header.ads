package header is
	type array_type is array (1..9) of Integer;
	subtype num_range is Integer range 1..9;
	type puzzle_type is array (1..9, 1..9) of Integer;
	type puzzle_array_type is array (1..9, 1..9) of array_type; -- Create a 3x3 grid able to store an array of 9 possibilites
	type grid_type is array (1..3, 1..3) of Integer;

	procedure solve (puzzle : in out puzzle_type);
	function grid_checked (puzzle : in puzzle_type) return Boolean;
	function puzzle_checked (puzzle : in puzzle_type) return Boolean;
	function check (num : in Integer; puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean;
	function possible (knowns : in array_type) return array_type;
	procedure Print_Board (puzzle : in puzzle_type);
end header;
