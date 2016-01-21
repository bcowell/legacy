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
		return
		
	End subroutine pop
	
End module data_struct
	
Program mazeSolver
	! Brayden Cowell - 0844864
	! Jan. 12, 2016 
	! Maze Traversal Fortran Program
	Use data_struct
	implicit none
	
	character, parameter :: wall='*', space='.', start='o', finish='e'
	character (len = 20) :: filename
	logical :: file_exits
	integer :: row, col, i, j, error
	character, allocatable, dimension(:,:) :: maze
	type(stack) :: S
	
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
	
	allocate(maze(row,col))
	maze = '@'
	do i = 1, col
		print *, maze(i,:)
	end do
	
	! Copy the maze from file into the maze array
	do i = 1, col
		read (99,*) maze(i,:)
	end do
	
	! Close the file
	close(99, status='KEEP')
	
	! Print the maze out
	do i = 1, col
		print *, maze(i,:)
	end do
	

	deallocate(maze)
	
End Program mazeSolver
