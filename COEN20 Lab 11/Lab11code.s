                .syntax     unified
                .cpu        cortex-m4
                .text

                .global     Q16GoodRoot
                .thumb_func
                .align
Q16GoodRoot:    CLZ         R3,R0               //__CLZ(radicand)
                BIC         R2,R3,1             //__CLZ(radicand) & ~1
                MOV         R3,1073741824       //1 << 30
                LSR         R2,R3,R2            //bit = (1 << 30) >>
                                                //(__CLZ(radicand) & ~1)
                MOV         R3,0                //moves 0 into R3
L1:             CMP         R2,0                //compares bit to 0
                BEQ         L3                  //checks bit = 0, if so, skips
                                                //while loop and goes to return
                                                //instruction
                ADDS        R1,R3,R2            //R1 = sqroot(R3) + bit(R2)
                CMP         R0,R1               //compares residue(R2) and temp(R1)
                BLO         L2                  //if residue is less than temp
                                                //skip if block, else executes
                                                //code in if block (go to L2)
                SUB         R0,R0,R1            //residue -= temp
                ADD         R3,R3,R2,LSL 1      //sqroot += (bit << 1)
L2:             MOV         R1,0                //clears temp to be recalculated
                                                //on next loop
                LSR         R3,R3,1             //sqroot >>= 1
                LSR         R2,R2,2             //bit >>= 2
                B           L1                  //loops to while condition check
L3:             LSLS        R0,R3,8             //(Q16)(sqroot << 8)
                BX          LR                  //return (Q16)(sqroot << 8)
