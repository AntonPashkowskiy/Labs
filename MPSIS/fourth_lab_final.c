#include <msp430.h>

#define LED1 1
#define LED3 3

__interrupt void ADC12ISR(void);
void set_diode_state(int diode_number, int state);

volatile unsigned int potentiometer;
volatile unsigned int reference_voltage_av;

int main(void)
{
	// Stop wachdog timer
	WDTCTL = WDTPW + WDTHOLD;

	// Diodes configuration
	P8OUT &= ~BIT2;
	P8DIR |= BIT2;
	P1OUT &= ~BIT0;
	P1DIR |= BIT0;

	// Potentiometer to output mode
	P8DIR |= BIT0;
	P8OUT |= BIT0;

	// Reset REFMSTR to hand over control to ADC12_A control registers
	REFCTL0 &= ~REFMSTR;

	// ADC12ON - enable ADC12CTL0
	// ADC12MSC - multiple sample and convert
	// ADC12REFON - reference voltage generator on.
	// ADC12SHT0_15 - control the interval sampling timer
	ADC12CTL0 = ADC12ON | ADC12MSC | ADC12REFON | ADC12SHT0_15;

	// ADC12SHP - pulse sample mode
	// ADC12CONSEQ_3 - repeat sequence of channels
	// ADC12DIV_7 - clock devider, devide by 7
	ADC12CTL1 = ADC12SHP | ADC12CONSEQ_3 | ADC12DIV_7;

	// A5 input connected with potentiometer
	ADC12MCTL0 = ADC12INCH_5;

	// A11 input connected to (AVcc - AVss) / 2
	// AVcc - analog reference voltage
	// AVss - analog ground
	// ADC12EOS - end of sequence
	ADC12MCTL1 = ADC12INCH_11 | ADC12EOS;

	// ADC12IE - interrupt enable register. Controls interrupts from 15 inputs.
	// ADC12IFG1 - ADC12MEM1 interrupt flag. Flag is set when ADC12MEM1 is loaded. Reset when ADC12MEM1 accessed.
	ADC12IE = ADC12IFG1;

	// ADC12ENC - permission for measurement
	// ADC12SC - program launch of sample and conversion
	ADC12CTL0 |= ADC12ENC | ADC12SC;

	// CPU off, global interrupts enabled
	__bis_SR_register(LPM0_bits + GIE);
	__no_operation();
}

#pragma vector=ADC12_VECTOR
__interrupt void ADC12ISR(void)
{
	potentiometer = ADC12MEM0;
	reference_voltage_av = ADC12MEM1;

	if (potentiometer > reference_voltage_av) {
		set_diode_state(LED1, 0);
		set_diode_state(LED3, 1);
	} else if (reference_voltage_av > potentiometer) {
		set_diode_state(LED1, 1);
		set_diode_state(LED3, 0);
	} else {
		set_diode_state(LED1, 1);
		set_diode_state(LED3, 1);
	}
}

void set_diode_state(int diode_number, int state)
{
	switch(diode_number) {
		case LED1:
			P1OUT = state ? P1OUT | BIT0 : P1OUT & ~BIT0;
			break;
		case LED3:
			P8OUT = state ? P8OUT | BIT2 : P8OUT & ~BIT2;
			break;
		default:
			break;
	}
}