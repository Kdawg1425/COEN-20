                .syntax     unified
                .cpu        cortex-m4
                .text

                .global     CopyCell
                .thumb_func
                .align
CopyCell:       LDR         R2,=0               //sets row = 0
OuterLoop:      LDR         R3,=0               //sets col = 0
                CMP         R2,60               //compares row < 60
                BGE         OuterDone           //if R2 >= 60, ends function
InnerLoop:      CMP         R3,60               //compare col < 60
                BGE         InnerDone           //if R3 >= 60, exits Inner Loop
                LDR         R12,[R1,R3,LSL 2]   //R12 = src[col]
                STR         R12,[R0,R3,LSL 2]   //dst[col] = src[col]
                ADD         R3,R3,1             //col++
                B           InnerLoop           //Loops back to InnerLoop
InnerDone:      ADD         R0,R0,960           //Increments dst
                ADD         R1,R1,960           //Increments src
                ADD         R2,R2,1             //row++
                B           OuterLoop           //Loops back to OuterLoop
OuterDone:      BX          LR                  //End of function


                .global     FillCell
                .thumb_func
                .align
FillCell:       LDR         R2,=0               //sets row = 0
OutLoop:        LDR         R3,=0               //sets col = 0
                CMP         R2,60               //compares row < 60
                BGE         OutDone             //if row >= 60, ends function
InLoop:         CMP         R3,60               //compares col < 60
                BGE         InDone              //if col >= 60, exits Inner Loop
                STR         R1,[R0,R3,LSL 2]    //dst[col] =  pixel
                ADD         R3,R3,1             //col++
                B           InLoop              //Loops back to InLoop
InDone:         ADD         R0,R0,960           //Increments dst
                ADD         R2,R2,1             //row++
                B           OutLoop             //Loops back to OutLoop
OutDone:        BX          LR                  //End of function

.end
