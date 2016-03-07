IDENTIFICATION DIVISION.
PROGRAM-ID. ENCODE.

DATA DIVISION.
	WORKING-STORAGE SECTION.
	01 i pic 9999 value 1.

	01 temp-char pic X.

	LINKAGE SECTION.
	01 input-text pic x(1000).

	01 alphabet-record.
                03 row occurs 26 times.
                        05 alpha pic X occurs 26 times.

PROCEDURE DIVISION USING input-text, alphabet-record.
Encode.
	* Take the temp-char and encode it.
	* Goes in its number position of level i, Ex B = 2.
	* Once i goes past 26, wrap back to 1.
	
Main.
	move 1 to i.
	inspect input-text
	converting spaces to "!".
	
	perform until i > 1000
		move input-text(i:1) to temp-char

		if temp-char is alphabetic then
			display temp-char
			perform Encode
		end-if
		add 1 to i
	end-perform.

EXIT PROGRAM.
