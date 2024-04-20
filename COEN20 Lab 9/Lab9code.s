                .syntax     unified
                .cpu        cortex-m4
                .text

                .global     Integrate
                .thumb_func
                .align
Integrate:      PUSH        {R4,LR}
                VPUSH       {S16,S17,S18,S19,S20,S21}   //push even # of float
                                                        //registers to store
                                                        //data and account for
                                                        //data being multi of 8.
                BL          DeltaX                      //execute DeltaX func.
                LDR         R0, =zero                   //To load a float zero
                VLDR        S18,[R0]                    //into float registers.
                                                        //S18 = v = 0.0
                VMOV.F32    S21,S0                      //Store data from DeltaX
                VMOV.F32    S0,1.0                      //S0 = 1.0
                VMOV.F32    S17,S18                     //S17 = S18 = a = 0.0
                VMOV.F32    S16,S0                      //S16 = S0 = x = 1.0
                VMOV.F32    S19,S0                      //S19 = S0 = 1.0
                MOVS        R4, 0                       //R4 = 0
                VMOV.F32    S20,0.5                     //S20 = 0.5 for div 2.
                b           do
while:          VMOV.F32    S17,S15                     //prev = v

                                                        //next 3 lines set up
                                                        //UpdateDisplay parameters
do:             VMOV.F32    S2,S18                      //S2 = v = S18, which is
                                                        //a += r after first loop
                MOV         R0,R4                       //R0 = R4 = 0
                VMOV.F32    S1,S17                      //S1 = r = prev
                BL          UpdateDisplay               //
                VDIV.F32    S0,S19,S16                  //S0 = 1/x
                ADDS        R4,R4,1                     //n++
                VADD.F32    S16,S16,S21                 //S16 = x + dx
                VDIV.F32    S15,S19,S16                 //S15 = 1/(x+dx)
                VADD.F32    S0,S15,S0                   //S0 = 1/x + 1/(x+dx)
                VMOV.F32    S15,S17                     //S15 = S17
                VMUL.F32    S0,S0,S20                   //S0 = r =
                                                        //(1/k + 1/(x+dx))/2
                                                        //multi because more
                                                        //efficient
                VMLA.F32    S15,S0,S0                   //S15 = v = r*r
                VADD.F32    S18,S18,S0                  //S18 = a += r
                VCMP.F32    S17,S15                     //compares v and prev
                VMRS        APSR_nzcv, FPSCR            //needed for float cmp.
                BNE         while                       //if v!=prev, go to do.
                VPOP        {S16,S17,S18,S19,S20,S21}
                POP         {R4,PC}

zero:           .float       0
