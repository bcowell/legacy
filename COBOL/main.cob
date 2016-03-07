IDENTIFICATION DIVISION.
PROGRAM-ID. MAIN.

DATA DIVISION.
	WORKING-STORAGE SECTION.
	01 i pic 99 value 2.
	01 j pic 99 value 1.

	01 alphabet-record. 
    		03 row occurs 26 times.
			05 alpha pic X occurs 26 times.

	01 temp-str pic x(26) value spaces.
	01 user-input pic x(1000).
	
PROCEDURE DIVISION.
init-table.
	move "abcdefghijklmnopqrstuvwxyz" to row(1).

	perform until i > 26
		move i to j
		subtract 1 from j
		move row(j) to temp-str

		inspect temp-str
		converting "abcdefghijklmnopqrstuvwxyz" to "bcdefghijklmnopqrstuvwxyza"

		display "Row is " temp-str
		move temp-str to row(i)
		Add 1 to i
	end-perform.
main.
	accept user-input from console.
	display "User input " user-input.

	CALL 'ENCODE' using user-input, BY CONTENT alphabet-record.

STOP RUN.
