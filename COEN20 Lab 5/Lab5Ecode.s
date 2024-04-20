.syntax     unified
.cpu        cortex-m4
.text

.global     Log2Phys
.thumb_func
.align
Log2Phys:                                   //R0-lba, R1-heads, R2-sectors, R3-CHS struct
PUSH        {R4, R5, R6}        //R4-cylinder,R5-head,R6-sector

UDIV        R5, R0, R2          //R6=lba / sectors

UDIV        R4, R5, R1          //R4=(lba / sectors) / heads

MLS         R6, R2, R5, R0      //R5=lba % sectors

ADDS        R6, R6, 1           //Add 1 to R5

MLS         R4, R1, R4, R5      //R4=(lba / sectors) % heads

MUL         R2, R2, R1          //R2= sectors * heads

STRB        R6, [R3, 3]         //Stores value in sector in struct

UDIV        R0, R0, R2          //R0=lba / (sectors * heads)

STRB        R4, [R3, 2]         //stores value in head in struct

STRH        R0, [R3]            //stores value in cylinder in struct

POP         {R4, R5, R6}        //Pops temp variables

BX          LR                  //Returns Link Register
