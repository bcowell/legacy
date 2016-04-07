-- Brayden Cowell - 0844864
-- Mar. 13, 2016 
-- Hexapawn implemented in Ada

with Ada.Text_IO; use Ada.Text_IO;
with header; use header;

procedure Main is

	board : board_type := (1 => (1..3 => 'X'), 2 => (1..3 => '.'), 3 => (1..3 => 'O'));
	
	current_place, next_place : Integer := 0;
	player_win_count, computer_win_count, total_win_count : Integer := 0;
	
	valid_move, player_control, game_won : Boolean := FALSE;
	
	user_input : String (1..50);
	last : natural;
	
begin
	-- Welcome the player and provide a brief how to play
	new_line;
	put_line("Welcome to Hexapawn!");
	put_line("Ported to Ada from BASIC by Brayden Cowell.");
	put_line("Enter Quit / q on your move to exit.");
	
	-- See if the user wants further instructions
	put_line("Instructions (Y/N)? ");
	get_line(user_input, last);
	
	if (user_input(1) = 'Y' or user_input(1) = 'y') then
		Show_Instructions(board);
	end if;

	Main_Game_Loop:
	loop
	begin
		print_board (board);	
		player_control := FALSE;
		valid_move := FALSE;
			
		-- Player's turn to move.
		Player_Move:
		loop
			-- clear user_input
			user_input := (1..50 => ' ');
				
			put_line("YOUR MOVE ?");
			get_line(user_input, last);
				
			-- Quit the game if user enters Q
			case user_input(1) is
				when 'Q' | 'q' => raise Exit_Program;
				when others => null;
			end case;
				
			-- Check if input is like (number,number)
			-- Cast the characters to ints and subtract ASCII of 0.
			current_place := Character'Pos(user_input(1)) - 48;
			next_place := Character'Pos(user_input(3)) - 48;
				
			if ((current_place in 1..9) and (next_place in 1..9)) then -- Input is valid
				-- Now check if move is valid
				player_control := TRUE;
				place(current_place, next_place, board, player_control, valid_move);
                    		if (valid_move) then
				        move (current_place, next_place, board);
				end if;
			else
				put_line("Wrong input. Try number,number!");
			end if;
				
			exit when valid_move;
		end loop Player_Move;
			
		-- Check if game is won.
		game_won := win_state(board, player_control);			
            	if (game_won) then 
                	put_line("You Win!");
			player_win_count := player_win_count + 1;
                	raise Game_Over;
            	end if;

		print_board(board);

        	player_control := FALSE;
		-- Computer's AI
		Computer_turn(board);
			
		-- Check if game is won.
		game_won := win_state(board, FALSE);
            	if (game_won) then 
                	put_line("I Win!");
			computer_win_count := computer_win_count + 1;
                	raise Game_Over;
            	end if;
            
		exception
		when Game_Over =>
			total_win_count := player_win_count + computer_win_count;
			put_line("I have won" & Integer'Image(computer_win_count) & " you" & Integer'Image(player_win_count) & " out of" & Integer'Image(total_win_count) & " games.");
			print_board (board);
			-- Reset the board
			board := (1 => (1..3 => 'X'), 2 => (1..3 => '.'), 3 => (1..3 => 'O'));
		end;
	end loop Main_Game_Loop;

	exception
	when Exit_Program =>
		put_line("Thanks for playing!");
end Main;
