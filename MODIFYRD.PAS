unit MODIFYRD;

interface

procedure MODIFY_ROAD;

implementation

uses miscproc,crt;

procedure MODIFY_ROAD;

type
  ROAD_TYPE = record
          MILE : integer;
         GRADE : real;
  LENGTH_GRADE : real;
     end;

ROAD_ARRAY = array [1..200] of ROAD_TYPE;

var
   last,x : integer;
   ROAD : ROAD_ARRAY;
   ROAD_FILE : file of ROAD_TYPE;
   CHOICE : char;
   CHOICE2 : integer;
   ROAD2 : ROAD_TYPE;
   grade,length : integer;
   DONE : boolean;
   PRINTER : text;

procedure SORT(var ROAD : ROAD_ARRAY; NUMBER:integer);
var
   I,J : integer;
   TEMP : ROAD_TYPE;

begin
for I := 2 to NUMBER do
  for J := 1 to I - 1 do
  begin
    if (ROAD[J].MILE > ROAD[I].MILE) then
    begin
       TEMP := ROAD[I];
       ROAD[I] := ROAD[J];
       ROAD[J] := TEMP;
    end;
  end;
end;

begin
repeat
DONE := false;
   clrscr;
   gotoxy(1,8);
   writeln('                            1...Create Road File.');
   writeln('                            2...Print Road File.');
   writeln('                            3...Modify Road File.');
   writeln('                            9...Exit.');
   writeln;
   write('                               Choice ==>');
   DRAW_BOX(25,6,55,15);
   gotoxy(33,6);
   writeln('  Road Menu  ');
   gotoxy(42,13);
   readln(CHOICE2);
case CHOICE2 of
1: begin
      assign(ROAD_FILE,'A:ROAD.DAT');
      rewrite(ROAD_FILE);
      while not DONE do
      begin
         clrscr;
         write('Enter the Mile ==>');
         readln(ROAD2.MILE);
         write('Enter the grade ==>');
         readln(ROAD2.GRADE);
         ROAD2.GRADE := ROAD2.GRADE / 100;
         write('Enter the length of that grade ==>');
         readln(ROAD2.LENGTH_GRADE);
         if ROAD2.MILE > 0 then write(ROAD_FILE,ROAD2)
         else DONE := true;
      end;
      close(ROAD_FILE);
   end;


2: begin
      assign(PRINTER,'LPT1');
      assign(ROAD_FILE,'A:ROAD.DAT');
      reset(ROAD_FILE);
      rewrite(PRINTER);
      while not eof(ROAD_FILE) do
      begin
         read(ROAD_FILE,ROAD2);
         grade := round(ROAD[x].GRADE * 100);
         length := round(ROAD[x].LENGTH_GRADE * 10);
         writeln(printer,'  ',ROAD[x].MILE,'  ',grade,'  ',length);
      end;
      close(PRINTER);
      close(ROAD_FILE);
   end;


3: begin
     assign (ROAD_FILE,'A:ROAD.DAT');
     clrscr;
     x := 1;
     reset (ROAD_FILE);
     while not eof(ROAD_FILE) do
     begin
        read (ROAD_FILE,ROAD[x]);
        x := X + 1;
     end;
     LAST := x;
     for x := 1 to LAST-1 do
     begin
        grade := round(ROAD[x].GRADE * 100);
        length := round(ROAD[x].LENGTH_GRADE * 10);
        writeln(x,'.  ',ROAD[x].MILE,'  ',grade,'  ',length);
     end;
     writeln;
     writeln;
     write('Modify or Add or Delete or Redisplay (M/A/D/Q)?');
     readln(choice);
     if ((choice = 'm') or (choice = 'M')) then
     begin
        write('Enter the number to modify ==>');
        readln(x);
        write('Enter the grade ==>');
        readln(ROAD[x].GRADE);
        ROAD[x].GRADE := ROAD[x].GRADE / 100;
        write('Enter the length ==>');
        readln(ROAD[x].LENGTH_GRADE);
        rewrite(ROAD_FILE);
        for x := 1 to LAST - 1 do
           write(ROAD_FILE,ROAD[x]);
     end;
     if ((CHOICE = 'A') or (CHOICE = 'a')) then
     begin
        clrscr;
        x := LAST;
        LAST := LAST + 1;
        write('Enter the Mile ==>');
        readln(ROAD[x].MILE);
        write('Enter the grade ==>');
        readln(ROAD[x].GRADE);
        ROAD[x].GRADE := ROAD[x].GRADE / 100;
        write('Enter the length of that grade ==>');
        readln(ROAD[x].LENGTH_GRADE);
        SORT(ROAD,LAST - 1);
        rewrite(ROAD_FILE);
        for x := 1 to LAST - 1 do
           write(ROAD_FILE,ROAD[x]);
     end;
     if ((CHOICE = 'd') or (CHOICE = 'D')) then
     begin
        write('Which entry do you want deleted ==>');
        readln(x);
        ROAD[x] := ROAD[LAST - 1];
        LAST := LAST - 1;
        SORT(ROAD,LAST - 1);
        rewrite(ROAD_FILE);
        for x := 1 to LAST - 1 do
           write(ROAD_FILE,ROAD[x]);
     end;
     close(ROAD_FILE);
  end;  {End modify case}
9: DONE := true;
end;  {Case statement}
until (DONE);
end;
end.