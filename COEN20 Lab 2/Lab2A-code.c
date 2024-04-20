#include <stdint.h>
#include <stdio.h>

int32_t Bits2Signed(int8_t bits[8]) { //Converts array of bits to signed int
  int32_t n = 0;
  for(int i = 6; i >= 0; i--){        //Used the hint equation to add up pos
    n = ((n * 2) + bits[i]);          //bits (bits 6-0).
  }
  n -=bits[7]*128;                    //Subtracts 128 from result if bits[7] is
  return n;                           //1.
}

uint32_t Bits2Unsigned(int8_t bits[8]) { //Converts array of bits to unsigned int
  int32_t n = 0;
  for(int i = 7; i >= 0; i--){           //Used the hint equation to add up pos
    n = ((n * 2) + bits[i]);             //bits (bits 7-0).
  }
  return n;
}

void Increment(int8_t bits[8]) { //Adds 1 to bits
  for(int i = 0; i <= 7; i++){
    if(bits[i] == 0){            //If current bit is 0, changes to 1 and loop
      bits[i] = 1;               //breaks.
      break;
    }
    if(bits[i] == 1) {           //If current bit is 1, changes to 0 and loop
      bits[i] = 0;               //continues.
    }
  }
  return;
}

void Unsigned2Bits(uint32_t n, int8_t bits[8]) { //Converts Unsigned value to
    for(int i = 0; i <= 7; i++){                 //bits
        bits[i] = n % 2;                         //Checks for remainder. If
        n = n / 2;                               //there is remainder, bit is 1
    }                                            //and no remainder, bit is 0.
    return;                                      //Divides by 2 to reduce n and
}                                                //move to next significant bits
                                                 //position.
