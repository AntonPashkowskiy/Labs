#include "msp430.h"
#include "dogs.h"

static const uint8_t FONT6x8_BASE[] =
{
	 //96 Bytes
	 0x78, 0x84, 0x84, 0x84, 0x78, 0x00, // 0
	 0x78, 0x10, 0x10, 0x50, 0x30, 0x00, // 1
	 0x78, 0x20, 0x10, 0x48, 0x38, 0x00, // 2
	 0x70, 0x10, 0x70, 0x10, 0x70, 0x00, // 3
	 0x04, 0x04, 0xFC, 0x84, 0x84, 0x00, // 4
	 0x78, 0x08, 0x78, 0x40, 0x78, 0x00, // 5
	 0xFC, 0x84, 0xFC, 0x80, 0xFC, 0x00, // 6
	 0x40, 0x20, 0x10, 0x08, 0x78, 0x00, // 7
	 0xFC, 0x84, 0xFC, 0x84, 0xFC, 0x00, // 8
	 0x70, 0x10, 0x70, 0x50, 0x70, 0x00, // 9
};
 static const uint8_t FONT6x8_BASE_INV[] =
 {
	 //96 Bytes
     0x78, 0x84, 0x84, 0x84, 0x78, 0x00, // 0
	 0x30, 0x50, 0x10, 0x10, 0x78, 0x00, // 1
	 0x38, 0x48, 0x10, 0x20, 0x78, 0x00, // 2
	 0x70, 0x10, 0x70, 0x10, 0x70, 0x00, // 3
	 0x84, 0x84, 0xFC, 0x04, 0x04, 0x00, // 4
	 0x78, 0x40, 0x78, 0x08, 0x78, 0x00, // 5
	 0xFC, 0x80, 0xFC, 0x84, 0xFC, 0x00, // 6
	 0x78, 0x08, 0x10, 0x20, 0x40, 0x00, // 7
	 0xFC, 0x84, 0xFC, 0x84, 0xFC, 0x00, // 8
	 0x70, 0x50, 0x70, 0x10, 0x70, 0x00, // 9
 };

// Font lookup table
const uint8_t * FONT6x8 = FONT6x8_BASE;

void flip_fonts()
{
	static bool inversed_mode = false;
	
	if (inversed_mode)
	{
		FONT6x8 = FONT6x8_BASE;
	}	
	else
	{
		FONT6x8 = FONT6x8_BASE_INV;
	}
	inversed_mode = !inversed_mode;
}

// Dog102-6 Initialization Commands
uint8_t Dogs102x6_initMacro[] = {
    0x40,
    0xA1,
    0xC8,
    0xA4,
    0xA6,
    0xA2,
    0x2F,
    11,
    0x81,
    0x0F,
    0xFA,
    0x90,
    0xAF,
    0xB0,
    0x10,
    0x00
};


void write_commands_to_screen(uint8_t *screen_commands, uint8_t commands_count)
{
    uint16_t gie = __get_SR_register() & GIE;

    __disable_interrupt();

    // CS Low
    P7OUT &= ~BIT4;
    // CD Low
    P5OUT &= ~BIT6;
	
    while (commands_count)
    {
        // USCI_B1 TX buffer ready?
        while (!(UCB1IFG & UCTXIFG)) ;

        // Transmit data
        UCB1TXBUF = *screen_commands;

        // Increment the pointer on the array
        screen_commands++;

        // Decrement the Byte counter
        commands_count--;
    }

    // Wait for all TX/RX to finish
    while (UCB1STAT & UCBUSY) ;

    // dummy read to empty RX buffer and clear any overrun conditions
    UCB1RXBUF;

    // CS High
    P7OUT |= BIT4;

    // restore original GIE state
    __bis_SR_register(gie);
}

void screen_init()
{
    // Port initialization for LCD operation
	// Reset is active low
    P5DIR |= BIT7;
    P5OUT &= BIT7;
	P5OUT |= BIT7;

    // Chip select for LCD
    P7DIR |= BIT4;
	// CS is active low
	P7OUT &= ~BIT4;
    
	// Command/Data for LCD
    P5DIR |= BIT6;
    // CD Low for command
    P5OUT &= ~BIT6;

    // P4.1 option select SIMO (slave in, master out)
    P4SEL |= BIT1;
    P4DIR |= BIT1;
    // P4.3 option select CLK
    P4SEL |= BIT3;
    P4DIR |= BIT3;

    // Initialize USCI_B1 for SPI Master operation
    // Put state machine in reset
    UCB1CTL1 |= UCSWRST;
	
    // UCMST - master mode select
	// UCSYNC - enabled synchro mode of data transmission/recieving
	// UCCKPH - data is captured on the first UCLK edge and changed on the following edge.
	// UCMSB - MSB (most significant byte first) first select. Controls the direction of the receive and transmit shift register.
	// UCMODE_0 - 3 pin SPI
    UCB1CTL0 = UCCKPH + UCMSB + UCMST + UCMODE_0 + UCSYNC;
    
	// UCSWRST - keep reset state
	// UCSSEL_2 - SMCLK clock source
    UCB1CTL1 = UCSSEL_2 + UCSWRST;
    
	// UCA0BR0, UCA0BR1 - boud-rate control
	//Low byte of clock prescaler setting of the baud-rate generator. The 16-bit value 
	//of (UCAxBR0 + UCAxBR1 × 256) forms the prescaler value UCBRx.
	UCB1BR0 = 0x02;
    UCB1BR1 = 0;
	
    // Release USCI state machine
    UCB1CTL1 &= ~UCSWRST;
    UCB1IFG &= ~UCRXIFG;

    write_commands_to_screen(Dogs102x6_initMacro, 13);

    // Deselect chip
    P7OUT |= BIT4;
}

void screen_backlight_init()
{
    // Turn on Backlight
    P7DIR |= BIT6;
    P7OUT |= BIT6;
    // Uses PWM to control brightness
    P7SEL |= BIT6;

    // start at full brightness (8)
    TB0CCTL4 = OUTMOD_7;
    TB0CCR4 = TB0CCR0 >> 1;

    TB0CCR0 = 50;
    TB0CTL = TBSSEL_1 + MC_1;
}

void screen_backlight_set()
{
	TB0CCTL4 = OUTMOD_7;
	
	unsigned int ccrval = (TB0CCR0 >> 4);
	unsigned int duty_cycle = 12;
	unsigned int i;
	
	for (i = 0; i < 11; i++)
	{
		duty_cycle += ccrval;
	}	
	TB0CCR4 = duty_cycle;
	TB0CTL |= MC0;
}

void screen_write_data(uint8_t *p_data, uint8_t data_count)
{
    // Store current GIE state
    uint16_t gie = __get_SR_register() & GIE;

    // Make this operation atomic
    __disable_interrupt();

	// CS Low
	P7OUT &= ~BIT4;
	//CD High
	P5OUT |= BIT6;

	while (data_count)
	{
		// USCI_B1 TX buffer ready?
		while (!(UCB1IFG & UCTXIFG)) ;

		// Transmit data and increment pointer
		UCB1TXBUF = *p_data++;

		// Decrement the Byte counter
		data_count--;
	}

	// Wait for all TX/RX to finish
	while (UCB1STAT & UCBUSY) ;

	// Dummy read to empty RX buffer and clear any overrun conditions
	UCB1RXBUF;

	// CS High
	P7OUT |= BIT4;

    // Restore original GIE state
    __bis_SR_register(gie);
}

void screen_set_address(uint8_t page_address, uint8_t column_address)
{
    uint8_t page_address_command[1];
    uint8_t H = 0x00;
    uint8_t L = 0x00;
    uint8_t column_address_commands[] = { 0x10, 0x00 };
	
	// Page Address Command = Page Address Initial Command + Page Address
    page_address_command[0] = 0xB0 + (7 - page_address);

    // Separate Command Address to low and high
    L = (column_address & 0x0F);
    H = (column_address & 0xF0);
    H = (H >> 4);
	
    // Column Address CommandLSB = Column Address Initial Command + Column Address bits 0..3
    column_address_commands[0] = L;
    // Column Address CommandMSB = Column Address Initial Command + Column Address bits 4..7
    column_address_commands[1] = 0x10 + H;

    // Set page address
    write_commands_to_screen(page_address_command, 1);
    // Set column address
    write_commands_to_screen(column_address_commands, 2);
}

void screen_clear()
{
    uint8_t lcd_data[] = { 0x00 };
    uint8_t page_index = 0;
	uint8_t pages_count = 8;
	uint8_t column_index = 0;

    // 8 total pages in LCD controller memory
    for (page_index = 0; page_index < pages_count; page_index++)
    {
        screen_set_address(page_index, 0);
		
        // 102 total columns in LCD controller memory
        for (column_index = 0; column_index < HORIZONTAL_SCREEN_SIZE; column_index++)
		{
			screen_write_data(lcd_data, 1);
		}       
    }
}

void screen_write_char(uint8_t row_number, uint8_t column_number, uint16_t character)
{
    // subtract 32 because FONT6x8[0] is "space" which is ascii 32,
    // multiply by 6 because each character is columns wide
    int idx = (character - '0') * 6;

    screen_set_address(row_number, column_number);
    screen_write_data((uint8_t *)FONT6x8 + idx, 6);
}

void screen_write_line(char* line)
{
	unsigned int index;
	const int line_length = 4;
	
    for (index = 0; index < line_length; ++index)
	{
		uint8_t row_number = 7;
		uint8_t column_number = 84 + 6 * index;
		
		screen_write_char(row_number, column_number, line[index]);
	}
}
