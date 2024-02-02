{$M 22000,65536,655360}
{$S+}
program FIND_POWER;
uses CRT,DOS,GRAPH,MODIFYCR,MODIFYRD,MODIFYWT,MISCPROC,DISPLAY,OPENSCRN,SHOWELV;
const
     TIME_CONST = -6;   {Time constant for month of July}
     GRAVITY = 9.8;

type
  WIND_POINTER = ^WEATHER_TIME;

     ROAD_DATA = record
          MILE : integer;
         GRADE : real;
  LENGTH_GRADE : real;
           end;

  WEATHER_TYPE = record
    WIND_SPEED : integer;
      WIND_DIR : integer;
          HOUR : integer;
        MINUTE : integer;
        CLOUDS : real;
           end;

    POWER_DATA = record
     SUN_POWER : real;
    WORK_POWER : real;
           end;

  WEATHER_TIME = record
        MINUTE : integer;
        CLOUDS : real;
    WIND_SPEED : integer;
      WIND_DIR : integer;
          NEXT : WIND_POINTER;
           end;

     MISC_DATA = record
      AH_METER : real;
  END_AH_METER : real;
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
          MASS : real;
    ROLLING_RESISTANCE : real;
       OVER_EFF : real;
       SUN_POWER:real;
       OUT_POWER : real;
       FLIP_MILE :integer;
       START_TIME :integer;
           end;

WORLD_CORD_TYPE = record
           DAY : integer;
          MILE : integer;
     DIRECTION : integer;
       CITY : string[20];
           LAT : real;
       LONG_TZ : real;
      LONG_LOC : real;
           end;

ROAD_DATA_ARRAY = array [1..200] of ROAD_DATA;
WORLD_CORD_ARRAY = array [1..200] of WORLD_CORD_TYPE;
WEATHER_DATA_ARRAY = array [1..50] of WEATHER_TYPE;
POWER_ARRAY = array [1..200] of POWER_DATA;

var
CHOICE : integer;
DONE : boolean;
WAIT : char;

procedure BACK_UP_FILES;
begin
end;

procedure MODIFY_FILES;
var
  x : integer;
begin
repeat
    clrscr;
    for x := 1 to 9 do writeln;
    writeln('                          1...Weather File.');
    writeln('                          2...Road Condition File.');
    writeln('                          3...World Cooridinate File.');
    writeln('                          9...Main Menu.');
    writeln;
    write('                              Choice ==>');
    DRAW_BOX(24,8,56,17);
    gotoxy(33,8);
    write('  Modify File  ');
    gotoxy(41,15);
    readln(CHOICE);
    case CHOICE of
         1 : MODIFY_WEATHER;
         2 : MODIFY_ROAD;
         3 : MODIFY_CORD;
         9 : DONE := TRUE;
    end;
until DONE;
DONE := false;
end;

procedure STATS;
var
   MISC_FILE : file of MISC_DATA;
   MISC : MISC_DATA;
   HOUR,MINUTE,SECOND,HUND : word;
   SPACE : string[2];
   SPEED : real;

begin
    assign(MISC_FILE,'A:MISC.DAT');
    reset(MISC_FILE);
    seek(MISC_FILE,filesize(MISC_FILE)-1);
    read(MISC_FILE,MISC);
    gettime(HOUR,MINUTE,SECOND,HUND);
    clrscr;
    SPACE := ':';
    if MINUTE < 10 then SPACE := ':0';
    writeln;
    writeln('                          The Current Time is ',HOUR,SPACE,MINUTE);
    writeln;
    writeln;
    with MISC do
    begin
         HOUR := trunc(TIME) div 60;
         MINUTE := trunc(TIME) mod 60;
         SPACE := ':';
         if MINUTE < 10 then SPACE := ':0';
         HOUR := HOUR + 8;
         writeln('                    Last mile of todays course:  ==> ',LAST_MILE);
         writeln;
         writeln('         Last mile that the speed was computed:  ==> ',MILE);
         writeln;
         writeln('                Last speed that was calculated:  ==> ',trunc(MPH),' MPH');
         writeln;
         writeln('         Last time that the speed was computed:  ==> ',HOUR,SPACE,MINUTE);
         writeln;
         writeln('               Over all Efficiency for the Car:  ==> ',
                  trunc(OVER_EFF),'%');
         SPEED := (MILE / (TIME/60));
         writeln;
         writeln('         Average Speed of the Car so far today:  ==> ',
                  trunc(SPEED),' MPH');
         writeln;
         writeln('        Average Insolation Factor from the Sun:  ==> ',trunc(AVG_SUN),
                  ' W/m^2');
         writeln;
         writeln('                 The Insolation Factor at ',HOUR,SPACE,MINUTE,':  ==> ',
                  trunc(SUN),' W/m^2');
         writeln;
         writeln('            The Amp Hour meter reading at ',HOUR,SPACE,MINUTE,':  ==> ',
                  trunc(AH_METER),' aH');
    end;
    writeln;
    writeln('                                 <CR> to continue');
    read(SPACE);
end;


{****************************************************************************
  Procedure to graph the data in file POWER.DAT this will make a graph
showing the relationship of Power from the sun to Power used by the car
****************************************************************************}
procedure GRAPH_DATA;
var
   POWER_FILE : file of POWER_DATA;
   POWER2 : POWER_DATA;
   POWER : POWER_DATA;
   MISC_FILE : file of MISC_DATA;
   MISC : MISC_DATA;
   MILE : integer;
   Y1,Y2,Y3,Y4 : integer;
   x,y:integer;
   GRAPH_DRIVER : integer;
   GRAPH_MODE : integer;
       MILE2 : integer;

begin
     assign(POWER_FILE,'A:POWER.DAT');
     assign(MISC_FILE,'A:MISC.DAT');
     reset(MISC_FILE);
     reset(POWER_FILE);
     GRAPH_DRIVER := detect;
     INITGRAPH(GRAPH_DRIVER,GRAPH_MODE,'DRIVER');
     setlinestyle(0,1,3);
     line(0,0,640,0);
     line(0,0,0,200);
     line(0,200,640,200);
     line(640,0,640,200);
     setlinestyle(0,1,1);
     seek(MISC_FILE,filesize(MISC_FILE)-1);
     read(MISC_FILE,MISC);
     read(POWER_FILE,POWER);
     gotoxy(10,1);
     outtextxy(10,180,'Graph of Sun Power & Work Power vs mile');
     outtextxy(10,190,'Power used :              Power from sun:');
     setlinestyle(1,1,0);
     line(110,193,140,193);
     setlinestyle(0,1,0);
     line(350,193,380,193);
     Y1 := round(POWER.SUN_POWER) * 3;
     Y3 := round(POWER.WORK_POWER) * 3;
     Y1 := 150 - Y1;
     Y3 := 150 - Y3;
     for MILE := 2 to MISC.LAST_MILE do
     begin
          read(POWER_FILE,POWER2);
          Y2 := round(POWER2.SUN_POWER) * 3;
          Y4 := round(POWER2.WORK_POWER) * 3;
          Y2 := 150 - Y2;
          Y4 := 150 - Y4;
          if (MILE = MISC.MILE) then
          begin
               setlinestyle(2,1,0);
               line(MILE*3,160,MILE*3,0);
               outtextxy(MILE*3+4,160,'Current Position');
          end;
          MILE2 := MILE * 3;
          setlinestyle(0,1,0);
          line(MILE2-3,Y1,MILE2,Y2);
          setlinestyle(1,1,0);
          line(MILE2-3,Y3,MILE2,Y4);
          POWER := POWER2;
          Y1 := Y2;
          Y3 := Y4;
     end;
     read(WAIT);
     closegraph;
     close(POWER_FILE);
     close(MISC_FILE);
end;

procedure SET_TIME;
var
   hh,mm : integer;
   year,month,day : integer;
begin
     clrscr;
     write('Please enter the current time in the form HH:MM ==>');
     GET_NEW_TIME(HH,MM);
     write('Please enter the current date in the form MM/DD/YY ==>');
     GET_NEW_DATE(MONTH,DAY,YEAR);
     setdate(year,month,day);
     settime(hh,mm,00,00);
end;


{*****************************************************************************
  procedure to find the Latitude, Longitude and the Longitude of the time zone
that our car is in
*****************************************************************************}
procedure FIND_WORLD_CORD(var WORLD_CORD : WORLD_CORD_ARRAY;
                          LAST_MILE : integer);
var
   X,Y : integer;
   TEMP,DATA : WORLD_CORD_TYPE;
   WORLD_CORD_FILE : file of WORLD_CORD_TYPE;
   DAY,DAY1,YEAR,MONTH,DOW : word;
   FILE_EXIST : boolean;
begin
     assign(WORLD_CORD_FILE,FILE_NAME);
     reset(WORLD_CORD_FILE);
     X := 1;
     if filesize(WORLD_CORD_FILE) = 1 then
     begin
          read(WORLD_CORD_FILE,DATA);
          for x := 1 to LAST_MILE do WORLD_CORD[x] := DATA;
     end
     else
     begin
       read(WORLD_CORD_FILE,DATA);
       read(WORLD_CORD_FILE,TEMP);
       while not (eof (WORLD_CORD_FILE)) do
       begin
          if TEMP.MILE = X then
          begin
             DATA := TEMP;
             read(WORLD_CORD_FILE,TEMP);
          end;
          WORLD_CORD[X] := DATA;
          WORLD_CORD[X].MILE := X;
          X := X + 1;
       end;  {while loop}
       close(WORLD_CORD_FILE);
       for Y := X to LAST_MILE do
          begin
             WORLD_CORD[Y] := TEMP;
             WORLD_CORD[Y].MILE := Y;
          end;
       end;
end;


{***************************************************************************
  This procedure will change the constants for our car this routine should
only be run durring initial testing of the car!!!!
***************************************************************************}
procedure CHANGE_CONSTANTS;
var
   MISC : MISC_DATA;
   MISC_FILE : file of MISC_DATA;
   CONTINUE : char;
begin
     clrscr;
     writeln('                WARNING!!!!!!    WARNING!!!!!!    WARNING!!!!!!');
     writeln;
     writeln('  This will change all of the Constants for the Northern Lights Vehice');
     write('Are you sure you want to do this (Y/N) ');
     readln(CONTINUE);
     clrscr;
     if ((CONTINUE = 'Y') or (CONTINUE = 'y')) then begin
        assign(MISC_FILE,'A:MISC.DAT');
       { reset(MISC_FILE);
        seek(MISC_FILE,filesize(MISC_FILE)-1);
        read(MISC_FILE,MISC);}
        erase(MISC_FILE);
        rewrite(MISC_FILE);
        clrscr;
        write('Enter the Efficeincy of the Cells (%) ==>');
        readln(MISC.CELL_EFF);
        write('Enter the Force Constant of the car (drag) ==>');
        readln(MISC.FORCE);
        write('Enter the Rolling resistance of the car ==>');
        readln(MISC.ROLLING_RESISTANCE);
        write('Enter the Mass of the Car including the drivers (KG) ==>');
        readln(MISC.MASS);
        write('Enter the Over All Efficeincy of the car (%) ==>');
        readln(MISC.OVER_EFF);
        MISC.AVG_SUN := 0;
        write(MISC_FILE,MISC);
        close(MISC_FILE);
     end;
end;


procedure DISPLAY_SCREENS;
var
x:integer;
begin
     clrscr;
     for x := 1 to 7 do writeln;
     writeln('                          1...Display Output Screen');
     writeln('                          2...Display Statistics');
     writeln('                          3...Graph Mile Vs. Power');
     writeln('                          4...Display Elevation');
     writeln('                          9...Main Menu');
     writeln;
     write('                              Choice ==>');
     draw_box(22,6,58,15);
     gotoxy(30,6);
     write('  Display Screens  ');
     gotoxy(42,14);
     readln(CHOICE);
     case CHOICE of
     1 : DISPLAY_OUTPUT;
     2 : STATS;
     3 : GRAPH_DATA;
     4 : DISPLAY_ELEVATION;
     end;
end;

{***************************************************************************
  Procedure to configure the Starting values at the begining of the day
it will take the last mile of the day and the begining Amp Hour reading from
the car and also the Amount of Current wanted in the battery at the end of
the day
***************************************************************************}
procedure  CONFIG_MISC;
var
   MISC : MISC_DATA;
   MISC_FILE : file of MISC_DATA;
      CONTINUE : CHAR;
      MINUTE,HOUR : integer;
begin
     clrscr;
     writeln('                         WARNING!!!!');
     writeln;
     writeln('  This will reset all of the values collected during the day so far');
     write(' Continue (Y/N) ==>');
     readln(CONTINUE);
     if (CONTINUE = 'Y') or (CONTINUE = 'y') then
        begin
            clrscr;
            assign(MISC_FILE,'A:MISC.DAT');
            reset(MISC_FILE);
            seek(MISC_FILE,filesize(MISC_FILE) - 1);
            read(MISC_FILE,MISC);
            erase(MISC_FILE);
            write('Enter the Begining AmpHour Meter reading (aH) ==>');
            readln(MISC.AH_METER);
            write('Enter the Amount of current you want at the end of the day (aH) ==>');
            readln(MISC.END_AH_METER);
            write('Enter the Starting time of the race ==>');
            GET_NEW_TIME(HOUR,MINUTE);
            write('Enter the Last Mile of todays course ==>');;
            readln(MISC.LAST_MILE);
            MISC.START_TIME := HOUR*60 + MINUTE;
            rewrite(MISC_FILE);
            write(MISC_FILE,MISC);
            close(MISC_FILE);
        end;
end;


{**************************************************************************
  Convert Miles per Hour to Meters per Second
**************************************************************************}
function FIND_MS_SPEED(SPEED : real) : real;
begin
     FIND_MS_SPEED := SPEED * 0.44702;
end;


{*************************************************************************
  Convert Degrees to Radians
*************************************************************************}
function CONVERT_D_R(DEGREE : integer):real;
begin
     CONVERT_D_R := (DEGREE * 0.017453292);
end;


{**************************************************************************
  Find the vector between the Sun and the Panel
**************************************************************************}
function FIND_S_DOT_N(PANEL_E,SUN_E,PANEL_N,SUN_N,PANEL_V,SUN_V : real) : real;
begin
     FIND_S_DOT_N := ((PANEL_E*SUN_E)+(PANEL_N*SUN_N)+(PANEL_V*SUN_V));
end;


{****************************************************************************
  These two function are necessary for the finding of the Panel to Sun vector
Turbo Pascal did not have ArcCosine and ArcSine so this is how I derived them

Knowing Y/R or the SINE of the angle
we let R = 1
1^2 = X^2 + Y^2
1^2 = 1;
X^2 = 1 - Y^2
X = sqrt (1 - Y^2)
Y = Y / 1;
now we know X and Y so we can take the ArcTangent of that Ratio to find
the angle
angle = arctan(Y/sqrt(1-Y^2))
end that's all folks!!!!
*****************************************************************************}
function ACOS(X:real):real;
begin
     if (X <> 0) then
       ACOS := arctan(sqrt(1-X*X)/X)
     else
       ACOS := 1.570796327;
end;
function ASIN(X:real):real;
begin
     if (X <> 1) then
         ASIN := arctan(X/sqrt(1-X*X))
     else
         ASIN := 1.570796327;
end;

function FIND_THETA(LAT,DECL,TIME : real) : real;
begin
     FIND_THETA :=  ACOS(sin(LAT)*sin(DECL)+cos(LAT)*cos(DECL)*cos(TIME));
end;


function FIND_BETA(TIME,DECL,THETA : real) : real;
begin
     FIND_BETA := ASIN(sin(TIME)*(cos(DECL)/sin(THETA)));
end;


procedure FIND_PANEL_VECTOR(ANGLE,DIRECTION : real; var PANEL_E,PANEL_N,
                            PANEL_V : real);
begin
     PANEL_E := (-sin(ANGLE)*sin(1.57079+DIRECTION));
     PANEL_N := (-sin(ANGLE)*cos(1.57079+DIRECTION));
     PANEL_V := (cos(ANGLE));
end;


procedure FIND_SUN_VECTOR(THETA,BETA : real; var SUN_E,SUN_N,SUN_V : real);
begin
     SUN_E := (sin(THETA)*sin(BETA));
     SUN_N := (-sin(THETA)*cos(BETA));
     SUN_V := cos(THETA);
end;



{***************************************************************************
  This procedure will find the best panel angle and then return the vector
of the sun to the panel
****************************************************************************}
procedure FIND_ANGLE(LAT,DIRECTION,TIME,DECL : real;
                         var ANGLE,SUN_VECTOR : real);
var
   PANEL_E,PANEL_N,PANEL_V :real;
   SUN_E,SUN_N,SUN_V : real;
   THETA,BETA : real;
   S_DOT_N1,S_DOT_N2 : real;
begin
    ANGLE := -0.62;
    FIND_PANEL_VECTOR(ANGLE,DIRECTION,PANEL_E,PANEL_N,PANEL_V);
    THETA := FIND_THETA(LAT,DECL,TIME);
    BETA := FIND_BETA(TIME,DECL,THETA);
    FIND_SUN_VECTOR(THETA,BETA,SUN_E,SUN_N,SUN_V);
    S_DOT_N1 := FIND_S_DOT_N(PANEL_E,SUN_E,PANEL_N,SUN_N,PANEL_V,SUN_V);
    ANGLE := 0.62;
    FIND_PANEL_VECTOR(ANGLE,DIRECTION,PANEL_E,PANEL_N,PANEL_V);
    S_DOT_N2 := FIND_S_DOT_N(PANEL_E,SUN_E,PANEL_N,SUN_N,PANEL_V,SUN_V);
    if S_DOT_N1 > S_DOT_N2 then
    begin
         ANGLE := -0.62;
         SUN_VECTOR := S_DOT_N1;
    end
    else
    begin
         ANGLE := 0.62;
         SUN_VECTOR := S_DOT_N2;
    end;
end;

procedure GET_SUN_VECTOR(ANGLE,DIRECTION,LAT,TIME,DECL:real; var SUN_VECTOR:real);
var
   THETA,BETA,PANEL_E,PANEL_N,PANEL_V,SUN_E,SUN_N,SUN_V :real;
begin
    FIND_PANEL_VECTOR(ANGLE,DIRECTION,PANEL_E,PANEL_N,PANEL_V);
    THETA := FIND_THETA(LAT,DECL,TIME);
    BETA := FIND_BETA(TIME,DECL,THETA);
    FIND_SUN_VECTOR(THETA,BETA,SUN_E,SUN_N,SUN_V);
    SUN_VECTOR := FIND_S_DOT_N(PANEL_E,SUN_E,PANEL_N,SUN_N,PANEL_V,SUN_V);
end;

{***********************************************************************
  This function will calculate the current solar time from the given
inputs
      1. Longitude of the time zone    : LONGTZ (rad.)
      2. Local Longitude               : LONGLOC (rad.)
      3. Time into the race            : TIME (minutes)
      4. Time constant for the month   : Globaly defined

formula obtained from Kevin Vannorsdel (Solar Cell Group)
***********************************************************************}
function FIND_SOLAR_TIME(LONG_TZ,LONG_LOC,TIME : real):real;
var
   SOLAR_TIME : real;
begin
     TIME := (TIME - 720);
     SOLAR_TIME := (4*(57.29578*LONG_TZ - 57.29578*LONG_LOC) - (TIME_CONST) + TIME);
     FIND_SOLAR_TIME := 0.01745328*(SOLAR_TIME/4);
end;


{***************************************************************************
  This function will find the declination angle of the sun for a given day
for the year
     Formula obtained from Kevin Vannorsdel (Solar Cell Group)
***************************************************************************}
function DECLINATION(DAY : integer):real;
begin
     DECLINATION := 23.45*(sin(6.28*((284+DAY)/365)));
end;


{***************************************************************************
  This function will find the day from the system and then call a routine
to find the declination angle for that day durring the year
***************************************************************************}
function FIND_DECL:real;
var
   YEAR,MONTH,DAY1,DOW : word;
   DAY : integer;
begin
     getdate(YEAR,MONTH,DAY1,DOW);
     case month of
          1 : DAY := DAY1;
          2 : DAY := DAY1 + 31;
          3 : DAY := DAY1 + 59;
          4 : DAY := DAY1 + 90;
          5 : DAY := DAY1 + 120;
          6 : DAY := DAY1 + 151;
          7 : DAY := DAY1 + 181;
          8 : DAY := DAY1 + 212;
          9 : DAY := DAY1 + 243;
          10 : DAY := DAY1 + 273;
          11 : DAY := DAY1 + 304;
          12 : DAY := DAY1 + 334;
     end;
     FIND_DECL := DECLINATION(DAY);
end;


{**************************************************************************
  This function will take the direction of the car, the wind direction
and the wind speed and find the correct Wind vector that will oppose the
Northern Light Vehicle
**************************************************************************}
function FIND_WIND_VECTOR(DIR,WIND_DIR,WIND_SPEED : real) : real;
var
   WIND_ANGLE : real;
begin
   WIND_SPEED := FIND_MS_SPEED(WIND_SPEED);
   WIND_ANGLE := WIND_DIR - DIR;
   FIND_WIND_VECTOR := WIND_SPEED * COS(WIND_ANGLE);
end;


{***************************************************************************
  This procedure will calculate the amount of energy that can be expected to
be received by the sun over a period of one mile of the course
the inputs we have are

    1. Time into the race             : TIME (minutes)
    2. Declenation angle of the sun   : DECL (rad.)
    3. Angle of panel from the ground : ANGLE (rad.)
    4. The heading of the car         : DIRECTION (rad.)
    5. Latitude of the car            : LAT (rad.)
    6. Efficiency of the Solar Cells  : CELL_EFF (percent)
    7. Time to cover one mile         : SPEED_FACTOR (percent of hour)

  Function to find the amount of power from each panel over one mile
formula obtained from:    Kevin Vannorsdel (Solar Cell Group)
****************************************************************************}
Function FIND_PANEL_POWER(AREA,CELL_EFF,INSOLATION,S_DOT_N,
                          SPEED_FACTOR : real) : real;
var
POWER : real;

begin
     POWER := (AREA*CELL_EFF*S_DOT_N*INSOLATION);
     FIND_PANEL_POWER := POWER * SPEED_FACTOR;  {Find powr for correct}
end;                                            {amount of time}


{***************************************************************************
  This routine will calculate the time needed to pilot the vehicle for one
mile of the course given the condidtions below


     1. Velocity of Vehicle = SPEED (meters/second)
     2. Wind Vector         = WIND  (meters/second)
     3. Percent grade       = GRADE
     4. Length grade        = LENGTH_GRADE miles

     The rest of the data is constant for the Northern Light Vehicle

formula for watts (Newton * Meter / Second)
Watts = (k(V-w)^2 + Fr + ma + mgs(x))V
     k = force constant      V = velocity      w = wind
    Fr = Rolling resistance  m = mass          g = gravity
  s(X) = percent grade of road

       Formula obtained form
       GM Sunraycer Lecture 5-1: Race Tactics and Strategy
***************************************************************************}
function FIND_WORK(SPEED,WIND,GRADE,LENGTH_GRADE,SPEED_FACTOR,ACC,
                   FORCE,MASS,ROLLING_RESISTANCE : real) : real;
var
   FLAT_NEWTON,HILL_NEWTON,FLAT_WATT,HILL_WATT,HOUR_WORK : real;
begin
ACC := 0;
     if LENGTH_GRADE <> 0 then
     begin
          FLAT_NEWTON := (FORCE*(SPEED-WIND)*(SPEED-WIND)+ROLLING_RESISTANCE
                         +(MASS*ACC));
          HILL_NEWTON := ((MASS*GRAVITY*GRADE)+FLAT_NEWTON);
          FLAT_WATT := ((((1 - LENGTH_GRADE))*FLAT_NEWTON)*SPEED);
          HILL_WATT := (LENGTH_GRADE*HILL_NEWTON*SPEED);
          HOUR_WORK := FLAT_WATT+HILL_WATT;
          FIND_WORK := HOUR_WORK * SPEED_FACTOR;
     end   {if LENGTH_GRADE}
     else
     begin
          FLAT_NEWTON := (FORCE*(SPEED-WIND)*(SPEED-WIND)+ROLLING_RESISTANCE
                         +(MASS*ACC));
          FIND_WORK := (FLAT_NEWTON*SPEED) * SPEED_FACTOR;
     end;  {else if LENGTH_GRADE}
end;    {main FIND_WORK}


{***************************************************************************
  This procedure will call the necessary routine to find the amount of
power it will take to go one mile with the Northern Light Car
***************************************************************************}
function FIND_WORK_POWER
         (DIRECTION,WIND_SPEED,WIND_DIRECTION,GRADE,MPH,SPEED_FACTOR,
         LENGTH_GRADE,ACC,FORCE,MASS,ROLLING_RESISTANCE : REAL;
          CITY : BOOLEAN) : real;
var
   SPEED,WIND : real;
begin
     SPEED := FIND_MS_SPEED(MPH);
     WIND := FIND_WIND_VECTOR(DIRECTION,WIND_DIRECTION,WIND_SPEED);
     FIND_WORK_POWER := FIND_WORK(SPEED,WIND,GRADE,LENGTH_GRADE,SPEED_FACTOR,
                        ACC,FORCE,MASS,ROLLING_RESISTANCE);
end;


{**************************************************************************
  This procedure will create an array with elemants from a file containin
information about the road that the Northern Light Car will travel
**************************************************************************}
procedure CREATE_DATA_ARRAY(var ROAD_ARRAY : ROAD_DATA_ARRAY;
                            var WEATHER_PTR : WIND_POINTER;
                            LAST_MILE : integer);
var

   ROAD_FILE : file of ROAD_DATA;
   WEATHER_FILE : file of WEATHER_TYPE;
   MISC_FILE : file of MISC_DATA;
   MISC : MISC_DATA;
   WEATHER_DATA1 : WEATHER_TYPE;
   WEATHER : WIND_POINTER;
   Y,X,TIME : integer;
   DATA,TEMP : ROAD_DATA;

begin
    assign(ROAD_FILE,'A:ROAD.DAT');
    assign(WEATHER_FILE,'A:WEATHER.DAT');
    reset(ROAD_FILE);
    reset(WEATHER_FILE);
    assign(MISC_FILE,'A:MISC.DAT');
    reset(MISC_FILE);
    seek(MISC_FILE,filesize(MISC_FILE)-1);
    read(MISC_FILE,MISC);
    X := 1;
    read(ROAD_FILE,DATA);
    while not (eof (ROAD_FILE)) do
    begin
        if DATA.MILE = X then
        begin
            ROAD_ARRAY[X] := DATA;
            ROAD_ARRAY[X].MILE := X;
            read(ROAD_FILE,DATA);
            X := X + 1;
        end
        else
        begin
           ROAD_ARRAY[X].MILE := X;
           ROAD_ARRAY[X].GRADE := 0;
           ROAD_ARRAY[X].LENGTH_GRADE := 0;
           X := X + 1;
        end; {else}
    end;  {while loop}
    for Y := X to LAST_MILE do
    begin
      if Y = DATA.MILE then
        begin
             ROAD_ARRAY[Y] := DATA;
             ROAD_ARRAY[Y].MILE := Y;
        end
      else
        begin
             ROAD_ARRAY[y].GRADE := 0;
             ROAD_ARRAY[y].LENGTH_GRADE := 0;
             ROAD_ARRAY[y].MILE := y;
        end;
    end;

{Now we will start creating the Weather Pointer Structure from the file}
    read(WEATHER_FILE,WEATHER_DATA1);
    new(WEATHER_PTR);
    WEATHER_PTR^.WIND_SPEED := WEATHER_DATA1.WIND_SPEED;
    WEATHER_PTR^.WIND_DIR := WEATHER_DATA1.WIND_DIR;
    TIME := (60*WEATHER_DATA1.HOUR + WEATHER_DATA1.MINUTE) - MISC.START_TIME;
    WEATHER_PTR^.MINUTE := TIME;
    WEATHER_PTR^.CLOUDS := WEATHER_DATA1.CLOUDS;
    WEATHER_PTR^.NEXT := nil;
    WEATHER := WEATHER_PTR;

    while (not eof (WEATHER_FILE)) do
    begin
        read(WEATHER_FILE,WEATHER_DATA1);
        new(WEATHER^.NEXT);
        WEATHER := WEATHER^.NEXT;
        WEATHER^.WIND_SPEED := WEATHER_DATA1.WIND_SPEED;
        WEATHER^.WIND_DIR := WEATHER_DATA1.WIND_DIR;
        TIME := (60*WEATHER_DATA1.HOUR + WEATHER_DATA1.MINUTE) - MISC.START_TIME;
        WEATHER^.MINUTE := TIME;
        WEATHER^.CLOUDS := WEATHER_DATA1.CLOUDS;
        WEATHER^.NEXT := nil;
     end; {while not eof}
     close(MISC_FILE);
     close(ROAD_FILE);
     close(WEATHER_FILE);
end; {main process}


{**************************************************************************
Procedure to print out all of the Data for Road and Weather conditions
***************************************************************************}
procedure PRINT_DATA(var WEATHER_PTR:WIND_POINTER; var ROAD_ARRAY :  ROAD_DATA_ARRAY);
var
   x : integer;
   WEATHER : WIND_POINTER;
begin
     x := 1;
     WEATHER := WEATHER_PTR;
     while (WEATHER <> nil) do
     begin
        writeln(WEATHER^.MINUTE,'  ',WEATHER^.WIND_DIR,'  ',
                WEATHER^.WIND_SPEED,'  ',WEATHER^.CLOUDS);
        WEATHER := WEATHER^.NEXT;
     end;
     While (ROAD_ARRAY[x].MILE <> 96) do
     begin
          with ROAD_ARRAY[x] do begin
               writeln(MILE,'  ',GRADE,'  ',LENGTH_GRADE);
               end;
          x := x + 1;
     end;
     read(WAIT);
end;


{***************************************************************************
  Main part of the calling routine to find the best average speed for the
Northern Light Vehicle to travel at.
***************************************************************************}
procedure FIND_SPEED;

var
    POWER_FILE : file of POWER_DATA;
     MISC_FILE : file of MISC_DATA;
          ROAD : ROAD_DATA;
    TEMP_FIRST : WIND_POINTER;
         FIRST : WIND_POINTER;
          MISC : MISC_DATA;
    ROAD_ARRAY : ROAD_DATA_ARRAY;
      MILE,x,y : integer;
    START_MILE : integer;
     LAST_MILE : integer;
   hh,mm,ss,nn : word;
 CORRECT_SPEED : boolean;
  SPEED_FACTOR : real;
           MPH : real;
          TIME : real;
           ACC : integer;
         FORCE : real;
          MASS : real;
 ROLLING_RESISTANCE : real;
          DECL : real;
      IN_POWER : real;
     OUT_POWER : real;
  TOT_IN_POWER : real;
 TOT_OUT_POWER : real;
  OVER_ALL_EFF : real;
    SOLAR_TIME : real;
           LAT : real;
       LONG_TZ : real;
      LONG_LOC : real;
  STORM_RUNNER : boolean;
          AREA : real;
    INSOLATION : real;
    WIND_SPEED : integer;
      WIND_DIR : integer;
         GRADE : real;
  LENGTH_GRADE : real;
          CITY : boolean;
     DIRECTION : real;
         ANGLE : real;
    SUN_VECTOR : real;
      CELL_EFF : real;
      AH_METER : real;
   OVERALL_EFF : real;
     ENDING_AH : real;
    WORLD_CORD : WORLD_CORD_ARRAY;
    TIMES_THRU : integer;
      TEMP_MPH : real;
    WIND_DIREC : real;
     REAL_TIME : real;
    RACE_START_TIME : real;
         POWER : POWER_ARRAY;
         PRINTER : text;
         ANGLE2 : real;
         FLIPED : boolean;
         CONFIGED : boolean;
         INSOLATION_CUR : real;
         LAT_DEG : real;

begin
    RACE_START_TIME := 480;
    clrscr;
    CORRECT_SPEED := false;
    ACC := 0;
    MPH := 55;
    TIMES_THRU := 1;
    gettime(hh,mm,ss,nn);
    TIME := (hh*60 + mm) - (480);
    write('Please enter the current mile ==>');
    readln(START_MILE);
    write('Please enter the Amp hour meter reading ==>');
    readln(AH_METER);
    assign (MISC_FILE,'A:MISC.DAT');
    reset (MISC_FILE);
    assign (POWER_FILE,'A:POWER.DAT');
    read(MISC_FILE,MISC);
    assign (PRINTER,'LPT1');
    rewrite(PRINTER);
    seek(MISC_FILE,filesize(MISC_FILE)-1);
    read(MISC_FILE,MISC);
    TIME := hh*60 + mm - MISC.START_TIME;
    ROLLING_RESISTANCE := MISC.ROLLING_RESISTANCE;
    MASS := MISC.MASS;
    FORCE := MISC.FORCE;
    LAST_MILE := MISC.LAST_MILE;
    OVER_ALL_EFF := MISC.OVER_EFF;
    OVER_ALL_EFF := OVER_ALL_EFF/100;
    CELL_EFF := MISC.CELL_EFF;
    CELL_EFF := CELL_EFF/100;
    ENDING_AH := MISC.END_AH_METER;
    DECL := FIND_DECL;
    DECL := CONVERT_D_R(trunc(DECL));
    CREATE_DATA_ARRAY(ROAD_ARRAY,FIRST,LAST_MILE);
    FIND_WORLD_CORD(WORLD_CORD,LAST_MILE);
    LAT_DEG := WORLD_CORD[START_MILE].LAT * 57.295;
    if (LAT_DEG > 25) and (LAT_DEG <= 30) then INSOLATION_CUR := 917;
    if (LAT_DEG > 30) and (LAT_DEG <= 35) then INSOLATION_CUR := 928;
    if (LAT_DEG > 35) and (LAT_DEG <= 40) then INSOLATION_CUR := 932;
    if (LAT_DEG > 40) and (LAT_DEG <= 45) then INSOLATION_CUR := 932;
    if (LAT_DEG > 45) and (LAT_DEG <= 50) then INSOLATION_CUR := 927;
    gettime(hh,mm,ss,nn);
    REAL_TIME := (hh*60 + mm);
    TIME := REAL_TIME - MISC.START_TIME;
{    PRINT_DATA(FIRST,ROAD_ARRAY);}
    TEMP_FIRST := FIRST^.NEXT;
    while (TEMP_FIRST^.MINUTE < trunc(REAL_TIME)-MISC.START_TIME) and (TEMP_FIRST^.NEXT <> nil) do
    begin
         TEMP_FIRST := TEMP_FIRST^.NEXT;
         FIRST := FIRST^.NEXT;
    end;
    STORM_RUNNER := false;
    clrscr;
    writeln('                                     WORKING!');
    gotoxy(41,10);
    writeln('Done.');
    while ((not (CORRECT_SPEED)) and (TIMES_THRU < 6))  do
    begin
        gettime(hh,mm,ss,nn);
        REAL_TIME := (hh*60 + mm);
        gotoxy(26,5);
        TIME := REAL_TIME - MISC.START_TIME;
        writeln('Checking a vehicle speed of ',trunc(MPH));
        SPEED_FACTOR := (1/(MPH));
        TOT_IN_POWER := 0;
        TOT_OUT_POWER := 0;
        FLIPED := false;
        CONFIGED := false;
        for MILE := START_MILE to LAST_MILE do
        begin
            REAL_TIME := REAL_TIME + SPEED_FACTOR*60;
            TIME := TIME + SPEED_FACTOR*60;
            LONG_TZ := WORLD_CORD[MILE].LONG_TZ;
            LONG_LOC := WORLD_CORD[MILE].LONG_LOC;
            LAT := WORLD_CORD[MILE].LAT;
            DIRECTION := WORLD_CORD[MILE].DIRECTION;
            DIRECTION := DIRECTION*0.017453230;
            GRADE := ROAD_ARRAY[MILE].GRADE;
            LENGTH_GRADE := ROAD_ARRAY[MILE].LENGTH_GRADE;
            SOLAR_TIME := FIND_SOLAR_TIME(LONG_TZ,LONG_LOC,REAL_TIME);
            if (((trunc(REAL_TIME)-MISC.START_TIME) > TEMP_FIRST^.MINUTE) and (TEMP_FIRST^.NEXT <> nil)) then
            begin
               FIRST := TEMP_FIRST;
               TEMP_FIRST := TEMP_FIRST^.NEXT;
            end;
            ROAD := ROAD_ARRAY[MILE];
            GRADE := ROAD.GRADE;
            LENGTH_GRADE := ROAD.LENGTH_GRADE;
            WIND_SPEED := FIRST^.WIND_SPEED;
            WIND_DIR := FIRST^.WIND_DIR;
            WIND_DIREC := WIND_DIR*0.0174533;
            if not (STORM_RUNNER) then
            begin
               AREA := 9.6666;
               FIND_ANGLE(LAT,DIRECTION,SOLAR_TIME,DECL,ANGLE,SUN_VECTOR);
               if (ANGLE2 <> ANGLE) and (not FLIPED) and (MILE > START_MILE) then
               begin
                    FLIPED := true;
                    MISC.FLIP_MILE := MILE;
               end;
               if not (CONFIGED) then
               begin
                    if (ANGLE = 0.62) then MISC.CELL_CONFIG := 1;
                    if (ANGLE = -0.62) then MISC.CELL_CONFIG := 2;
                    CONFIGED := true;
               end;
               ANGLE2 := ANGLE;
               INSOLATION := INSOLATION_CUR;
               if FIRST^.CLOUDS <> 0 then
                  INSOLATION := INSOLATION_CUR * (0.30/(FIRST^.CLOUDS));
               IN_POWER := AREA*CELL_EFF*INSOLATION*SUN_VECTOR*SPEED_FACTOR;
               OUT_POWER := FIND_WORK_POWER(DIRECTION,WIND_SPEED,WIND_DIREC,
                                            GRADE,MPH,SPEED_FACTOR,LENGTH_GRADE,
                                            ACC,FORCE,MASS,ROLLING_RESISTANCE,
                                            CITY);

{writeln(PRINTER,MILE,' TIR=',round(TIME),' S.T= ',(57.29*SOLAR_TIME),' R.T.=',round(REAL_TIME));
writeln(PRINTER,'  Pan',trunc(57.29*angle),' S.V.',SUN_VECTOR,' P.I.=',(IN_POWER),'  P.O.=',(OUT_POWER));
writeln(PRINTER,'  Dir',trunc(57.29*DIRECTION),'  W.D.',trunc(57.29*WIND_DIREC),' W.S.',WIND_SPEED,' GRD.',GRADE);
}               TOT_IN_POWER := TOT_IN_POWER + IN_POWER;
               TOT_OUT_POWER := TOT_OUT_POWER + OUT_POWER;
               if ((TIMES_THRU = 5) or (TIMES_THRU = 1)) then
                  begin
                       POWER[MILE].SUN_POWER := IN_POWER;
                       POWER[MILE].WORK_POWER := OUT_POWER;
                  end;
            end
            else
            begin
               MISC.CELL_CONFIG := 3;
               AREA := 4.8333;
               ANGLE := -0.62;
               GET_SUN_VECTOR(ANGLE,DIRECTION,LAT,SOLAR_TIME,DECL,SUN_VECTOR);
               INSOLATION := INSOLATION_CUR;
               if FIRST^.CLOUDS <> 0 then
                  INSOLATION := INSOLATION_CUR * (0.30/FIRST^.CLOUDS);

               IN_POWER := AREA*CELL_EFF*INSOLATION*SUN_VECTOR*SPEED_FACTOR;
               OUT_POWER := FIND_WORK_POWER(DIRECTION,WIND_SPEED,WIND_DIREC,
                                            GRADE,MPH,SPEED_FACTOR,LENGTH_GRADE,
                                            ACC,FORCE,MASS,ROLLING_RESISTANCE,
                                            CITY);
               TOT_IN_POWER := TOT_IN_POWER + IN_POWER;
               TOT_OUT_POWER := TOT_OUT_POWER + OUT_POWER;
               ANGLE := 0.62;
               GET_SUN_VECTOR(ANGLE,DIRECTION,LAT,SOLAR_TIME,DECL,SUN_VECTOR);
               IN_POWER := AREA*CELL_EFF*INSOLATION*SUN_VECTOR*SPEED_FACTOR;
               TOT_IN_POWER := TOT_IN_POWER + IN_POWER;
               TOT_OUT_POWER := TOT_OUT_POWER + OUT_POWER;
               if ((TIMES_THRU = 5) or (TIMES_THRU = 1)) then
                  begin
                       POWER[MILE].SUN_POWER := TOT_IN_POWER;
                       POWER[MILE].WORK_POWER := TOT_OUT_POWER;
                  end;

            end; {else}
            gotoxy(37,10);
            writeln('   ');
            gotoxy(37,10);
            writeln(trunc(100*MILE/(MISC.LAST_MILE-START_MILE+1)),'%');
        end;  {for MILE}
        TOT_IN_POWER := TOT_IN_POWER + AH_METER * 48;
        TOT_OUT_POWER := (TOT_OUT_POWER * 1/OVER_ALL_EFF) + ENDING_AH * 48;
        if ((TOT_IN_POWER > TOT_OUT_POWER) and (MPH >= 55)) then
        begin
             CORRECT_SPEED := TRUE;
        end
        else
            begin
                CASE (TIMES_THRU) of
                  1 : TEMP_MPH := 27.5;
                  2 : TEMP_MPH := 13.75;
                  3 : TEMP_MPH := 6.875;
                  4 : TEMP_MPH := 3.4375;
                  5 : TEMP_MPH := 1.71825;
                end;
                if TOT_IN_POWER > TOT_OUT_POWER then
                   MPH := MPH + TEMP_MPH;
                if TOT_OUT_POWER > TOT_IN_POWER then
                   MPH := MPH - TEMP_MPH;
            end;
        TIMES_THRU := TIMES_THRU + 1;
    end;  {while not}
    gettime(hh,mm,ss,nn);
    TIME := (hh*60 + mm) - (480);
    reset(POWER_FILE);
    if START_MILE > 1 then
    for x := 1 to START_MILE do read(POWER_FILE,POWER[x]);
    rewrite(POWER_FILE);
    for MILE := 1 to LAST_MILE do
        write(POWER_FILE,POWER[MILE]);
    close(POWER_FILE);
    MISC.AH_METER := AH_METER;
    MISC.TIME := TIME;
    MISC.SUN := INSOLATION;
    MISC.MPH := MPH;
    MISC.AVG_MPH := (START_MILE div trunc(TIME));
    MISC.MILE := START_MILE;
    MISC.SUN_POWER := POWER[START_MILE].SUN_POWER;
    MISC.OUT_POWER := POWER[START_MILE].WORK_POWER;
    seek(MISC_FILE,filesize(MISC_FILE));
    write(MISC_FILE,MISC);
    close(MISC_FILE);
    close(PRINTER);
    DISPLAY_OUTPUT;
end;  {main FIND_SPEED}


{****************************************************************************
  This procedure will set up a menu for the user to choose which part of the
program HE/she wants to run
****************************************************************************}
function GET_CHOICE:integer;
var
   CHOICE : integer;
        x : integer;
begin

     clrscr;
     writeln;
     writeln;
     writeln;
     writeln;
     writeln('                       1...Find Speed.');
     writeln('                       2...Work with Condition Files.');
     writeln('                       3...Display Statistics for Car.');
     writeln('                       4...Set System Time and Date.');
     writeln('                       5...Change Constants for Car.');
     writeln('                       6...Configure the Data for the car.');
     writeln('                       9...Exit Program.');
     writeln;
     write('                           Choice ==>');
     DRAW_BOX(19,3,61,15);
     gotoxy(34,3);
     writeln('  Main Menu  ');
     gotoxy(39,13);
     readln(CHOICE);
     GET_CHOICE := CHOICE;

end;


begin
     DONE := false;
     OPENING_SCREEN;
     while (not DONE) do
     begin
          CHOICE := GET_CHOICE;
          case CHOICE of
               1 : FIND_SPEED;
               2 : MODIFY_FILES;
               3 : DISPLAY_SCREENS;
               4 : SET_TIME;
               5 : CHANGE_CONSTANTS;
               6 : CONFIG_MISC;
               9 : DONE := true;
          end;
     end;
     clrscr;
end.