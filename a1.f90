module data_struct

	implicit none
	
	type stack
		integer :: n
		character, allocatable, dimension(:) :: S
	end type stack
	
	
contains

	! Push items onto the stack
	! Takes Stack type and item
	! Returns New Stack
	subroutine push (S, item)
	
		implicit none
		
		type(stack), intent(inout) :: S
		character, intent(in) :: item
		! Do the work here
		! n + 1
		return
		
	End subroutine push
	
	! Pop last item off the stack
	! Takes Stack type and item
	! Returns New Stack
	subroutine pop (S, item)
	
		implicit none
		
		type(stack), intent(inout) :: S
		character, intent(out) :: item
		! Do the work here
		! n - 1
		return
		
	End subroutine pop
	
	Subroutine solve (maze, x, y)
	implicit none
	
	character, allocatable, dimension(:,:), intent(in) :: maze
	integer, intent(in) :: x, y
	
	type(stack) :: S
	character :: startCell, currCell, nextCell
	
	! Create an empty stack named S
	S%n = 0
	
	! Push start onto S
	startCell = maze(x,y)
	Call push(S, startCell)
	! While S is not empty do
	do while (S%n > 0)
		! current_cell ← pop from S;
		Call pop(S, currCell)
		!if current_cell is the finish-point then
		If (currCell == 'e') then
			Print *, "Finished Maze"
			!S ← empty stack;
		!else if current_cell is not a wall and current_cell is not marked as visited then
		else if ((currCell .NE. '*') .AND. (currCell .NE. '#')) then
			!mark current_cell as visited;
			currCell = '#'
			
			!push the cell to the east onto S
			nextCell = maze(x+1,y)
			Call push(S, nextCell)
			
			!push the cell to the west onto S
			nextCell = maze(x-1,y)
			Call push(S, nextCell)
			
			!push the cell to the north onto S
			nextCell = maze(x,y+1)
			Call push(S, nextCell)
			
			!push the cell to the south onto S
			nextCell = maze(x,y-1)
			Call push(S, nextCell)
			
		end if
	end do

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
	read (99,*) row,col
	write (*,*) 'Maze dimensions are:', row,col
	
	! Allocate the maze, then fill it with blanks
	allocate(maze(row,col))
	maze = '*'
	
	! Copy the maze from file into the maze array
	do i = 1, col
		! Read in each string-line from the file
		read (99,*) tempStr
		do j = 1, row
			! Seperate each char from the string
			tempChar = tempStr(j:j+1)
			! Insert each char into the matrix at pos(x,y)
			maze(i,j) = tempChar
			If (tempChar == 'o') then
				x = i
				y = j
			end if
		end do
	end do

	! Close the file
	close(99, status='KEEP')
	
	! Print the maze out
	do i = 1, col
		print *, maze(i,:)
	end do
	
	Call solve(maze, x, y)
	
	
	deallocate(maze)
	
End Program mazeSolver
