#include <Adafruit_MMA8451.h>
#define GRAVITY_EARTH             (9.80665F)


//F_CPU is frequency of cpu
const int marker = 12;   // marker output pin
const int sw=10;
int aval=0;
int adcselect=0;
const int adc[]={0xC0,0xC1,0xC4};//A5,A4,A3,A1
bool need_start_byte=true;
// A0   D18   PF7         ADC7
// A1   D19   PF6         ADC6
// A2   D20   PF5         ADC5
// A3   D21   PF4         ADC4
// A4   D22   PF1         ADC1
// A5   D23   PF0         ADC0
int adcvalue[4]={0};
Adafruit_MMA8451 mma = Adafruit_MMA8451();
void setup() {
  pinMode(marker, OUTPUT); // pin = output
  pinMode(11, OUTPUT);
  pinMode(sw,INPUT);

    CLKPR=CLKPR & 0xF0; // write the CLKPCE bit to one and all the other to zero
    

  //TCCR0B = (TCCR0B & 0b11110001);
  
  
  DIDR0 = 0x3D;            // digital inputs disabled
  ADMUX = adc[adcselect];          // measuring on ADC0~2, use the internal 1.1V reference
                           //last four bit is  Analog Channel Selection Bits
  ADCSRA = 0xAF;           //b'1010 1111 AD-converter on, interrupt enabled, prescaler = 16
                           //last three bits for prescaler ,prescaler =2^(bits) a,
                           //eg 100=4,prescaler=2^4=16 ,here is 2^7=128
                           //adc freq=800000/128
  ADCSRB = 0xC0;           // b'0100 0000 ,AD channels MUX on, free running mode
  ADCSRA|=1<<6;             // Start the conversion by setting bit 6 (=ADSC) in ADCSRA
  sei();                   // set interrupt flag
  Serial.begin(115200);
  Serial1.begin(115200);
  //Init 3G
    if (! mma.begin()) {
    Serial.println("Couldnt start");
    while (1);
  }
  Serial.println("MMA8451 found!");
  mma.setRange(MMA8451_RANGE_2_G);
  mma.setDataRate(MMA8451_DATARATE_800_HZ);
  

  
  //Setup Timer2 to every 
//  TCCR0B = 0x00;        //Disbale Timer2 while we set it up
//  TCNT0  = 130;         //Reset Timer Count to 130 out of 255 ->leaves 125cycles to count
//  TIFR0  = 0x00;        //Timer2 INT Flag Reg: Clear Timer Overflow Flag
//  TIMSK0 = 0x01;        //Timer2 INT Reg: Timer2 Overflow Interrupt Enable
//  TCCR0A = 0x00;        //Timer2 Control Reg A: Wave Gen Mode normal
//  TCCR0B = 0x03;        //Timer2 Control Reg B: Timer Prescaler set to 32  freq=16000000/32/125=4k
//  OCR0A=124;
  /* 
Setting  Divisor   Frequency
0x01    1     31372.55
0x02    8     3921.16
0x03    32    980.39
0x04    64    490.20   <--DEFAULT
0x05    128   245.10
0x06    256   122.55
0x07    1024  30.64
  */
  //16000000 / (prescaler * (output_compare + 1)) = frequency 16000000/(32*125)=4k hz
}

bool state=false;
bool mmaReadReady=false;
//sensors_event_t event;

//for test
//byte setarray[]={127,128,129,130,131,132,133,134,255};
//int  setarr[]={1024,1025,1026,1027,-1027,-1028,-1029,-1030,-1031};
//int writecnt=0;
//bool swstatus=false;

int adc1,adc2,adc3;
int16_t x,y,z;
byte x1,x2,y1,y2,z1,z2,v11,v12,v21,v22,v31,v32;// byte for signed integer , i.e. 0~255

void loop() {
   
   adc1=adcvalue[0];
   adc2=adcvalue[1];
   adc3=adcvalue[2];
   mma.read();
   
     x=mma.x;
     y=mma.y;
     z=mma.z;

//for test
//     x=setarr[writecnt];
//     y=setarr[writecnt];
//     z=setarr[writecnt];
//     adc1=setarr[writecnt];
//     adc2=setarr[writecnt];
//     adc3=setarr[writecnt];
     
     v11=(adc1+((adc1>>15)&255))>>8;
     v12=adc1&0xff;
     v21=(adc2+((adc2>>15)&255))>>8;
     v22=adc2&0xff;
     v31=(adc3+((adc3>>15)&255))>>8;
     v32=adc3&0xff; 
     x1=(x+((x>>15)&255))>>8;
     x2=x&0xff;
     y1=(y+((y>>15)&255))>>8;
     y2=y&0xff;     
     z1=(z+((z>>15)&255))>>8;
     z2=z&0xff;

  //Serial.println(*portInputRegister(digitalPinToPort(sw)) &digitalPinToBitMask(sw));
  //Serial.println(*portInputRegister(digitalPinToPort(sw))&0x40);
  
  //according to source code,in this scene, the switch pin couldn't support PWM
  //otherwise need to turn of the PWM timer
  // If the pin that support PWM output, we need to turn it off
  // before getting a digital reading.
  //if (timer != NOT_ON_TIMER) turnOffPWM(timer);
  //0x40 for PORT register at position 6 b'0100 0000 if don't know, just use digitalPinToBitMask(sw)
  if(!(*portInputRegister(digitalPinToPort(sw))&0x40)){
     if(need_start_byte){Serial1.write(255);Serial1.write(255);need_start_byte=false;}
     Serial1.write(v11);
     Serial1.write(v12);
     Serial1.write(v21);
     Serial1.write(v22);
     Serial1.write(v31);
     Serial1.write(v32);

     Serial1.write(x1);
     Serial1.write(x2);
     Serial1.write(y1);
     Serial1.write(y2);
     Serial1.write(z1);
     Serial1.write(z2);

     
     //alway send end bytes for correcting data
     Serial1.write(254);
     Serial1.write(254);
     
     //for test
     //writecnt=(writecnt+1)%9;
}else{
  need_start_byte=true;
  }
//if(state){state=false;bitSet(PORTD, 6);}else{state=true;bitClear(PORTD,6);}

//source code
//size_t Print::write(const uint8_t *buffer, size_t size)
//{
//  size_t n = 0;
//  while (size--) {
//    if (write(*buffer++)) n++;
//    else break;
//  }
//  return n;
//}
    //if(state){state=false;bitSet(PORTD, 6);}else{state=true;bitClear(PORTD,6);}
}

//ISR(TIMER2_OVF_vect) {
//  //if(state){state=false;bitSet(PORTB, 4);}else{state=true;bitClear(PORTB,4);}
//  TCNT0 = 130;           //Reset Timer to 130 out of 255   1khz
//  TIFR0 = 0x00;          //Timer2 INT Flag Reg: Clear Timer Overflow Flag
//}; 




/*** Interrupt routine ADC ready ***/
//16000000/128

//ADC read interrupt
ISR(ADC_vect) {
  //bitClear(PORTB,4); // marker low
  //if(state){state=false;bitSet(PORTD, 6);}else{state=true;bitClear(PORTD,6);}

  aval = ADCL;        // store lower byte ADC
  aval += ADCH << 8;  // store higher bytes ADC
  adcvalue[adcselect]= aval;
  adcselect=(adcselect+1)%3;
  ADMUX = adc[adcselect];
  //bitSet(PORTB, 4);   // marker high  
}
