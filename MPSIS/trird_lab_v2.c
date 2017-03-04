#include <msp430.h>

#define LED1 1
#define LED2 2
#define LED3 3
#define LED4 4
#define LED5 5
#define LED6 6
#define LED7 7
#define LED8 8

#define LOW_POWER_MODE 1
#define HIGH_POWER_MODE 2
#define LOW_VOLTAGE_MODE 1
#define HIGH_VOLTAGE_MODE 2
#define LOW_FREQUENCY_MODE 1
#define HIGH_FREQUENCY_MODE 2

__interrupt void PORT1_ISR(void);
__interrupt void PORT2_ISR(void);
__interrupt void TIMER0_A0_ISR(void);

void set_diode_state(int diode_number, int state);
void set_core_voltage(int mode);
void set_mclk_frequency(int mode);
void change_mclk_frequency(int mode);
void indicate_power_mode(int mode);
void indicate_voltage_mode(int mode);
void bind_timer_to_diode();

volatile int current_power_mode = HIGH_POWER_MODE;
volatile int current_voltage_mode = HIGH_VOLTAGE_MODE;
volatile int current_frequency_mode = HIGH_FREQUENCY_MODE;


int main(void) {
	// Stop watchdog timer
    WDTCTL = WDTPW | WDTHOLD;

    // Set MCLK output
    P7SEL |= BIT7;
    P7DIR |= BIT7;
    // Clear interrupt flags
    P1IFG = 0x0000;

    // Enable diodes
    // P1.0, P8.1, P8.2 - diodes around buttons
    // P1.1-5 - diodes with shapes
    P1DIR = BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5;
    P8DIR = BIT1 | BIT2;

    // Initialize button 1
    P1REN |= BIT7;
    P1OUT |= BIT7;
    P1IE |= BIT7;
    P1IES |= BIT7;

    // Initialize button 2
    P2REN |= BIT2;
    P2OUT |= BIT2;
    P2IE |= BIT2;
    P2IES |= BIT2;

    set_core_voltage(HIGH_VOLTAGE_MODE);
    set_mclk_frequency(HIGH_FREQUENCY_MODE);
	
    // Enable global interrupts
    __bis_SR_register(GIE);
    __no_operation();
	return 0;
}


#pragma vector=PORT1_VECTOR
__interrupt void PORT1_ISR(void) {
	int next_power_mode = current_power_mode == HIGH_POWER_MODE ? LOW_POWER_MODE : HIGH_POWER_MODE;

	// indicating should be before enabling of LPM2 mode.
	current_power_mode = next_power_mode;
	indicate_power_mode(next_power_mode);
	// Clear interrupt flag for button 1
	P1IFG &= ~BIT7;

	if(next_power_mode == HIGH_POWER_MODE)
	{
		// exit from LPM2 mode
		LPM2_EXIT;
	}
	else if (next_power_mode == LOW_POWER_MODE)
	{
		// sets LPM2 mode bits into State Register
		__bis_SR_register(LPM2_bits + GIE);
	}
}

#pragma vector=PORT2_VECTOR
__interrupt void PORT2_ISR(void) {

	if (current_voltage_mode == HIGH_VOLTAGE_MODE)
	{
		set_core_voltage(LOW_VOLTAGE_MODE);
		change_mclk_frequency(LOW_FREQUENCY_MODE);
	}
	else if (current_voltage_mode == LOW_VOLTAGE_MODE)
	{
		set_core_voltage(HIGH_VOLTAGE_MODE);
		change_mclk_frequency(HIGH_FREQUENCY_MODE);
	}
	// Clear interrupt flag for button 2
	P2IFG &= ~BIT2;
}

#pragma vector = TIMER0_A0_VECTOR
__interrupt void TA0_ISR(void){
    P1OUT ^= BIT5;
}

void set_diode_state(int diode_number, int state)
{
	switch(diode_number) {
		case LED1:
			P1OUT = state ? P1OUT | BIT0 : P1OUT & ~BIT0;
			break;
		case LED2:
			P8OUT = state ? P8OUT | BIT1 : P8OUT & ~BIT1;
			break;
		case LED3:
			P8OUT = state ? P8OUT | BIT2 : P8OUT & ~BIT2;
			break;
		case LED4:
			P1OUT = state ? P1OUT | BIT1 : P1OUT & ~BIT1;
			break;
		case LED5:
			P1OUT = state ? P1OUT | BIT2 : P1OUT & ~BIT2;
			break;
		case LED6:
			P1OUT = state ? P1OUT | BIT3 : P1OUT & ~BIT3;
			break;
		case LED7:
			P1OUT = state ? P1OUT | BIT4 : P1OUT & ~BIT4;
			break;
		case LED8:
			P1OUT = state ? P1OUT | BIT5 : P1OUT & ~BIT5;
			break;
	}
}

void set_core_voltage(int mode)
{
	unsigned int level = mode == HIGH_VOLTAGE_MODE ? PMMCOREV_3 : PMMCOREV_2;

	// Subroutine to change core voltage
	// Open PMM registers for write
	PMMCTL0_H = PMMPW_H;

	if (mode == HIGH_VOLTAGE_MODE) {
		// Set SVS/SVM high side new level
		SVSMHCTL = SVSHE + SVSHRVL0 * level + SVMHE + SVSMHRRL0 * level;

		// Set SVM low side to new level
		SVSMLCTL = SVSLE + SVMLE + SVSMLRRL0 * level;

		// Wait till SVM is settled
		while ((PMMIFG & SVSMLDLYIFG) == 0);

		// Clear already set flags
		PMMIFG &= ~(SVMLVLRIFG + SVMLIFG);

		// Set VCore to new level
		PMMCTL0_L = level;

		// Wait till new level reached
		if ((PMMIFG & SVMLIFG))
			while ((PMMIFG & SVMLVLRIFG) == 0);

		// Set SVS/SVM low side to new level
		SVSMLCTL = SVSLE + SVSLRVL0 * level + SVMLE + SVSMLRRL0 * level;
	} else {
		// Set SVS/SVM low side to new level
		SVSMLCTL = SVSLE + SVSLRVL0 * level + SVMLE + SVSMLRRL0 * level;

		// Wait till flags sets
		while ((PMMIFG & SVSMLDLYIFG) == 0);

		PMMIFG &= ~(SVMLVLRIFG + SVMLIFG);

		if ((PMMIFG & SVMHIFG))
			while ((PMMIFG & SVMLVLRIFG) == 0);

		// Sets new level
		PMMCTL0_L = PMMCOREV0 * level;
	}

	// Lock PMM registers for write access
	PMMCTL0_H = 0x00;

	current_voltage_mode = mode;
	indicate_voltage_mode(mode);
}

void set_mclk_frequency(int mode)
{
	// Set DCO FLL reference = REFO
	UCSCTL3 |= SELREF__REFOCLK;

	// Disable the FLL control loop
	__bis_SR_register(SCG0);

	// Set lowest possible DCOx, MODx
	UCSCTL0 = 0x0000;

	// Select DCO range 7MHz operation
	UCSCTL1 = DCORSEL_2;

	// Set DCO Multiplier for 2MHz or 1MHz
	if (mode == HIGH_FREQUENCY_MODE){
		UCSCTL2 = FLLD_1 + 60;
	} else {
		UCSCTL2 = FLLD_1 + 30;
	}

	// Disable the FLL control loop
	__bic_SR_register(SCG0);

	current_frequency_mode = mode;
	bind_timer_to_diode();
}

void change_mclk_frequency(int mode)
{
	if (mode == HIGH_FREQUENCY_MODE){
		UCSCTL2 = FLLD_1 + 60;
	} else {
		UCSCTL2 = FLLD_1 + 30;
	}
	current_frequency_mode = mode;
}

void indicate_power_mode(int mode)
{
	set_diode_state(LED1, mode == HIGH_POWER_MODE);
	set_diode_state(LED3, mode == LOW_POWER_MODE);
}

void indicate_voltage_mode(int mode)
{
	set_diode_state(LED4, mode == HIGH_VOLTAGE_MODE);
	set_diode_state(LED5, mode == LOW_VOLTAGE_MODE);
}

void bind_timer_to_diode()
{
	TA0CCTL0 = CCIE;
	TA0CTL = TASSEL__SMCLK | ID_1 | MC__UPDOWN | TACLR;
	TA0CTL &= ~TAIFG;
	TA0CCR0 = 20000;
}