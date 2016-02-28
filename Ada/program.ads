package Program is
    procedure sudokuSolver;
    function check(k : in Integer; puzzle : in puzzle_type; posX : in Integer; posY : in Integer) return Boolean;
end Program;