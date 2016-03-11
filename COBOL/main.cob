*> Brayden Cowell - 0844864
*> Monday, Mar. 7th, 2016
*> Trimethius Cipher.
*> Main "Function"

IDENTIFICATION DIVISION.
PROGRAM-ID. MAIN.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
	select file-name assign to dynamic user-input.

DATA DIVISION.
FILE SECTION.
	FD file-name.
	01 in-str	pic x(1000).

WORKING-STORAGE SECTION.
	*> File stuff.
	01 file-status	pic 99.

	*> Loop iterators
	01 i 	pic 99	value 2.
	01 j	pic 99	value 1.
	
	*> Data-structure - 26 rows each with 26 letters
	01 alphabet-record. 
    		03 row				occurs 26 times.
			05 alpha	pic X	occurs 26 times.

	01 temp-str		pic x(26)	value spaces.
	01 user-input 		pic x(20).
	01 str-size 		pic 9999.
	
	*> Variables for removing spaces.
	01 VOUT     	PIC X(1000).
	01 VWORK    	PIC X(1000).
	01 VTEMP	PIC X(1000).
	01 p1		pic 9999.
	01 p2		pic 9999.

	
PROCEDURE DIVISION.

*> Create a table of each shifted alphabet.
init-table.
	*> Initialize the first row.
	move "abcdefghijklmnopqrstuvwxyz" to row(1).

	perform until i > 26
		move i to j
		subtract 1 from j
		move row(j) to temp-str

		*> Replacing each letter with the next.
		inspect temp-str
		converting "abcdefghijklmnopqrstuvwxyz" to "bcdefghijklmnopqrstuvwxyza"

		move temp-str to row(i)
		Add 1 to i
	end-perform.


*> Remove spaces for a string.
*> source: http://www.tek-tips.com/viewthread.cfm?qid=858815 - Frederico Fonseca
UNSTRING1.
	MOVE 1 TO P1 P2.
           
	PERFORM UNTIL P1 > 1000
		MOVE SPACES TO VOUT VTEMP
           
		PERFORM UNTIL P1 > 1000
			UNSTRING VWORK DELIMITED BY ALL SPACES
				INTO VTEMP
			POINTER P1
			*> IF VTEMP NOT = SPACES
			STRING VTEMP DELIMITED BY SPACES
				INTO VOUT
			POINTER P2
			*> END-IF
		END-PERFORM
	END-PERFORM.
	*> Vout now holds the string sans spaces.
	move vout to in-str.


*> Read in user input, encrypt, decrypt, and display output.
main.
	*> Read the paragraph to encode from a file.
	Display "Enter an input filename:".

	accept user-input from console.
	display "Opening " user-input.
	open input file-name.

	read file-name 
		into in-str
	end-read.

	close file-name.
	
	*> Change any Upper-case letters to lower-case.
	inspect in-str converting "ABCDEFGHIJKLMNOPQRSTUVWXYZ" to "abcdefghijklmnopqrstuvwxyz".
	
	*> Trim the spaces.
	move in-str to vwork.
	perform unstring1.
	
	*> User-input is still 1000 chars long, so we need to cut the right-trailing nulls.
	unstring in-str
	delimited by all spaces
	into in-str count in str-size.
	
	display str-size.
	*> Now we can call encrypt/decrypt with the properly sized string.

	*> Encrypt the string.
	CALL 'ENCRYPT' using in-str(1:str-size), BY CONTENT alphabet-record.
	display "Encrypted " in-str(1:str-size).	

	*> Decrypt the string.
	Call 'DECRYPT' using in-str(1:str-size), BY CONTENT alphabet-record.
	display "Decrypted " in-str(1:str-size).

STOP RUN.
