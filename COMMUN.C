#include <bios.h>
#include <conio.h>

#define COM1       1
#define DATA_READY 0x100
#define TRUE       1
#define FALSE      0

#define SETTINGS ( 0xE0 | 0x02 | 0x00 | 0x00)

int main(void)
{
   int in, out, status, DONE = FALSE, i = 0;
   char buffer[10000];

   bioscom(0, SETTINGS, COM1);
   cprintf("... BIOSCOM [ESC] to exit ...\n");
   while (!DONE)
   {
      status = bioscom(3, 0, COM1);
      if (status & DATA_READY)
		 if ((out = bioscom(2, 0, COM1) & 0x7F) != 0)
		 {
			buffer[i] = out;
			++i;
			putch(out);
		 }

		 if (kbhit())
         {
            if ((in = getch()) == '\x1B')
               DONE = TRUE;
            bioscom(1, in, COM1);
         }
   }
   return 0;
}
