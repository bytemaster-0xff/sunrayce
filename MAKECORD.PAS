program MAKE_CORD_FILE;
uses crt;
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

var
   WORLD_CORD : WORLD_CORD_TYPE;
   WORLD_CORD_FILE : file of WORLD_CORD_TYPE;
           DONE : boolean;
           correct : char;
begin
    clrscr;
    DONE := false;
    write('Please enter the day ==>');
    readln(WORLD_CORD.DAY);
    case WORLD_CORD.DAY of
         1 : assign(WORLD_CORD_FILE,'A:WORLDC1.DAT');
         2 : assign(WORLD_CORD_FILE,'A:WORLDC2.DAT');
         3 : assign(WORLD_CORD_FILE,'A:WORLDC3.DAT');
         4 : assign(WORLD_CORD_FILE,'A:WORLDC4.DAT');
         5 : assign(WORLD_CORD_FILE,'A:WORLDC5.DAT');
         6 : assign(WORLD_CORD_FILE,'A:WORLDC6.DAT');
         7 : assign(WORLD_CORD_FILE,'A:WORLDC7.DAT');
         8 : assign(WORLD_CORD_FILE,'A:WORLDC8.DAT');
         9 : assign(WORLD_CORD_FILE,'A:WORLDC9.DAT');
         10 : assign(WORLD_CORD_FILE,'A:WORLDC10.DAT');
         11 : assign(WORLD_CORD_FILE,'A:WORLDC11.DAT');
         12 : assign(WORLD_CORD_FILE,'A:WORLDC12.DAT');
    end;
    rewrite(WORLD_CORD_FILE);
    while (not DONE) do
    begin
      with WORLD_CORD do
      begin
         clrscr;
         write('Please enter the mile ==>');
         readln(MILE);
         write('Please enter the direction ==>');
         readln(DIRECTION);
         write('Please enter the Current Lattitude ==>');
         readln(LAT);
         LAT := LAT * 0.01745330;
         write('Please enter the Current Longitude ==>');
         readln(LONG_LOC);
         LONG_LOC := LONG_LOC * 0.01745330;
         write('Please enter the Longitude of the Time Zone ==>');
         readln(LONG_TZ);
         LONG_TZ := LONG_TZ * 0.01745330;
         write('Please enter the City <CR> if none ==>');
         readln(CITY);
         if (CITY = '') then city := 'None';
      end;
      if (WORLD_CORD.MILE >= 0 ) then
          begin
             writeln;
             write('Is this information correct (Y/N)?');
             readln(correct);
             if ((CORRECT = 'Y') or (CORRECT = 'y')) then
                 write(WORLD_CORD_FILE,WORLD_CORD);
          end
      else
          DONE := true;
    end;
end.
