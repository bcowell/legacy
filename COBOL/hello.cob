IDENTIFICATION DIVISION.
PROGRAM-ID. HELLO-WORLD.
DATA DIVISION.
WORKING-STORAGE SECTION.
* Define loop indices
01 i pic 99 value 1.
01 j pic 99 value 1.

01 alphabet-record. 
    03 row occurs 26 times.
	05 alpha pic X occurs 26 times.
 
PROCEDURE DIVISION.
	move "abcdefghijklmnopqrstuvwxyz" to row(1).
	
	perform until i > 25
		display "Row is " row(i)
		perform until j > 25
			display "Alpha is " alpha(i,j)
			add 1 to j
		end-perform
		Add 1 to i
	end-perform.
STOP RUN.
