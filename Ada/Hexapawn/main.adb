-- Brayden Cowell - 0844864
-- Mar. 13, 2016 
-- Hexapawn implemented in Ada

with Ada.Text_IO; use Ada.Text_IO;
with header; use header;

procedure Main is

	-- Initalize the board
	board : board_type := (1 => (1..3 => 'X'), 2 => (1..3 => '.'), 3 => (1..3 => 'O'));
	
	current_place, next_place : Integer := 0;
	
	valid_move, player_control, game_won : Boolean := FALSE;
	
	user_input : String (1..50);
	last : natural;
	
begin
	-- Welcome the player and provide a brief how to play
	new_line;
	put_line("Welcome to Hexapawn!");
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
				else
					put_line("Wrong input. Try number,number!");
				end if;
				
				exit when valid_move;
			end loop Player_Move;
			
			-- Check if game is won.
			game_won := win_state(board, player_control);			
            if (game_won) then 
                put_line("Player Wins!");
                raise exception Game_Over;
            end if;
			print_board(board);
			
			-- Computer's turn to move
            player_control := FALSE;
			Computer_Move:
			loop
				-- All positions encountered by the program and acceptable moves from them are stored in an array.
				-- When the program encounters an unfamiliar position, the position and all legal moves for it are added to the list.
				-- If the program loses a game, it erases the move that lef to defeat.
				-- If it hits a position from which all moves have been deleted (they all lead to defeat), it erases the move that got it there and resigns.
				put_line("Computer move");
				new_line;
				exit;
			end loop Computer_Move;
			
			-- Check if game is won.
			game_won := win_state(board, player_control);
            if (game_won) then 
                put_line("Computer Wins!");
                raise exception Game_Over;
            end if;
            
		exception
			when Game_Over =>
				put_line("Game over!");
		end;
	end loop Main_Game_Loop;

exception
	when Exit_Program =>
		put_line("Thanks for playing!");
end Main;
