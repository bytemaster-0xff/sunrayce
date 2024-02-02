unit OPENSCRN;

interface
procedure OPENING_SCREEN;

implementation

uses DOS,CRT,MISCPROC;

procedure OPENING_SCREEN;
var HH,MM,SS,TT,DAY2,MONTH2,YEAR2,DOW:word;
HOUR,MINUTE,MONTH,DAY,YEAR,x : integer;
SPACE : string[2];
correct : string[1];
begin
     gettime(HH,MM,SS,TT);
     getdate(YEAR2,MONTH2,DAY2,DOW);
     SPACE := ':';
     if MM < 10 then SPACE := ':0';
     clrscr;
     writeln;
     writeln('       MMMM       MMMM              SSSSSSSSSSS            UUU        UUU');
     WRITELN('       MM MM     MM MM            SSSS       SSSS          UUU        UUU');
     WRITELN('       MM  MM   MM  MM           SSS                       UUU        UUU');
     WRITELN('       MM  MM   MM  MM            SSSS                     UUU        UUU');
     WRITELN('       MM   MM MM   MM              SSSSSSSSSSS            UUU        UUU');
     WRITELN('       MM    MMM    MM                       SSSS          UUU        UUU');
     WRITELN('       MM     M     MM                         SSS         UUUU      UUUU');
     WRITELN('       MM           MM            SSSS       SSSS           UUUUUUUUUUUU');
     WRITELN('       MM           MM              SSSSSSSSSSS              UUUUUUUUUU');
     writeln;
     writeln('                              MANKATO STATE UNIVERSITY');
     writeln;
     writeln('                      NORTHERN LIGHT SOLAR VEHICLE RACE TEAM');
     writeln;
     writeln('                Speed Optimizing and related Statistics Software');
     writeln;
     writeln('                           written for G.M. SunRayce 1990');
     writeln('                              by Kevin Wolf  6/13/1990');
     writeln;
     writeln('                                   DATE : ',MONTH2,'/',DAY2,'/',YEAR2);
     writeln('                                     TIME : ',HH,SPACE,MM);
     writeln;
     write('                           Are the Time and Date correct  (Y/N)?');
     readln(CORRECT);
     clrscr;
     if (CORRECT = 'N') or (CORRECT ='n') then
     begin
       for x:= 1 to 10 do writeln;
       write('Please enter the correct time MM/DD/YY ==>');
       GET_NEW_DATE(MONTH,DAY,YEAR);
       write('Please enter the correct time HH:MM ==>');
       GET_NEW_TIME(HOUR,MINUTE);
       settime(HOUR,MINUTE,00,00);
       setdate(YEAR,MONTH,DAY);
       clrscr;
     end;
end;
end.