IDENTIFICATION DIVISION.
PROGRAM-ID. DECRYPT.

DATA DIVISION.
	WORKING-STORAGE SECTION.
	01 i pic 9999 value 1.
	01 j pic 99 value 1.

	01 pos pic 99 value 0.
	01 num pic 99 value 1.

	01 temp-char pic X.

	LINKAGE SECTION.
	01 input-text pic x(1000).

	01 alphabet-record.
                03 row occurs 26 times.
                        05 alpha pic X occurs 26 times.

PROCEDURE DIVISION USING input-text, alphabet-record.
*> Opposite of encode.
*> Use the encrypted characters position in the cipher table to find what it decodes to.
Decode.
	move 1 to num.
	
	*> Go through each row of shifted letters.
	if pos is not equal to 26 then
		move function mod(pos,26) to pos
	end-if.

	*> Count how many characters are infront of the letter in the cipher-table row.
	inspect row(pos) tallying num for characters before temp-char.

	*> Replace the letter with whatever position the encrypted letter is at.
	evaluate num
		when 1 move "a" to temp-char
		when 2 move "b" to temp-char
		when 3 move "c" to temp-char
		when 4 move "d" to temp-char
		when 5 move "e" to temp-char
		when 6 move "f" to temp-char
		when 7 move "g" to temp-char
		when 8 move "h" to temp-char
		when 9 move "i" to temp-char
		when 10 move "j" to temp-char
		when 11 move "k" to temp-char
		when 12 move "l" to temp-char
		when 13 move "m" to temp-char
		when 14 move "n" to temp-char
		when 15 move "o" to temp-char
		when 16 move "p" to temp-char
		when 17 move "q" to temp-char
		when 18 move "r" to temp-char
		when 19 move "s" to temp-char
		when 20 move "t" to temp-char
		when 21 move "u" to temp-char
		when 22 move "v" to temp-char
		when 23 move "w" to temp-char
		when 24 move "x" to temp-char
		when 25 move "y" to temp-char
		when 26 move "z" to temp-char
	end-evaluate.
		
	add 1 to pos.

*> Read each character one at a time calling decode for the string.
Main.
        move 1 to i.

        perform until i > 1000
                if input-text(i:1) is alphabetic then
                        move input-text(i:1) to temp-char
                        perform Decode
                        move temp-char to input-text(i:1)
                end-if
                add 1 to i
        end-perform.

EXIT PROGRAM.
