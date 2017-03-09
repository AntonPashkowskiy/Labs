#include <msp430.h>
#include "common.h"
#include "dogs.h"
#include "cma.h"

void init_button();
void set_value_to_screen(int8_t value);

int main()
{
	// stop wachdog timer
	WDTCTL = WDTPW | WDTHOLD;
	
	init_button();
	initialize_accelerometer();

	screen_init();
	screen_backlight_init();
    screen_backlight_set();
    screen_clear();
	
	_bis_SR_register(GIE);
	
    while (true)
    	set_value_to_screen(get_accelerometer_x_axis_value());
}

#pragma vector=PORT1_VECTOR
__interrupt void Port1_ISR(void)
{
	bool is_button_pressed = P1IFG & BIT7;
	P1IFG &= ~BIT7;
	
	if (is_button_pressed)
		flip_fonts();
}

void init_button()
{
	P1REN |= BIT7;
	P1OUT |= BIT7;
	P1IES |= BIT7;
	P1IFG = 0;
	P1IE |= BIT7;
}

void set_value_to_screen(int8_t value)
{
	char buffer[4];
	buffer[0] = value / 100 + '0';
	buffer[1] = (value % 100) / 10 + '0';
	buffer[2] = value % 10 + '0';
	buffer[3] = 0;
	screen_write_line(buffer);
}




