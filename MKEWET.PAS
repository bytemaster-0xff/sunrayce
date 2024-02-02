program MAKE_WEATHER_FILE;
uses CRT;
type
    WEATHER_DATA = record
    WIND_SPEED : integer;
    WIND_DIR : integer;
    HOUR : integer;
    MINUTE : integer;
    CLOUDS : real;
    end;

var
   WEATHER_FILE : file of WEATHER_DATA;
        WEATHER : WEATHER_DATA;
        DONE : boolean;
begin
     clrscr;
     DONE := false;
     assign (WEATHER_FILE,'A:WEATHER.DAT');
     rewrite (WEATHER_FILE);
     while not DONE do
     begin
          with WEATHER do
          begin
          write('Please enter the predicted wind speed ==>');
          readln(WIND_SPEED);
          write('Please enter the predicted Wind Direction ==>');
          readln(WIND_DIR);
          write('Please enter the percent clouds ==>');
          readln(CLOUDS);
          CLOUDS := CLOUDS / 100;
          write('Please enter the Hour of this weather ==>');
          readln(HOUR);
          write('Please enter the Minute of this weather ==>');
          readln(MINUTE);
          end;
          write(WEATHER_FILE,WEATHER);
          if WEATHER.HOUR < 0 then DONE := true;
          clrscr;
     end;
end.