*> Brayden Cowell - 0844864
*> Monday, Mar. 7th, 2016
*> Trimethius Cipher.

IDENTIFICATION DIVISION.
PROGRAM-ID. MAIN.

DATA DIVISION.
	WORKING-STORAGE SECTION.
	*> Loop iterators
	01 i pic 99 value 2.
	01 j pic 99 value 1.
	
	*> Data-structure - 26 rows each with 26 letters
	01 alphabet-record. 
    		03 row occurs 26 times.
			05 alpha pic X occurs 26 times.

	01 temp-str pic x(26) value spaces.
	01 user-input pic x(1000).
	
PROCEDURE DIVISION.
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
main.
	*> Read the paragraph to encode from a file.
	accept user-input from console.
	
	*> Trim the spaces.
	inspect user-input converting spaces to "*".	

	display "User input " user-input.

	*> Encrypt the string.
	CALL 'ENCRYPT' using user-input, BY CONTENT alphabet-record.
	display "Encrypted " user-input.	

	*> Decrypt the string.
	Call 'DECRYPT' using user-input, BY CONTENT alphabet-record.
	display "Decrypted " user-input.

STOP RUN.
