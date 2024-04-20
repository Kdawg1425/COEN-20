                .syntax     unified
                .cpu        cortex-m4
                .text

                .global     Zeller1
                .thumb_func
                .align
Zeller1:        PUSH        {R4,R5,R6}
                LDR         R12,=13
                MUL         R1,R1,R12           //13*m
                SUB         R1,R1,1             //13*m-1
                LDR         R12,=5
                UDIV        R1,R1,R12           //(13*m-1)/5
                ADD         R4,R0,R1            //k+(13*m-1)/5)
                ADD         R4,R4,R2            //k+(13*m-1)/5)+D
                ADD         R4,R4,R2,LSR 2      //k+(13*m-1)/5)+D+(D/4)
                ADD         R4,R4,R3,LSR 2      //k+(13*m-1)/5)+D+(D/4)+(C/4)
                LDR         R12,=0
                ADD         R12,R12,R3,LSL 1    //R12 = C * 2
                SUB         R4,R4,R12           //k+(13*m-1)/5)+D+(D/4)+(C/4)-2C
                LDR         R12,=7
                SDIV        R5,R4,R12           //f / 7
                MOV         R6,R5               //moves f to R6
                MLS         R5,R6,R12,R4        //f % 7
                CMP         R5,0
                IT          LT                  //if remainder < 0,
                ADDLT       R5,R5,R12           //add 7 to remainder
                MOV         R0,R5               //moves remainder to R0
                POP         {R4,R5,R6}
                BX          LR                  //returns remainder as uint32_t

                .global     Zeller2
                .thumb_func
                .align
Zeller2:        PUSH        {R4,R5,R6}
                ADD         R4,R2,R3,LSR 2      //R4 = D + C/4
                ADD         R5,R1,R1,LSL 1      //R5 = m + 2m
                ADD         R0,R0,R4            //R0 = k + D + C/4
                ADD         R1,R1,R5,LSL 2      //R1 = m + 4*(3m)
                LDR         R5,.L5              //R5 = -858993459
                LDR         R6,.L5+4            //R6 = -1840700269
                ADD         R0,R0,R2,LSR 2      //R0 = k + D + C/4 - D/2
                SUBS        R1,R1,1             //R1 = 13m - 1
                SUB         R0,R0,R3,LSL 1      //R0 = k + D + C/4 - D/2 - 2C
                UMULL       R2,R3,R5,R1         //R3.R2 = R5 * R1 ((13m-1)/5)
                ADD         R3,R0,R3,LSR 2      //R3 = k+D+(C/4)-(D/2)-(2C)/(C/4)
                SMULL       R0,R1,R3,R6         //Signed division
                ADDS        R0,R3,R1            //by
                ASRS        R2,R3,31            //+7
                RSB         R0,R2,R0,ASR 2      
                RSB         R0,R0,R0,LSL 3      //R0 = 8R0 - R0
                SUBS        R0,R3,R0            //R0 = R3 - R0
                IT          MI                  //If Register holds minus/negative
                ADDMI       R0,R0,7             //If R0 < 0, R0 + 7 (remainder +7)
                POP         {R4,R5,R6}
                BX          LR                  //returns remainder
.L5:            .word       -858993459
                .word       -1840700269

                .global     Zeller3
                .thumb_func
                .align
Zeller3:        PUSH        {R4,R5,R6}
                ADD         R6,R1,R1,LSL 3      //R6 = m + 8m
                ADD         R1,R6,R1,LSL 2      //R1 = m + 8m + 4m
                LDR         R6,=1
                SUB         R1,R1,R6            //R1 = 13m - 1
                LDR         R6,=5
                UDIV        R1,R1,R6            //R1 = (13m-1)/5
                ADD         R4,R0,R1            //R4 = k + (13m-1)/5
                ADD         R4,R4,R2            //R4 = k + (13m-1)/5 + D
                ADD         R4,R4,R2,LSR 2      //R4 = k + (13m-1)/5 + D + D/4
                ADD         R4,R4,R3,LSR 2      //R4 = k+()(13m-1)/5)+D+D/4+C/4
                LDR         R6,=0
                ADD         R6,R6,R3,LSL 1      //R6 = 2*C
                SUB         R4,R4,R6            //R6=k+()(13m-1)/5)+D+D/4+C/4-2C
                LDR         R6,=7
                SDIV        R5,R4,R6            //R5 = f/7
                MOV         R12, R5             //R12 = f/7
                LDR         R6,=0
                ADD         R5,R6,R12,LSL 3     //R5 = 8 * (f/7)
                SUB         R5,R5,R12           //R5 = 8(f/7) - (f/7) = 7*(f/7)
                SUB         R5,R4,R5            //R5 = f - 7(f/7)
                LDR         R4,=7
                CMP         R5,0
                IT          LT                  //R5 < 0
                ADDLT       R5,R5,R4            //If so, remainder (R5)+7
                MOV         R0,R5               //R0 = R5
                POP         {R4,R5,R6}
                BX          LR                  //Returns R0 (remainder)
