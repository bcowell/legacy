module data_struct

	implicit none
	
	type stack
		integer :: n ! Size of the stack
		character, allocatable, dimension(:) :: direction ! Direction for positioning the solution
		character, allocatable, dimension(:) :: c ! Stack (array of characters)
	end type stack
	
	
contains

	! Push items onto the stack
	! Takes Stack type, item, and direction (N,W,E,S)
	! Returns new Stack
	subroutine push (S, item, dir)
	
		implicit none
		
		type(stack), intent(inout) :: S
		character, intent(in) :: item
		character, intent(in) :: dir
		type(stack) :: tempS
		integer :: k
		
		! Create a temp array of size + 1
		allocate(tempS%c(S%n+1))
		
		! Copy the old array to tempArray
		tempS%c(1:S%n) = S%c
		
		! Get rid of the old array
		DEALLOCATE(S%c)
		
		! Increase size by 1
		S%n = S%n + 1
		
		! Alloc a new array equal to tempArray
		ALLOCATE(S%c(S%n))
		S%c = tempS%c
		deallocate(tempS%c)
		
		! If a path is discovered add its direction
		if (dir .NE. '?') then
			k = sizeof(S%direction)
			allocate(tempS%direction(k+1))
			tempS%direction(1:k) = S%direction
			DEALLOCATE(S%direction)
			k = k + 1
			ALLOCATE(S%direction(k))
			S%direction = tempS%direction
			deallocate(tempS%direction)
			! Save the direction it jumped to
			S%direction(k) = dir
		end if
		
		! Add the new character to the back
		S%c(S%n) = item
		
		
		return
		
	End subroutine push
	
	! Pop last item off the stack
	! Takes Stack type and item
	! Returns new Stack
	subroutine pop (S, item)
	
		implicit none
		
		type(stack), intent(inout) :: S
		character, intent(out) :: item
		type(stack) :: tempS
		
		! Grab the character from the top of the stack
		item = S%c(S%n)
		
		! Decrease size by 1
		S%n = S%n - 1
		
		! Create a temp array of size - 1
		allocate(tempS%c(S%n))
		
		! Copy the old array to tempArray
		tempS%c(1:S%n) = S%c
		
		! Get rid of the old array
		DEALLOCATE(S%c)
		
		! Alloc a new array equal to tempArray
		ALLOCATE(S%c(S%n))
		S%c = tempS%c
		deallocate(tempS%c)
		
		return
		
	End subroutine pop
	
	! Pop last direction off the stack
	! Takes Stack type
	! Returns last direction we moved towards
	subroutine backtrack(S, dir)
	
		implicit none
		
		type(stack), intent(inout) :: S
		character, intent(out) :: dir
		type(stack) :: tempS
		integer :: n

		! Grab the last direction
		n = sizeof(S%direction)
		dir = S%direction(n)
		! Decrease size by 1
		n = n - 1
		
		! Create a temp array of size - 1
		allocate(tempS%direction(n))
		
		! Copy the old array to tempArray
		tempS%direction(1:n) = S%direction
		
		! Get rid of the old array
		DEALLOCATE(S%direction)
		
		! Alloc a new array equal to tempArray
		ALLOCATE(S%direction(n))
		S%direction = tempS%direction
		deallocate(tempS%direction)
		
		return
		
	end subroutine backtrack
		
	! Actual algorithm to solve maze
	! Takes maze (2-d character array), and start position (x,y)
	! Returns solved maze
	Subroutine solve (maze, x, y)
		implicit none
		
		character, allocatable, dimension(:,:), intent(inout) :: maze
		integer, intent(inout) :: x, y
		integer :: i
		type(stack) :: S
		character :: dir
		logical :: solved
		
		character :: startCell, currCell, nextCell
		
		! Create an empty stack named S
		allocate(S%c(0))
		allocate(S%direction(0))
		solved = .FALSE.
		! Inital stack size zero
		S%n = 0
		
		! Push start onto S
		startCell = maze(x,y)
		Call push(S, startCell, 'o')

		! Begin solving
		! Loop until stack is empty or end character 'e' is found
		do while (S%n > 0)
			! Pop the top character from the stack
			Call pop(S, currCell)
			
			! Change position depending on direction we stored in the stack
			
			! Check for end of maze
			If (currCell == 'e') then
				Print *, "Finished Maze"
				solved = .TRUE.
				cycle ! Break from loop
			end if
			
			!mark current_cell as visited
			maze(x,y) = '#'
			
			! Check if there's a path avaiable
			if ((maze(x+1,y) == '.') .OR. (maze(x+1,y) == 'e')) then
				! push the cell to the east onto stack
				x = x + 1
				Call push(S, maze(x,y), 'E')
				cycle
				
			else if ((maze(x-1,y) == '.')  .OR. (maze(x-1,y) == 'e')) then
				! push the cell to the west onto Stack
				x = x - 1
				Call push(S, maze(x,y), 'W')
				cycle
				
			else if ((maze(x,y-1) == '.') .OR. (maze(x,y-1) == 'e')) then
				! push the cell to the north onto Stack
				y = y - 1
				Call push(S, maze(x,y), 'N')
				cycle
				
			else if ((maze(x,y+1) == '.') .OR. (maze(x,y+1) == 'e')) then
				! push the cell to the south onto Stack
				y = y + 1
				Call push(S, maze(x,y), 'S')
				cycle
			else 
				! No path available  - have to backtrack
				! Set character as '@' visited
				maze(x,y) = '@'
				! Push previous position onto stack
				call backtrack(S, dir)
				select case (dir) 
					case ('N')
						y = y + 1
						Call push(S, maze(x,y), '?')
					case ('E')
						x = x - 1
						Call push(S, maze(x,y), '?')
					case ('S')
						y = y - 1
						Call push(S, maze(x,y), '?')
					case ('W')
						x = x + 1
						Call push(S, maze(x,y), '?')
				end select
			end if

			do i = 1, 12
				print *, maze(:,i)
			end do
			print *, ' '
			
		end do
		
		! Deallocate the stack
		deallocate(S%c)
		
		if ((S%n == 0) .AND. (.NOT. solved)) then
			Print *, 'No solution found!'
		end if
		
		return
	
	End subroutine solve
End module data_struct


Program mazeSolver
	! Brayden Cowell - 0844864
	! Jan. 12, 2016 
	! Maze Traversal Fortran Program
	! wall='*', space='.', start='o', finish='e'
	Use data_struct
	implicit none
	
	character (len = 20) :: filename
	logical :: file_exits
	integer :: row, col, i, j, error
	character, allocatable, dimension(:,:) :: maze
	character (len = 30) :: tempStr
	character :: tempChar
	integer :: x,y
	
	! Prompt user for filename (ex. maze.txt)
	write(*,*) 'Enter filename of the maze:'
	read (*,*) filename
	! Make sure file exists
	inquire(file=filename, exist=file_exits) 
	if (file_exits) then 
		open(99,file=filename, status='OLD', action='READ')
		write (*,*) 'Reading File..'
	else 
		write (*,*) 'Error - Cannot open file!'
	end if
	
	! Get the dimensions of the maze
	read (99,*) col, row
	write (*,*) 'Maze dimensions are:', row,col
	
	! Allocate the maze, then fill it with blanks
	allocate(maze(row,col))
	maze = '*'
	
	! Copy the maze from file into the maze array
	do i = 1, row
		! Read in each string-line from the file
		read (99,*) tempStr
		do j = 1, col
			! Seperate each char from the string
			tempChar = tempStr(j:j)
			! Insert each char into the matrix at pos(x,y)
			maze(j,i) = tempChar
			! Find startPos
			If (tempChar == 'o') then
				x = i
				y = j
			end if
		end do
	end do

	! Close the file
	close(99, status='KEEP')
	
	print *, 'Unsolved Maze:'
	
	! Print the original maze
	do i = 1, row
		print *, maze(:,i)
	end do
	
	print *, ' '
	
	! Call the subroutine in the module to solve the maze
	Call solve(maze, x, y)
	
	! Print the completed maze
	do i = 1, row
		print *, maze(:,i)
	end do
	
	deallocate(maze)
	
End Program mazeSolver
