                .syntax     unified
                .cpu        cortex-m4
                .text

                .global     GetNibble
                .thumb_func
                .align
GetNibble:      LSRS        R3,R1,1             //Shifts which >> 1 into R3
                LDRB        R0,[R0,R3]          //Loads ((uint8_t *) nibbles)
                                                //[which >> 1] into R0
                IT          CS                  //Compares (which & 1) == 1
                                                //using the carry flag from LSRS
                LSRCS       R0,R0,4             //Logical shifts right by 4 bits
                AND         R0,R0, 0x0F         //R0 = byte & 0b00001111
                BX          LR                  //returns R0 (byte & 0b00001111)
                                                //as a uint32_t

                .global     PutNibble
                .thumb_func
                .align
PutNibble:      LSRS        R3,R1,1             //Right shifts which >> 1 into R3
                LDRB        R1,[R0,R3]          //Loads R1 with 8bits of memory
                                                //from R0+R3
                ITTEE       CS                  //Compares (which & 1) == 1
                                                //using the carry flag from LSRS
                ANDCS       R1,R1,0x0F          //If equal *pbyte &= 0b00001111;
                ORRCS       R2,R1,R2,LSL 4      //*pbyte |= value << 4 ;
                ANDCC       R1,R1,0xF0          //If not *pbyte &= 0b11110000;
                ORRCC       R2,R2,R1            //*pbyte |= value ;
                STRB        R2,[R0,R3]          //stores the other half of |=
                BX          LR                  //Returns to function call
