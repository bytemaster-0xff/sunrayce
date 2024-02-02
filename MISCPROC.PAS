unit miscproc;

INTERFACE

function I_TO_S(NUM : integer):string;
function FILE_NAME:string;
procedure GET_NEW_TIME(var HOUR,MINUTE:integer);
procedure GET_NEW_DATE(var MONTH,DAY,YEAR:integer);
procedure DRAW_BOX(X1,Y1,X2,Y2:integer);

IMPLEMENTATION
uses dos,crt;


{***************************************************************************
procedure to convert an integer to a string
***************************************************************************}
function I_TO_S(NUM : integer):string;
type
OUT_array = array [1..6] of integer;
var

LAST : integer;
x : integer;
DIGIT : integer;
out : out_array;
begin
x := 1;
while NUM > 0 do begin
   DIGIT := NUM mod 10;
   NUM :=NUM div 10;
   OUT[x] := digit + 48;
   x := X + 1;
end;
LAST := x-1;
writeln;
for x := last downto 1 do
     I_TO_S[x] := chr(OUT[last+1-x]);
I_TO_S[0] := chr(last);
end;


{**************************************************************************
function to find the file name for the current date
**************************************************************************}
function FILE_NAME: string;
var
  YEAR,DAY,MONTH,DOW : word;
begin
   getdate(YEAR,MONTH,DAY,DOW);
   case month of
     2 : DAY := DAY + 31;
     3 : DAY := DAY + 59;
     4 : DAY := DAY + 90;
     5 : DAY := DAY + 120;
     6 : DAY := DAY + 151;
     7 : DAY := DAY + 181;
     8 : DAY := DAY + 212;
     9 : DAY := DAY + 243;
    10 : DAY := DAY + 273;
    11 : DAY := DAY + 304;
    12 : DAY := DAY + 334;
   end;
   FILE_NAME := 'A:WORLDCRD.'+I_TO_S(DAY);
   writeln
end;


procedure GET_NEW_TIME(var HOUR,MINUTE:integer);
var
  DONE : boolean;
  TIMES : string[5];
  x,y :integer;
begin
DONE := false;
readln(TIMES);
if TIMES[2] = ':' then
begin
   HOUR := ord(TIMES[1]) - 48;
   MINUTE := ((ord(TIMES[3]) - 48) * 10)+(ord(TIMES[4]) - 48);;
   DONE := true;
end
else
begin
   HOUR := ord(TIMES[2]) - 38;
   MINUTE := ((ord(TIMES[4]) - 48) * 10)+(ord(TIMES[5]) - 48);
   DONE := true;
end;
end;


procedure GET_NEW_DATE(var MONTH,DAY,YEAR : integer);
var
  DATES : string[8];
begin
readln(DATES);
if ((DATES[2] = '/') and (DATES[4] = '/')) then
begin
   MONTH := ord(DATES[1]) - 48;
   DAY := ord(DATES[3]) - 48;
   YEAR := (ord(DATES[5])-48)*10 + (ord(DATES[6])-48) + 1900;
end;
if ((DATES[3] = '/') and (DATES[5] = '/')) then
begin
   MONTH :=(ord(DATES[1])-48)*10 + (ord(DATES[2])-48);
   DAY := ord(DATES[4]) -48;
   YEAR := (ord(DATES[6])-48)*10 + (ord(DATES[7])-48) + 1900;
end;
if ((DATES[2] = '/') and (DATES[5] = '/')) then
begin
   MONTH := ord(DATES[1]) -48;
   DAY := (ord(DATES[3])-48)*10 + (ord(DATES[4])-48);
   YEAR := (ord(DATES[6])-48)*10 + (ord(DATES[7])-48) + 1900;
end;
if ((DATES[3] = '/') and (DATES[6] = '/')) then
begin
   MONTH := (ord(DATES[1])-48)*10 + (ord(DATES[2])-48);
   DAY := (ord(DATES[4])-48)*10 + (ord(DATES[5])-48);
   YEAR := (ord(DATES[7])-48)*10 + (ord(DATES[8])-48) + 1900;
end;
end;  {procedure GET_NEW_DATE}

procedure DRAW_BOX(X1,Y1,X2,Y2:integer);
var
   x : integer;
begin
     for x := X1 + 1 to X2 - 1 do
     begin
          gotoxy(x,Y1);
          write(chr(205));
          gotoxy(x,Y2);
          write(chr(196));
     end;
     for x := Y1 +1 to Y2 - 1 do
     begin
          gotoxy(x1,x);
          write(chr(179));
          gotoxy(x2,x);
          write(chr(179));
     end;
     gotoxy(x1,y1);
     writeln(chr(213));
     gotoxy(x2,y1);
     write(chr(184));
     gotoxy(x1,y2);
     write(chr(192));
     gotoxy(x2,y2);
     write(chr(217));
end;

end.