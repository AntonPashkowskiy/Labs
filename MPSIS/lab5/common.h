#ifndef COMMON_H_
#define COMMON_H_

typedef char bool;
#define true 1
#define false 0

typedef unsigned char uint8_t;

typedef char int8_t;
typedef unsigned int uint16_t;

#define HORIZONTAL_SCREEN_SIZE   102         // Display Size in dots: X-Axis
#define VERTICAL_SCREEN_SIZE    64         // Display Size in dots: Y-Axis

#define DOGS102x6_DRAW_NORMAL   0x00   // Display dark pixels on a light background
#define DOGS102x6_DRAW_INVERT   0x01   // Display light pixels on a dark background

#define DOGS102x6_DRAW_IMMEDIATE  0x01  // Display update done immediately
#define DOGS102x6_DRAW_ON_REFRESH 0x00  // Display update done only with refresh

#endif /* COMMON_H_ */
