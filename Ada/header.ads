package header is
	type array_type is array (1..9) of Integer;
	type puzzle_type is array (1..9, 1..9) of Integer;
	type grid_array_type is array (1..3, 1..3) of array_type; -- Create a 3x3 grid able to store an array of 9 possibilites
	type grid_type is array (1..3, 1..3) of Integer;
	
	procedure choose_value(grid : in out grid_array_type; temp_grid : in out grid_type; temp_puzzle : in out puzzle_type; knowns : in array_type; posX : in Integer; posY : in Integer; t : in Integer);
	function puzzle_checked (puzzle : in puzzle_type) return Boolean;
	function grid_checked (puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean;
	function check (num : in Integer; puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean;
	function possible (knowns : in array_type) return array_type;
end header;
