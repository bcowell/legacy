-- Brayden Cowell - 0844864
-- Mar. 13, 2016 
-- Hexapawn implemented in Ada

With Ada.Text_IO; use Ada.Text_IO;
-- With Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body header is
	
    --------------------------------------------------------------------
    -- Check whether the game has been won.
    -- Any of the 3 ways defined in the spec.
    --------------------------------------------------------------------
    function Win_State (board : in board_type; player_control : in Boolean) return Boolean is
        num_valid_moves, next : Integer := 0;
        pos : Integer := 1;
    begin
   	-- Go through each spot in the 3x3 board
    	for i in board'range(1) loop
        	for j in board'range(2) loop

            	    if (i = 1) then
			-- Player reached Computer's end.
                	if (board(i,j) = 'O') then
                    		return TRUE;
                	end if;	
            	    -- Computer has a pawn on player's end of the board.	
            	    elsif (i = 3) then
                	if (board(i,j) = 'X') then
                   	 	return TRUE;
                	end if;
            	    end if;	

            	    -- There are no moves available for either player.
            	    check_moves(board, pos, player_control, num_valid_moves, next);
		
            	    if (num_valid_moves > 0) then  
                	return FALSE;
            	    end if;
            
            	    pos := pos + 1;
        	end loop;
    	end loop;

	if (num_valid_moves < 1) then
		return TRUE;
	end if;

    	return FALSE;
    end Win_State;
    --------------------------------------------------------------------


    --------------------------------------------------------------------
    -- Computer loops through available moves and chooses one.
    -- Prioritize move if it results in a win.
    --------------------------------------------------------------------
    procedure Computer_turn (board : in out board_type) is 
	num_valid_moves, next : Integer := 0;
	pos : Integer := 1;
	player_control : Boolean;
    begin
	player_control := FALSE;
        for i in board'range(1) loop
	    for j in board'range(2) loop
                check_moves (board, pos, player_control, num_valid_moves, next);
		if (num_valid_moves > 0) then
			put_line(Integer'Image(pos) & "," & Integer'Image(next));
			move (pos, next, board);
			return;
		end if;
		pos := pos + 1;
            end loop;
	end loop;
    end computer_turn;
    --------------------------------------------------------------------

    --------------------------------------------------------------------
    -- Count the amount of possible moves for the player / computer
    --------------------------------------------------------------------
    procedure check_moves (board : in board_type; current : in Integer; player_control : in Boolean; num_valid_moves, next : out Integer) is
        valid_move : Boolean := FALSE;
    begin
	num_valid_moves := 0;
        -- Brute force the amount of possible moves from current position
        for i in 1..9 loop
                place(current, i, board, player_control, valid_move);    
                if (valid_move) then
                    num_valid_moves := num_valid_moves + 1;
		    next := i;	
                end if;
        end loop;
    end check_moves;
    --------------------------------------------------------------------
    
    
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
        -- Convert the given move into 3x3 row,col format
		get_pos(x,y,current,next);
		-- Update board
		board(next.row, next.col) := board(current.row, current.col);
		board(current.row, current.col) := '.';
	end move;
	--------------------------------------------------------------------
	
	
	 -------------------------------------------------------------------
        -- If the user wants to move diagonally. 
        -- Make sure that the supplied move is possible.
        --------------------------------------------------------------------
        function check_diag (x : Integer; y : Integer; board : board_type; player_control : Boolean) return Boolean is
                curr_char, next_char : Character;
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
			
			if (((next.col /= current.col + 1) and (next.row /= current.row - 1)) or
                       	    ((next.col /= current.col - 1) and (next.row /= current.row - 1)))
                        then
                                return FALSE;
                        end if;

			if (next_char /= 'X') then
				return FALSE;
			end if;

		else -- Computer controlled.
			if (curr_char /= 'X') then
                                return FALSE;
                   	end if;

                        if (((next.col /= current.col - 1) and (next.row /= current.row + 1)) or
			    ((next.col /= current.col + 1) and (next.row /= current.row + 1)))
			then
                                return FALSE;
                        end if;

                        -- Have to take player's piece.
                        if (next_char /= 'O') then
                                return FALSE;
                        end if;
		end if;
		return TRUE;
	end check_diag;
	--------------------------------------------------------------------
	

	--------------------------------------------------------------------
	-- If the user wants to move forward.
	-- Make sure that the supplied move is possible.
	--------------------------------------------------------------------
	function check_forward (x : Integer; y : Integer; board : board_type; player_control : Boolean) return Boolean is
		curr_char, next_char : Character;
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

			-- Check if user is moving one space up.
			if ((next.col = current.col) and (next.row /= current.row - 1)) then
                                return FALSE;
			end if;
			
			if (next_char /= '.') then
				return FALSE;
			end if;
				
		else -- computer control
			if (curr_char /= 'X') then
				return FALSE;
			end if;
			
			if ((next.col = current.col) and (next.row /= current.row + 1)) then
				return FALSE;
			end if;
			
			-- Check if vertical downward is empty
			if (next_char /= '.') then
				return FALSE;
			end if;
		end if;
		return TRUE;
	end check_forward;
	--------------------------------------------------------------------


	--------------------------------------------------------------------
	-- Use the differences of the current and next pos to see what direction the control is trying.
	-- Then check if the movement is possible.
	-- If Player controlled (diff of rdiag = 2, forward = 3, ldiag = 4)
	-- If Computer controlled (diff of ldiag = 2, forward = 3, rdiag = 4)
	--------------------------------------------------------------------
	procedure place (x, y : in Integer; board : in board_type; player_control : in Boolean; valid_move : out Boolean) is
	begin
		valid_move := FALSE;

		if (abs(x - y) = 3) then -- Forward
			valid_move := check_forward(x, y, board, player_control);
            
		elsif ((abs(x - y) = 2) or (abs(x - y) = 4)) then -- Right or Left diagonal
			valid_move := check_diag(x, y, board, player_control);
            
		end if;
	end place;
	--------------------------------------------------------------------
	
end header;
