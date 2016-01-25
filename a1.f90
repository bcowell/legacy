module data_struct

	implicit none
	
	type stack
		integer :: n
		character :: direction
		character, allocatable, dimension(:) :: c
	end type stack
	
	
contains

	! Push items onto the stack
	! Takes Stack type and item
	! Returns new Stack
	subroutine push (S, item, dir)
	
		implicit none
		
		type(stack), intent(inout) :: S
		character, intent(in) :: item
		character, intent(in) :: dir
		type(stack) :: temp
		
		! Increase the characeter stack by 1
		allocate(temp%c(S%n+1))
		temp%c(1:S%n) = S%c
		DEALLOCATE(S%c)
		S%n = S%n + 1 
		ALLOCATE(S%c(S%n))
		S%c = temp%c
		deallocate(temp%c)	
		! Add the new character to the back
		S%c(S%n) = item
		S%direction = dir
		
		return
		
	End subroutine push
	
	! Pop last item off the stack
	! Takes Stack type and item
	! Returns new Stack
	subroutine pop (S, item, dir)
	
		implicit none
		
		type(stack), intent(inout) :: S
		character, intent(out) :: item
		character, intent(out) :: dir
		type(stack) :: temp
		
		! Grab the character from the top of the stack
		item = S%c(S%n)
		dir = S%direction
		S%n = S%n - 1 
		allocate(temp%c(S%n))
		temp%c(1:S%n) = S%c
		DEALLOCATE(S%c)
		ALLOCATE(S%c(S%n))
		S%c = temp%c
		deallocate(temp%c)
		
		return
		
	End subroutine pop
	
	Subroutine solve (maze, x, y)
		implicit none
		
		character, allocatable, dimension(:,:), intent(inout) :: maze
		integer, intent(inout) :: x, y
		integer :: i
		type(stack) :: S
		character :: dir
		
		character :: startCell, currCell, nextCell
		
		! Create an empty stack named S
		allocate(S%c(0))
		S%n = 0
		
		! Push start onto S
		startCell = maze(x,y)
		Call push(S, startCell, 'o')

		! While S is not empty do
		do while (S%n > 0)
			! current_cell ← pop from S
			Call pop(S, currCell, dir)
			
			! Check for end of maze
			If (currCell == 'e') then
				Print *, "Finished Maze"
				!S ← empty stack;
				
			!else if current_cell is not a wall and current_cell is not marked as visited then
			else if ((currCell == '.') .OR. (currCell == 'o')) then
				!mark current_cell as visited;
				if (dir == 'N') then 
					y = y - 1
				else if (dir == 'E') then 
					x = x + 1
				else if (dir == 'S') then 
					y = y + 1
				else if (dir == 'W') then
					x = x - 1
				end if
				maze(x,y) = '#'
				
				!push the cell to the east onto S
				nextCell = maze(x+1,y)
				Call push(S, nextCell, 'E')
				
				
				!push the cell to the west onto S
				nextCell = maze(x-1,y)
				Call push(S, nextCell, 'W')
				
				!push the cell to the north onto S
				nextCell = maze(x,y-1)
				Call push(S, nextCell, 'N')
				
				!push the cell to the south onto S
				nextCell = maze(x,y+1)
				Call push(S, nextCell, 'S')
			end if
			
		end do
		
		deallocate(S%c)
		
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
	
	! Print the maze out
	do i = 1, row
		print *, maze(:,i)
	end do
	
	print *, ' '
	
	Call solve(maze, x, y)
	
	! Print the maze out
	do i = 1, row
		print *, maze(:,i)
	end do
	
	deallocate(maze)
	
End Program mazeSolver
