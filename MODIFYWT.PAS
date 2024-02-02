unit  MODIFYWT;

interface

procedure MODIFY_WEATHER;

implementation

uses crt,miscproc;

procedure MODIFY_WEATHER;
type
WEATHER_TYPE = record
  WIND_SPEED : integer;
  WIND_DIR : integer;
  HOUR : integer;
  MINUTE : integer;
  CLOUDS : real;
        end;

WEATHER_ARRAY = array [1..200] of WEATHER_TYPE;

var
   last,x,clouds : integer;
   WEATHER : WEATHER_ARRAY;
   WEATHER2 : WEATHER_TYPE;
   WEATHER_FILE : file of WEATHER_TYPE;
   CHOICE : char;
   CHOICE2 : integer;
   SPACE : string[2];
   PRINTER : TEXT;
   DONE : boolean;


procedure SORT(var WEATHER : WEATHER_ARRAY; NUMBER:integer);
var
   I,J : integer;
   TEMP : WEATHER_TYPE;
   CLOUDS : integer;
   CHOICE : integer;

begin
for I := 2 to NUMBER do
  for J := 1 to I - 1 do
  begin
    if (WEATHER[J].HOUR > WEATHER[I].HOUR) then
    begin
       TEMP := WEATHER[I];
       WEATHER[I] := WEATHER[J];
       WEATHER[J] := TEMP;
    end;
    if ((WEATHER[J].HOUR = WEATHER[I].HOUR) and (WEATHER[J].MINUTE > WEATHER[I].MINUTE)) then
    begin
       TEMP := WEATHER[I];
       WEATHER[I] := WEATHER[J];
       WEATHER[J] := TEMP;
    end;


  end;
end;

begin
  DONE := false;
  repeat
  clrscr;
  gotoxy(1,8);
  writeln;
  writeln('                           1...Create Weather File.');
  writeln('                           2...Print Weather File.');
  writeln('                           3...Modify Weather File.');
  writeln('                           9...Exit.');
  writeln;
  write('                               Choice ==>');
  DRAW_BOX(25,7,55,16);
  gotoxy(33,7);
  write('  Weather File  ');
  gotoxy(42,14);
  readln(CHOICE2);

  case (CHOICE2) of
    1 : begin
          clrscr;
          DONE := false;
          assign (WEATHER_FILE,'A:WEATHER.DAT');
          rewrite (WEATHER_FILE);
          while not DONE do
          begin
               with WEATHER2 do
               begin
                  clrscr;
                  write('Enter the starting time of the weather ==>');
                  GET_NEW_TIME(HOUR,MINUTE);
                  write('Enter the Wind Speed ==>');
                  readln(WIND_SPEED);
                  write('Enter the Wind Direction ==>');
                  readln(WIND_DIR);
                  write('Enter the predicted percentage of Clouds ==>');
                  readln(CLOUDS);
                  CLOUDS := CLOUDS / 100;
               end;
               if WEATHER2.WIND_SPEED < 0 then DONE := true
               else write(WEATHER_FILE,WEATHER2);
          end;
          close(WEATHER_FILE);
        end;

    2 : begin
          assign(printer,'LPT1');
          assign(WEATHER_FILE,'A:WEATHER.DAT');
          reset(WEATHER_FILE);
          rewrite(PRINTER);
          while not (EOF (WEATHER_FILE)) do
          begin
             read(WEATHER_FILE,WEATHER2);
             if WEATHER2.MINUTE < 10 then SPACE := ':0'
             else SPACE := ':';
             writeln(printer,WEATHER2.HOUR,SPACE,WEATHER2.MINUTE,'  ',WEATHER2.WIND_SPEED,
             '  ',WEATHER2.WIND_DIR,'  ',round(100*WEATHER2.CLOUDS));
          end;
          close(WEATHER_FILE);
          close(PRINTER);
        end;{Print weather file}



 3 : begin
       assign (WEATHER_FILE,'A:WEATHER.DAT');
       clrscr;
       x := 1;
       reset (WEATHER_FILE);
       while not eof(WEATHER_FILE) do
       begin
          read (WEATHER_FILE,WEATHER[x]);
          x := X + 1;
       end;
       LAST := x;
       for x := 1 to LAST-1 do
       begin
          CLOUDS := trunc(WEATHER[x].CLOUDS * 100);
          if WEATHER[x].MINUTE < 10 then SPACE := ':0'
          else SPACE := ':';
          writeln(x,'.  ',WEATHER[x].HOUR,SPACE,WEATHER[x].MINUTE,'  ',WEATHER[x].WIND_DIR,
                  '   ',WEATHER[x].WIND_SPEED,'  ',CLOUDS);
       end;
       writeln;
       writeln;
       write('Modify or Add or Delete or Redisplay (M/A/D/Q)?');
       readln(choice);
       if ((choice = 'm') or (choice = 'M')) then
       begin
          write('Enter the number to modify ==>');
          readln(x);
          write('Enter the Wind Direction ==>');
          readln(WEATHER[x].WIND_DIR);
          write('Enter the Wind Speed (MPH) ==>');
          readln(WEATHER[x].WIND_SPEED);
          write('Enter the percentage of clouds ==>');
          readln(WEATHER[x].CLOUDS);
          WEATHER[x].CLOUDS := WEATHER[x].CLOUDS / 100;
          rewrite(WEATHER_FILE);
          for x := 1 to LAST - 1 do
             write(WEATHER_FILE,WEATHER[x]);
       end;
       if ((CHOICE = 'A') or (CHOICE = 'a')) then
       begin
          clrscr;
          x := LAST;
          LAST := LAST + 1;
          write('Enter the starting time of the weather ==>');
          GET_NEW_TIME(WEATHER[x].HOUR,WEATHER[x].MINUTE);
          write('Enter the Wind Direction ==>');
          readln(WEATHER[x].WIND_DIR);
          write('Enter the Wind Speed (MPH) ==>');
          readln(WEATHER[x].WIND_SPEED);
          write('Enter the percentage of clouds ==>');
          readln(WEATHER[x].CLOUDS);
          WEATHER[x].CLOUDS := WEATHER[x].CLOUDS / 100;
          SORT(WEATHER,LAST - 1);
          rewrite(WEATHER_FILE);
          for x := 1 to LAST - 1 do
             write(WEATHER_FILE,WEATHER[x]);
       end;
     if ((CHOICE = 'd') or (CHOICE = 'D')) then
     begin
       write('Which entry do you want deleted ==>');
       readln(x);
       WEATHER[x] := WEATHER[LAST - 1];
       LAST := LAST - 1;
       SORT(WEATHER,LAST - 1);
       rewrite(WEATHER_FILE);
       for x := 1 to LAST - 1 do
           write(WEATHER_FILE,WEATHER[x]);
       end;
       close(WEATHER_FILE);
     end; { MODIFY FILE }
  9 : DONE := true;
  end; {CASE STATEMENT}
  until (DONE);
end;
end.