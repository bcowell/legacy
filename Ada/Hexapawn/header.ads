-- Brayden Cowell - 0844864
-- Mar. 13, 2016 
-- Hexapawn implemented in Ada

package header is
	
	Exit_Program, Game_over : exception;
	
	type pos_t is record
		Row    : Positive;
		Col : Positive;
	end record;
	
	type board_type is array (1..3, 1..3) of Character;
	
	-- Introduction
	procedure Print_Board (board : in board_type);
	procedure Show_Instructions (board : in board_type);

	-- Game modules
	procedure place (x,y : in Integer; 	board : in out board_type; 	player_control : in Boolean; valid_move : out Boolean);
	function check_forward (x,y : Integer; 	board : board_type; 		player_control : Boolean) return Boolean;
	function check_diag (x,y : Integer; 	board : board_type; 		player_control : Boolean) return Boolean;
	procedure move (x,y : in Integer; 	board : in out board_type);
	procedure Get_Pos (x,y : in Integer; 	current, next : out pos_t);
	function Win_State (board : in board_type) return Boolean;
	
end header;
