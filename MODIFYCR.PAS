unit MODIFYCR;

interface

procedure MODIFY_CORD;
implementation
uses dos,crt,miscproc;
procedure MODIFY_CORD;
type
WORLD_CORD_TYPE = record
        DAY : integer;
        MILE : integer;
        DIRECTION : integer;
        CITY : string[20];
        LAT : real;
        LONG_TZ : real;
        LONG_LOC : real;
        end;

WORLD_CORD_ARRAY = array [1..200] of WORLD_CORD_TYPE;

var
last,x : integer;
WORLD_CORD : WORLD_CORD_ARRAY;
LONG_LOCI,LATI,LONG_TZI : integer;
WORLD_FILE : file of WORLD_CORD_TYPE;
CITY : string[20];
CHOICE : char;
CHOICE2 : integer;
DONE : boolean;
WORLD_CORD2 : WORLD_CORD_TYPE;
PRINTER : text;
DAY,MONTH,YEAR:integer;
DAY2,MONTH2,YEAR2,DOW:word;

procedure SORT(var WORD_CORD : WORLD_CORD_ARRAY; NUMBER:integer);
var
   I,J : integer;
   TEMP : WORLD_CORD_TYPE;

begin
for I := 2 to NUMBER do
  for J := 1 to I - 1 do
    if (WORLD_CORD[J].MILE > WORLD_CORD[I].MILE) then begin
       TEMP := WORLD_CORD[I];
       WORLD_CORD[I] := WORLD_CORD[J];
       WORLD_CORD[J] := TEMP;
    end;
end;

begin
  clrscr;
  DONE := false;
  for x:= 1 to 10 do writeln;
  write('      Enter the date for the World Coordinate file MM/DD/YY ==>');
  GET_NEW_DATE(MONTH,DAY,YEAR);
  GETDATE(YEAR2,MONTH2,DAY2,DOW);
  SETDATE(YEAR,MONTH,DAY);
  repeat
  clrscr;
  gotoxy(1,8);
  writeln;
  writeln('                            1...Create new File.');
  writeln('                            2...Print File.');
  writeln('                            3...Modify File.');
  writeln('                            9...Exit.');
  writeln;
  write('                              Choice ==>');
  DRAW_BOX(25,7,55,16);
  gotoxy(28,7);
  writeln('  World Coordinate File  ');
  gotoxy(42,14);
  readln(CHOICE2);
  case CHOICE2 of
  1 : begin
        DONE := false;
        assign(WORLD_FILE,FILE_NAME);
        rewrite(WORLD_FILE);
        while not DONE do
        begin
            clrscr;
            write('Enter the Mile Number ==>');
            readln(WORLD_CORD2.MILE);
            write('Enter the Direction of the car ==>');
            readln(WORLD_CORD2.DIRECTION);
            write('Enter the current Lattitude ==>');
            readln(WORLD_CORD2.LAT);
            WORLD_CORD2.LAT := WORLD_CORD2.LAT * 0.01745330;
            write('Enter the current Longitude ==>');
            readln(WORLD_CORD2.LONG_LOC);
            WORLD_CORD2.LONG_LOC := WORLD_CORD2.LONG_LOC * 0.01745330;
            write('Enter the Longitude of the time zone ==>');
            readln(WORLD_CORD2.LONG_TZ);
            WORLD_CORD2.LONG_TZ := WORLD_CORD2.LONG_TZ * 0.01745330;
            write('Enter the city <CR> if none ==>');
            readln(CITY);
            if CITY = '' then WORLD_CORD2.CITY := 'None'
            else WORLD_CORD2.CITY := CITY;
            if WORLD_CORD2.MILE < 0 then DONE := true
            else write(WORLD_FILE,WORLD_CORD2);
        end;
        close(WORLD_FILE);
      end;

  2 : begin
        assign(PRINTER,'LPT1');
        assign(WORLD_FILE,FILE_NAME);
        reset(WORLD_FILE);
        rewrite(PRINTER);
        while not eof (WORLD_FILE) do
        begin
            read(WORLD_FILE,WORLD_CORD2);
            LATI := trunc (WORLD_CORD2.LAT * 57.296);
            LONG_LOCI := trunc (WORLD_CORD2.LONG_LOC * 57.296);
            LONG_TZI := trunc (WORLD_CORD2.LONG_TZ * 57.296);
            writeln(PRINTER,'.  ',WORLD_CORD2.MILE,'  ',lati,'  ',LONG_LOCi,'  ',LONG_TZi,'  ',
            WORLD_CORD2.DIRECTION,'  ',WORLD_CORD2.CITY);
        end;
        close(PRINTER);
        close(WORLD_FILE);
      end;

  3 : begin
         assign (WORLD_FILE,FILE_NAME);
         clrscr;
         x := 1;
         reset (WORLD_FILE);
         while not eof(WORLD_FILE) do
         begin
            read (WORLD_FILE,WORLD_CORD[x]);
            x := X + 1;
         end;
         LAST := x;
         for x := 1 to LAST-1 do
         begin
            LATI := trunc (WORLD_CORD[x].LAT * 57.296);
            LONG_LOCI := trunc (WORLD_CORD[x].LONG_LOC * 57.296);
            LONG_TZI := trunc (WORLD_CORD[x].LONG_TZ * 57.296);
            writeln(x,'.  ',WORLD_CORD[x].MILE,'  ',lati,'  ',LONG_LOCi,'  ',LONG_TZi,'  ',
            WORLD_CORD[x].DIRECTION,'  ',WORLD_CORD[x].CITY);
         end;
         writeln;
         writeln;
         write('Modify or Add or Delete or Quit (M/A/D/Q)?');
         readln(choice);
         if ((choice = 'm') or (choice = 'M')) then
         begin
            write('Enter the number to modify ==>');
            readln(x);
            write('Enter the Direction of the car ==>');
            readln(WORLD_CORD[x].DIRECTION);
            write('Enter the current Lattitude ==>');
            readln(WORLD_CORD[x].LAT);
            WORLD_CORD[x].LAT := WORLD_CORD[x].LAT * 0.01745330;
            write('Enter the current Longitude ==>');
            readln(WORLD_CORD[x].LONG_LOC);
            WORLD_CORD[x].LONG_LOC := WORLD_CORD[x].LONG_LOC * 0.01745330;
            write('Enter the Longitude of the time zone ==>');
            readln(WORLD_CORD[x].LONG_TZ);
            WORLD_CORD[x].LONG_TZ := WORLD_CORD[x].LONG_TZ * 0.01745330;
            write('Enter the city <CR> if none ==>');
            readln(CITY);
            if CITY = '' then WORLD_CORD[x].CITY := 'None'
            else
               WORLD_CORD[x].CITY := CITY;
            rewrite(WORLD_FILE);
            for x := 1 to LAST - 1 do
               write(WORLD_FILE,WORLD_CORD[x]);
         end;
         if ((CHOICE = 'A') or (CHOICE = 'a')) then
         begin
            clrscr;
            x := LAST;
            LAST := LAST + 1;
            write('Enter the Mile Number ==>');
            readln(WORLD_CORD[x].MILE);
            write('Enter the Direction of the car ==>');
            readln(WORLD_CORD[x].DIRECTION);
            write('Enter the current Lattitude ==>');
            readln(WORLD_CORD[x].LAT);
            WORLD_CORD[x].LAT := WORLD_CORD[x].LAT * 0.01745330;
            write('Enter the current Longitude ==>');
            readln(WORLD_CORD[x].LONG_LOC);
            WORLD_CORD[x].LONG_LOC := WORLD_CORD[x].LONG_LOC * 0.01745330;
            write('Enter the Longitude of the time zone ==>');
            readln(WORLD_CORD[x].LONG_TZ);
            WORLD_CORD[x].LONG_TZ := WORLD_CORD[x].LONG_TZ * 0.01745330;
            write('Enter the city <CR> if none ==>');
            readln(CITY);
            if CITY = '' then WORLD_CORD[x].CITY := 'None'
            else WORLD_CORD[x].CITY := CITY;
            SORT(WORLD_CORD,LAST - 1);
            rewrite(WORLD_FILE);
            for x := 1 to LAST - 1 do
                write(WORLD_FILE,WORLD_CORD[x]);
         end;
         if ((CHOICE = 'd') or (CHOICE = 'D')) then
         begin
            write('Which entry do you want deleted ==>');
            readln(x);
            WORLD_CORD[x] := WORLD_CORD[LAST - 1];
            LAST := LAST - 1;
            SORT(WORLD_CORD,LAST - 1);
            rewrite(WORLD_FILE);
            for x := 1 to LAST - 1 do
                write(WORLD_FILE,WORLD_CORD[x]);
         end;
         close(WORLD_FILE);
      end;
  9 : DONE := true;
  end;  {CASE statement}
until DONE;
setdate(YEAR2,MONTH2,DAY2);
end; {MAIN begin}
end.