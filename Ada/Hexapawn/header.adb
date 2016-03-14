-- Brayden Cowell - 0844864
-- Mar. 13, 2016 
-- Hexapawn implemented in Ada

With Ada.Text_IO; use Ada.Text_IO;
With Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body header is
	
	--------------------------------------------------------------------
	-- Print the current board in specified format.
	--------------------------------------------------------------------
	procedure Print_Board (board : in board_type) is
    begin
		new_line;
		put_line(board(1,1) & " " & board(1,2) & " " & board(1,3));
		put_line(board(2,1) & " " & board(2,2) & " " & board(2,3));
		put_line(board(3,1) & " " & board(3,2) & " " & board(3,3));
		new_line;
		
	end Print_Board;
	--------------------------------------------------------------------


	--------------------------------------------------------------------
	-- Print the instructions to Hexapawn.
	--------------------------------------------------------------------
	procedure Show_Instructions (board : in board_type) is
	begin
		put_line(" - INSTRUCTIONS OF HEXAPAWN - ");
		put_line("Your pawns are 'O', the computer's pawns are 'X', empty squares are '.'");
		put_line("Here is the inital board!");
		print_board(board);
		put_line("The numbering of the board is as follows");
		new_line;
		put_line("1 2 3");
		put_line("4 5 6");
		put_line("7 8 9");
		new_line;
		put_line("So if you wanted to move your rightmost pawn forward one square you would type: 9,6 in response to the question 'Your move?'.");
		put_line("Since I'm a good sport you'll always play first.");
		put_line("Begin!");
	
	end Show_Instructions;
	--------------------------------------------------------------------
	
	--------------------------------------------------------------------
	-- Get the x and y position of both the current and next move.
	--------------------------------------------------------------------
	procedure Get_Pos (x,y : in Integer; current, next : out pos_t) is
	begin
		-- Find the position of the first number
		current.row := Integer(Float'Ceiling(float(x) / 3.0));
		Case (x mod 3) is
			when 0 => current.col := 3;
			when others => current.col := x mod 3;
		end case;
					
		-- Find the position of the second number
		next.row := integer(Float'Ceiling(float(y) / 3.0));
		Case (y mod 3) is
			when 0 => next.col := 3;
			when others => next.col := y mod 3;
		end case;
		
	end Get_Pos;
	--------------------------------------------------------------------
	
	
	--------------------------------------------------------------------
	-- Move a pawn from current pos to next given pos.
	--------------------------------------------------------------------
	procedure move (x : Integer; y : Integer; board : in out board_type) is
		current, next : pos_t;
	begin
		get_pos(x,y,current,next);
		-- Update board
		board(next.row, next.col) := board(current.row, current.col);
		board(current.row, current.col) := '.';
	end move;
	--------------------------------------------------------------------
	
	
	--------------------------------------------------------------------
	-- Make sure that the supplied move is possible.
	--------------------------------------------------------------------
	function check_forward (x : Integer; y : Integer; board : board_type; player_control : Boolean) return Boolean is
		curr_char, next_char, temp_char : Character;
		current, next : pos_t; 
	begin
		get_pos(x,y,current,next);
		
		curr_char := board(current.row, current.col); -- Character in the current pos.
		next_char := board(next.row, next.col); -- Character in the next pos.
		
		-- Make sure you are trying to move your own pawn
		if (player_control) then
			if (curr_char /= 'O') then
				return FALSE;
			end if;
	
			-- Check if vertical upward is empty
			temp_char := board(current.row, current.col + 1);
			if (temp_char = '.')
				return TRUE;
			end if;
			
		else -- computer control
			if (curr_char /= 'X') then
				return FALSE;
			end if;
			
			-- Check if vertical downward is empty
			temp_char := board(current.row, current.col - 1);
			if (temp_char = '.')
				return TRUE;
			end if;
		end if;
		
		return TRUE;
	end check;
	--------------------------------------------------------------------


	--------------------------------------------------------------------
	-- Use the differences of the current and next pos to see what direction the control is trying.
	-- Then check if the movement is possible.
	-- If Player controlled (diff of rdiag = 2, forward = 3, ldiag = 4)
	-- If Computer controlled (diff of ldiag = 2, forward = 3, rdiag = 4)
	--------------------------------------------------------------------
	procedure place (x, y : in Integer; board : in out board_type; player_control : in Boolean) is
	begin
	
		if (abs(current_place - next_place) = 3) then -- Forward
			valid_move := check_forward(current_place, next_place, board, player_control);
			
			if (valid_move) then
				-- The move is valid!
				move (current_place, next_place, board);
				exit;
			else
				put_line("You cannot move that piece forward!");
			end if;
			
		elsif (abs(current_place - next_place) = 2) then -- Right-Diagonal
			valid_move := check
			
			if (valid_move) then
				-- The move is valid!
				move (current_place, next_place, board);
				exit;
			else
				put_line("You cannot move that piece there!");
			end if;
			
		elsif (abs(current_place - next_place) = 4) then -- Left-Diagonal
		
		end if;
	end place;
	--------------------------------------------------------------------
	
	
	--------------------------------------------------------------------
	-- Print the instructions to Hexapawn.
	--------------------------------------------------------------------
	--procedure Win_State (board : in board_type) is
	--begin
	
	--end Win_State;
	--------------------------------------------------------------------
	
end header;
