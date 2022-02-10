#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "unistd.h"
#include "stdio.h"

int main() {
  //0x3F : "0" etc
  // 0x06 : 1, 0x5B : 2, 0x4F : 3 , 0x66 : 4 0xED : 5 0xFD : 6 Ox07 : 7 0xFF = 8 OxEF = 9
  unsigned int SevenSeg[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0xED, 0xFD, 0x07, 0xFF, 0xEF};
  volatile int* distance = (int*)0x000810a4;
  volatile int centaine = 0;
  volatile int dizaine =0;
  volatile int unite = 0;
  volatile int  temp = 0;

  int position = 0;
  int angle = 0;

  printf("Hello World !\n");

  while (1) {
	printf("Distance : %d cm\n    Angle : %d degrés",*distance,angle);

    usleep(250000); // tempo de 100 000 µs --> 100 ms

    unite = *distance%10;
    dizaine =*distance/10;
    dizaine = dizaine%10;
    centaine = *distance/100;

    angle = (angle +1) %180;

    //70000/180 = 389, expérimentalement bouge le servomoteur d'un degré
    position = (position+389) % 70000;
    IOWR_ALTERA_AVALON_PIO_DATA(0x000810a0,position);

    IOWR_ALTERA_AVALON_PIO_DATA(DE0_SEVENSEG_0_BASE + 0, ~SevenSeg[unite] );
    IOWR_ALTERA_AVALON_PIO_DATA(DE0_SEVENSEG_0_BASE + 4, ~SevenSeg[dizaine] );
    IOWR_ALTERA_AVALON_PIO_DATA(DE0_SEVENSEG_0_BASE + 8, ~SevenSeg[centaine] );
    IOWR_ALTERA_AVALON_PIO_DATA(DE0_SEVENSEG_0_BASE + 12, ~SevenSeg[0] );
    IOWR_ALTERA_AVALON_PIO_DATA(DE0_SEVENSEG_0_BASE + 16, ~SevenSeg[0] );
    IOWR_ALTERA_AVALON_PIO_DATA(DE0_SEVENSEG_0_BASE + 20, ~SevenSeg[0] );

  }
  return 0;
}

	  //lire la data des switch puis l'appliquer sur le servomoteur
	  //commande = IORD_ALTERA_AVALON_PIO_DATA(0x00081070);

//  volatile int* com =(int*)0x000810a0;
