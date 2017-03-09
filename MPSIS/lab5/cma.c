#include "msp430.h"
#include "cma.h"

#define TICKS_PER_MICRO_SEC 	25
#define CONTROL					0x02
#define DOUTX                   0x06
#define DOUTY                   0x07
#define DOUTZ                   0x08
#define G_RANGE_2               0x80
#define I2C_DIS                 0x10
#define MEASUREMENT_400_HZ 		0x04

void write_register(uint8_t address, int8_t accelData)
{
    // Address to be shifted left by 2
    address <<= 2;

    // RW bit to be set
    address |= 2;

    // Select acceleration sensor
    P3OUT &= ~BIT5;

    // Read RX buffer just to clear interrupt flag
    UCA0RXBUF;

    // Wait until ready to write
    while (!(UCA0IFG & UCTXIFG)) ;

    // Write address to TX buffer
    UCA0TXBUF = address;

    // Wait until new data was written into RX buffer
    while (!(UCA0IFG & UCRXIFG)) ;

    // Read RX buffer just to clear interrupt flag
    UCA0RXBUF;

    // Wait until ready to write
    while (!(UCA0IFG & UCTXIFG)) ;

    // Write data to TX buffer
    UCA0TXBUF = accelData;

    // Wait until new data was written into RX buffer
    while (!(UCA0IFG & UCRXIFG)) ;

    // Read RX buffer
    UCA0RXBUF;

    // Wait until USCI_A0 state machine is no longer busy
    while (UCA0STAT & UCBUSY) ;

    // Deselect acceleration sensor
    P3OUT |= BIT5;

}

uint8_t read_register(uint8_t address)
{
    uint8_t result;
    // Address to be shifted left by 2 and RW bit to be reset
    address <<= 2;

    // Select acceleration sensor
    P3OUT &= ~BIT5;

    // Read RX buffer just to clear interrupt flag
    result = UCA0RXBUF;

    // Wait until ready to write
    while (!(UCA0IFG & UCTXIFG)) ;

    // Write address to TX buffer
    UCA0TXBUF = address;

    // Wait until new data was written into RX buffer
    while (!(UCA0IFG & UCRXIFG)) ;

    // Read RX buffer just to clear interrupt flag
    result = UCA0RXBUF;

    // Wait until ready to write
    while (!(UCA0IFG & UCTXIFG)) ;

    // Write dummy data to TX buffer
    UCA0TXBUF = 0;

    // Wait until new data was written into RX buffer
    while (!(UCA0IFG & UCRXIFG)) ;

    // Read RX buffer
    result = UCA0RXBUF;

    // Wait until USCI_A0 state machine is no longer busy
    while (UCA0STAT & UCBUSY) ;

    // Deselect acceleration sensor
    P3OUT |= BIT5;

    // Return new data from RX buffer
    return result;
}

void initialize_accelerometer(void)
{
    do
    {
        // Set P3.6 to output direction high
		// enabled power voltage
        P3OUT |= BIT6;
        P3DIR |= BIT6;

        // P3.3,4 option select
		// BIT3 - SPI data transmission line
		// BIT4 - SPI data recieving line
        P3SEL |= BIT3 + BIT4;

        // P2.7 option select
		// enable CLK (ACCEL_SCK - accelerator synchro clock)
        P2SEL |= BIT7;

		// clear interrupt direction
        P2DIR &= ~BIT5;

        // generate interrupt on Low to High edge
        P2IES &= ~BIT5;

        // clear interrupt flag
        P2IFG &= ~BIT5;

        // Unselect acceleration sensor
		// Device select
        P3OUT |= BIT5;
        P3DIR |= BIT5;

		// UCA0CTL1 - SPI control register
        // UCSWRST - eUSCI logic held in reset state.
        UCA0CTL1 |= UCSWRST;
		
		// UCMST - master mode select
		// UCSYNC - enabled synchro mode of data transmission/recieving
		// UCCKPH - data is captured on the first UCLK edge and changed on the following edge.
		// UCMSB - MSB (most significant byte first) first select. Controls the direction of the receive and transmit shift register.
        UCA0CTL0 = UCMST + UCSYNC + UCCKPH + UCMSB;
		
		// UCSWRST - keep reset state
		// UCSSEL_2 - SMCLK clock source
        UCA0CTL1 = UCSWRST + UCSSEL_2;
		
		// UCA0BR0, UCA0BR1 - boud-rate control
		//Low byte of clock prescaler setting of the baud-rate generator. The 16-bit value 
		//of (UCAxBR0 + UCAxBR1 × 256) forms the prescaler value UCBRx.
        UCA0BR0 = 0x30;
        UCA0BR1 = 0;
        
		// UCA0MCTL - modulation control register
		// no modulation
        UCA0MCTL = 0;
        
		// UCA0CTL1 - SPI control register
        // UCSWRST - run eUSCI logic.
        UCA0CTL1 &= ~UCSWRST;

        // activate measurement mode: 2g/400Hz
		// G_RANGE_2 - accelerometer range 2g
		// I2C_DIS - disable I2C interface
		// MEASUREMENT_400_HZ - measurement mode, 400Hz
        write_register(CONTROL, G_RANGE_2 | I2C_DIS | MEASUREMENT_400_HZ);

        // Settling time per DS = 10ms
        __delay_cycles(1000 * TICKS_PER_MICRO_SEC);

        // INT pin interrupt disabled
        P2IE  &= ~BIT5;

        // Repeat till interrupt Flag is set to show sensor is working
    } while (!(P2IN & BIT5));
}

uint8_t get_accelerometer_x_axis_value()
{
	return read_register(DOUTX);
}
