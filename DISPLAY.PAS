unit DISPLAY;

interface

procedure DISPLAY_OUTPUT;

implementation
uses graph,dos,crt,miscproc;
procedure DISPLAY_OUTPUT;
const
  BATT_MAX = 100;
type
   CORD_TYPE = record
         DAY : integer;
        MILE : integer;
   DIRECTION : integer;
        CITY : string[20];
         LAT : real;
       LONG1 : real;
       LONG2 : real;
         end;

         MISC_TYPE = record
         AH_METER : real;
       end_AH_METER : real;
         TIME : real;
         MILE : integer;
   LAST_MILE : integer;
         SUN : real;
      AVG_SUN : real;
          MPH : real;
      AVG_MPH : real;
      CELL_EFF : real;
      CELL_CONFIG : integer;
      FORCE : real;
      mass : real;
      ROLLING_RESISTANCE : real;
      OVER_EFF : real;
      SUN_POWER : real;
      WORK_POWER : real;
      MILE_FLIP : integer;
      START_TIME : integer;
          end;

      WEATHER_TYPE = record
      WIND_SPEED : integer;
      WIND_DIR : integer;
      HOUR : integer;
      MINUTE : integer;
      CLOUDS : real;
      end;

          XY_TYPE = record
           X : integer;
           Y : integer;
         end;

         POWER_TYPE = record
         sun : real;
         out : real;
         end;

     CORD_ARRAY = array [1..50] of CORD_TYPE;
     MAP_ARRAY = array [1..50] of XY_TYPE;
var
   GRAPH_DRIVER : integer;
   GRAPH_MODE : integer;
   wait : char;
   x,config : integer;
  HOUR,MINUTE,SEC,HH: word;
  MINUTES,HOURS,TIME: string[5];
  LAST_MILE : integer;

procedure DRAW_CAR(X,Y:integer);
begin
  line(x-2,y+2,x+2,y+2);
  line(x-2,y+2,x-2,y-1);
  line(x-2,y-1,x,y-3);
  line(x,y-3,x+2,y-1);
  line(x+2,y-1,x+2,y+2);
end;

procedure PRINT_MAP;
var
  CORD_FILE : file of CORD_TYPE;
  CORD : CORD_ARRAY;
  MAP : MAP_ARRAY;
  LAST : integer;
  HEADING : real;
  YEAR,MONTH,DAY,DOW : word;
  MISC_FILE : file of MISC_TYPE;
  MISC : MISC_TYPE;
  ON_MAP : boolean;
  dist : integer;
  XCAR, YCAR : integer;
  x :integer;

begin
   assign(CORD_FILE,FILE_NAME);
   reset(CORD_FILE);
   assign(MISC_FILE,'A:MISC.DAT');
   reset(MISC_FILE);
   seek(MISC_FILE,filesize(MISC_FILE)-1);
   read(MISC_FILE,MISC);
   x := 1;
   while not eof(CORD_FILE) do
   begin
        read(CORD_FILE,CORD[x]);
        x := x + 1;
   end;
   ON_MAP := false;
   config := MISC.CELL_CONFIG;
   LAST_MILE := MISC.LAST_MILE;
   LAST := x - 1;
   MAP[1].X := 0;
   MAP[1].Y := 0;
   setlinestyle(0,1,0);
   for x := 2 to LAST do
   begin
     HEADING := CORD[x-1].DIRECTION * 0.0174530;
     if ((CORD[x].MILE > MISC.MILE) and (not ON_MAP)) then
     begin
        ON_MAP := true;
        dist := MISC.MILE - CORD[x-1].MILE;
        XCAR := 150 + round(2*sin(HEADING) * dist) + MAP[x-1].x;
        YCAR := 180 - abs(round(2*cos(HEADING) * dist) + MAP[x-1].y);
        DRAW_CAR(XCAR,YCAR);
     end;
     MAP[X].X := round(2*sin(HEADING) * (CORD[x].MILE-CORD[x-1].MILE))+MAP[x-1].X;
     MAP[X].Y := round(2*cos(HEADING) * (CORD[x].MILE-CORD[x-1].MILE))+MAP[x-1].Y;
   end;
   for X := 2 to LAST do
      line(MAP[x-1].x+150,180-MAP[x-1].Y,MAP[x].X+150,180-MAP[x].Y);
   setlinestyle(0,1,0);
   line(165,50,170,20);
   line(170,20,175,50);
   circle(170,40,20);
   outtextxy(175,25,'N');
   close(MISC_FILE);
end;

procedure GRAPH_STATS;
var
  MISC : MISC_TYPE;
  MISC_FILE : file of MISC_TYPE;
  WEATHER : WEATHER_TYPE;
  WEATHER_FILE : file of WEATHER_TYPE;
  x : integer;
  MINUTE,DAY,YEAR,MONTH,HOUR,DOW,SEC,HH:word;
  MILES_LEFT :integer;
  DATE,TIME,MINUTES,HOURS:string[10];
  MINUTER : real;
  MONTHS,DAYS,YEARS : string[4];
begin
   setlinestyle(0,1,3);
   assign (MISC_FILE,'A:MISC.DAT');
   reset(MISC_FILE);
   assign (WEATHER_FILE,'A:WEATHER.DAT');
   reset(WEATHER_FILE);
   seek(MISC_FILE,filesize(MISC_FILE)-1);
   read(MISC_FILE,MISC);
   outtextxy(300,175,'Mile:');
   outtextxy(340,175,I_TO_S(MISC.MILE_FLIP));
   getdate(YEAR,MONTH,DAY,DOW);
   MONTHS := i_to_s(MONTH);
   DAYS := i_to_s(DAY);
   YEARS := i_to_s(YEAR);
   YEARS[1] := YEARS[3];
   YEARS[2] := YEARS[4];
   YEARS[0] := chr(2);
   DATE := MONTHS + '/' +DAYS + '/'+YEARS;
   outtextxy(290,5,DATE);
   case MONTH of
      2: DAY := DAY +31;
      3: DAY := DAY +59;
      4: DAY := DAY +90;
      5: DAY := DAY +120;
      6: DAY := DAY +151;
      7: DAY := DAY +181;
      8: DAY := DAY +212;
      9: DAY := DAY +243;
      10: DAY := DAY +273;
      11: DAY := DAY +304;
      12: DAY := DAY +334;
   end;
   if DAY < 190 then DAY := 0
   else DAY := DAY - 189;
   outtextxy(470,5,i_to_s(DAY));
   x := trunc(MISC.SUN_POWER);
   line(300,143,300+x,143);
   x := trunc(MISC.WORK_POWER);
   line(300,123,300+x,123);
   x := trunc((MISC.AH_METER/BATT_MAX) * 100);
   line(300,133,300+x,133);
   outtextxy(450,107,'MPH');
   outtextxy(420,107,i_to_s(round(MISC.MPH)));
   MILES_LEFT := MISC.LAST_MILE - MISC.MILE;
   MINUTER := 60 * MILES_LEFT / MISC.MPH;
   MINUTER := MISC.START_TIME + MISC.TIME + MINUTER;
   HOUR := trunc(MINUTER) div 60;
   MINUTE := trunc(MINUTER) mod 60;
   MINUTES := i_to_s(MINUTE);
   if MINUTE < 10 then MINUTES := '0'+MINUTES;
   TIME := i_to_s(HOUR) + ':' + MINUTES;
   outtextxy(420,95,TIME);
   while not eof(WEATHER_FILE) do
   begin
      read(WEATHER_FILE,WEATHER);
      case(WEATHER.HOUR) of
         8: begin
              x := round((WEATHER.WIND_SPEED / 40)*100);
              line(250,33,250+x,33);
              x := trunc(WEATHER.CLOUDS*100);
              line(450,33,450+x,33);
            end;
         9: begin
              x := round((WEATHER.WIND_SPEED / 40)*100);
              line(250,41,250+x,41);
              x := trunc(WEATHER.CLOUDS*100);
              line(450,41,450+x,41);
            end;
       10 : begin
              x := round((WEATHER.WIND_SPEED / 40)*100);
              line(250,49,250+x,49);
              x := trunc(WEATHER.CLOUDS*100);
              line(450,49,450+x,49);
            end;
       11 : begin
              x := round((WEATHER.WIND_SPEED / 40)*100);
              line(250,57,250+x,57);
              x := trunc(WEATHER.CLOUDS*100);
              line(450,57,450+x,57);
            end;
       12 : begin
              x := round((WEATHER.WIND_SPEED / 40)*100);
              line(250,65,250+x,65);
              x := trunc(WEATHER.CLOUDS*100);
              line(450,65,450+x,65);
            end;
       13 : begin
              x := round((WEATHER.WIND_SPEED / 40)*100);
              line(250,73,250+x,73);
              x := trunc(WEATHER.CLOUDS*100);
              line(450,73,450+x,73);
            end;
       14 : begin
              x := round((WEATHER.WIND_SPEED / 40)*100);
              line(250,81,250+x,81);
              x := trunc(WEATHER.CLOUDS*100);
              line(450,81,450+x,81);
           end;
      15 : begin
              x := round((WEATHER.WIND_SPEED / 40)*100);
              line(250,89,250+x,89);
              x := trunc(WEATHER.CLOUDS*100);
              line(450,89,450+x,89);
           end;
      end;  {case}
   end;{while not EOF}
close(WEATHER_FILE);
close(MISC_FILE);
end;  {GRAPH STATS}

procedure GRAPH_POWER;
var
  x1,y1,y2,y3,y4,x:integer;
  POWER_FILE : file of POWER_TYPE;
      POWER : POWER_TYPE;

begin
     assign(POWER_FILE,'A:POWER.DAT');
     reset(POWER_FILE);
     read(POWER_FILE,POWER);
     y1 := 180-round(power.sun / 4);
     y3 := 180-round(power.out / 4);
     for x := 2 to LAST_MILE - 1 do
     begin
          read(POWER_FILE,POWER);
          y2 := 180-round(power.sun / 4);
          x1 := 450+x;
          line(x1,y1,x1+1,y2);
          y1 := y2;
          y4 := 180-round(power.out / 4);
          line(x1,y3,x1+1,y4);
          y3 := y4;
     end;
     close(POWER_FILE);
     setlinestyle(0,1,3);
end;

begin
     GRAPH_DRIVER := detect;
     initgraph(GRAPH_DRIVER,GRAPH_MODE,'driver');
     SETLINESTYLE(0,1,3);
     line(200,0,200,200);
     line(0,0,200,0);
     line(0,0,0,200);
     line(0,200,640,200);
     line(640,150,640,200);
     PRINT_MAP;
     setlinestyle(0,1,0);
     GRAPH_POWER;
     line(200,150,640,150);
     line(420,150,420,200);
     setlinestyle(0,1,1);
     circle(250,180,15);
     circle(250,180,3);
     line(230,180,235,180);
     line(265,180,270,180);
     line(230,175,230,185);
     line(270,175,270,185);
     if CONFIG = 1 then line(228,180,272,160);
     if CONFIG = 2 then line(228,160,272,180);
     if CONFIG = 3 then
     begin
        line(228,160,250,170);
        line(250,170,232,160);
     end;
     settextstyle(0,0,1);
     outtextxy(250,5,'Date');
     outtextxy(350,5,'Day into race');
     outtextxy(500,5,'Time');
     outtextxy(250,14,'Predicted Wind          Predicted Clouds');
     for x := 1 to 8 do outtextxy(225,x*8 + 21,i_to_s(x+7));
     outtextxy(220,95,'Estimated Finish Time :');
     outtextxy(220,107,'Optimum Cruising vel. :');
     outtextxy(220,119,'POWER   :');
     outtextxy(220,129,'BATTERY :');
     outtextxy(220,139,'SUN     :');
     outtextxy(300,160,'Flip Panel');
     outtextxy(450,140,'Sun vs. Power Used');
     GRAPH_STATS;
     gettime(HOUR,MINUTE,SEC,HH);
     MINUTES := I_TO_S(MINUTE);
     if MINUTE < 10 then MINUTES := '0'+MINUTES;
     HOURS := i_to_s(HOUR);
     if hour = 0 then HOURS := '24';
     TIME := HOURS + ':' + MINUTES;
     outtextxy(540,5,TIME);
     read(wait);
     closegraph;
end;
end.