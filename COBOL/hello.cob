IDENTIFICATION DIVISION.
PROGRAM-ID. HELLO-WORLD.
DATA DIVISION.
WORKING-STORAGE SECTION.
* Define loop indices
01 i pic 99 value 2.
01 j pic 99 value 1.

01 alphabet-record. 
    03 row occurs 26 times.
	05 alpha pic X occurs 26 times.

01 temp-str pic x(26) value spaces.
	
PROCEDURE DIVISION.
	* Initialize the first row
	move "abcdefghijklmnopqrstuvwxyz" to row(1)

	* Inspect / convert next rows based on previous
	perform until i > 26
		* Fill in temp-str with the previous row
		move i to j
		subtract 1 from j
		move row(j) to temp-str

		* Inspect and replace the temp-str with the next letter in the alphabet
		inspect temp-str
		converting "abcdefghijklmnopqrstuvwxyz" to "bcdefghijklmnopqrstuvwxyza"

		display "Row is " temp-str
		move temp-str to row(i)
		Add 1 to i
	end-perform.
STOP RUN.
