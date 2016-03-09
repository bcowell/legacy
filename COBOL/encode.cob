IDENTIFICATION DIVISION.
PROGRAM-ID. ENCODE.

DATA DIVISION.
	WORKING-STORAGE SECTION.
	01 i pic 9999 value 1.
	01 j pic 99 value 1.

	01 pos pic 9999 value 1.
	01 num pic 99 value 1.

	01 temp-char pic X.

	LINKAGE SECTION.
	01 input-text pic x(1000).

	01 alphabet-record.
                03 row occurs 26 times.
                        05 alpha pic X occurs 26 times.

PROCEDURE DIVISION USING input-text, alphabet-record.
Encode.
	move 1 to num.

	move function mod(pos,26) to pos.
	display pos.

	display "Character " temp-char.

	evaluate temp-char
		when "a" move 1 to num
		when "b" move 2 to num
		when "c" move 3 to num
		when "d" move 4 to num
		when "e" move 5 to num
		when "f" move 6 to num
		when "g" move 7 to num
		when "h" move 8 to num
		when "i" move 9 to num
		when "j" move 10 to num
		when "k" move 11 to num
		when "l" move 12 to num
		when "m" move 13 to num
		when "n" move 14 to num
		when "o" move 15 to num
		when "p" move 16 to num
		when "q" move 17 to num
		when "r" move 18 to num
		when "s" move 19 to num
		when "t" move 20 to num
		when "u" move 21 to num
		when "v" move 22 to num
		when "w" move 23 to num
		when "x" move 24 to num
		when "y" move 25 to num
		when "z" move 26 to num
	end-evaluate.
 
	display "Place " num.	

	perform until j > 27
		

		add 1 to j
	end-perform.

	add 1 to pos.
Main.
	move 1 to i.
	inspect input-text
	converting spaces to "!".
	
	perform until i > 1000
		if input-text(i:1) is alphabetic then
			move input-text(i:1) to temp-char
			perform Encode
		end-if
		add 1 to i
	end-perform.

EXIT PROGRAM.