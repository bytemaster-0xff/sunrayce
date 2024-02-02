program MAKE_ROAD_FILE;
uses CRT;
type
    ROAD_DATA = record
    MILE : integer;
    grade : real;
LENGTH_GRADE : real;
    end;

var
   ROAD_FILE : file of ROAD_DATA;
        ROAD : ROAD_DATA;
        DONE : boolean;
begin
     DONE := false;
     assign (ROAD_FILE,'a:ROAD.DAT');
     rewrite (ROAD_FILE);
     while not DONE do
     begin
          clrscr;
          with ROAD do
          begin
             write('Please enter the current mile ==>');
             readln(MILE);
             write('Please enter the Grade of the road in percent form ==>');
             readln(GRADE);
             GRADE := GRADE / 100;
             write('Please enter the Length of that grade ==>');
             readln(LENGTH_GRADE);
          end;
          if ROAD.MILE >= 0 then
             write(ROAD_FILE,ROAD)
          else DONE := true;
     end;
end.