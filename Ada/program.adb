-- Brayden Cowell - 0844864
-- Feb. 19, 2016 
-- Sudoku Solver implemented in Ada

with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;

package body Program is
    procedure sudokuSolver is
    
        type array_type is array (1..9) of Integer;
        
        type puzzle_type is array (1..9, 1..9) of Integer;
        type grid_type is array (1..3, 1..3) of array_type; -- Create a 3x3 grid able to store an array of 9 possibilites
        
    	knowns : array_type := (1..9 => 0);
    	values : array_type := (1..9 => 0);
    	tempArray : array_type := (1..9 => 0);
    	
    	grid : grid_type;
    	puzzle : puzzle_Type;
    	known_value : Boolean;
    	puzzle_conflict : Boolean;
    	
    	x,y,n : Integer; -- Keep track of what 3x3 grid we are on of the whole puzzle.
    	
    	begin
    	
    	-- Initialize 2D array with 81 empty grids (nx = 9, ny = 9)
    	for i in 1..9 loop
    	    for j in 1..9 loop
    		    puzzle (i, j) := 0;
    	    end loop;
    	end loop;
    	
    	-- Read from file and fill in know values.
    	-- filename: string(1..50);
        -- last: natural;
        -- get_line(filename,last);
        --open(infp,in_file,fileN(1..last));
        
    	-- Just assign one for now..
        puzzle := (
        (0,0,0, 2,6,0, 7,0,1),
        (6,8,0, 0,7,0, 0,9,0),
        (1,9,0, 0,0,4, 5,0,0),
        (8,2,0, 1,0,0, 0,4,0),
        (0,0,4, 6,0,2, 9,0,0),
        (0,5,0, 0,0,3, 0,2,8),
        (0,0,9, 3,0,0, 0,7,4),
        (0,4,0, 0,5,0, 0,3,6),
        (7,0,3, 0,1,8, 0,0,0));
        
        
        -- Print it out the unsolved puzzle.
    	-- for i in 1..9 loop
            -- for j in 1..9 loop
        	    -- put(puzzle (i,j));
            -- end loop;
            -- new_line;
    	-- end loop;
        -- new_line;
    
        x := 0;
        y := 0;
        n := 1;
        
        -- Get the values already in the 3x3 grid
        for i in 1..3 loop
            for j in 1..3 loop
                case puzzle(x+i, y+j) is 
                    when 0 => null;
                    when others => knowns(n) := puzzle(x+i, y+j); -- Copy the know values into an array for later
                end case;
                n := n+1;
            end loop;
        end loop;
        
        -- Store possibilities for all squares with no values in the 3x3 grid
        -- Possible values include those not in the current grid
        for k in 1..9 loop -- Go through all the possible numbers
            for m in 1..9 loop -- If the possible number is in the grid
                if (k = knowns(m)) then
                    known_value := TRUE; -- Found a number that was already in the 3x3 grid.
                end if;
            end loop;
            
            if (known_value = FALSE) then 
            -- If the number is not in the grid, store all possible values as a string.
                values(k) := k;
            end if;
            
            known_value := FALSE; -- Reset to check if the next number is already in the 3x3 grid
        end loop;
        
        for i in 1..3 loop
            for j in 1..3 loop
                if (puzzle(x+i, y+j) = 0) then
                    -- Narrow down possibilities even more by checking if there is an already filled number that conflicts with any of the possibilites
                    for k in values'range loop
                        puzzle_conflict := check(k, puzzle, x+i, y+j);
                    end loop;
                    grid(i,j) := values;
                else
                    tempArray(1) := puzzle(x+i, y+j);
                    grid(i,j) := tempArray;
                end if;
            end loop;
        end loop;
        
        -- Now we have a 3x3 array with each point being an array of possible solutions
        -- Points with one solution are an array of 1..9 with the first filled and the rest 0.
        
        -- Search
        -- DFS look through all possible values of each square in the grid and try them all out
            -- while (grid has > 1 value)
                -- Calculate all possible values of each square
                -- Choose an empty square with the least possibilities
                -- pick a value
                -- check if the chosen value is fine
                    -- if false; remove failed value from spot
                    -- if true; update grid with newfound value
                -- Recursively call search
       
    	-- Print out solved puzzle
        -- for i in 1..9 loop
            -- for j in 1..9 loop
        	    -- put(puzzle (i,j));
            -- end loop;
            -- new_line;
    	-- end loop;
    	
    end sudokuSolver;
    
    -- Check 
    -- See if value has a conflict with rest of the numbers in its column and row
    -- Check if number is in same col or row of puzzle
    -- Return false on conflict, true otherwise
    function check(k : in Integer; puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean is
    begin
        return FALSE;
    end check;
end Program;