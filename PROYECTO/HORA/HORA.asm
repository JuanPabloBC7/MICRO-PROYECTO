.MODEL SMALL
.STACK
.DATA
HRSD    DB ?
HRSU    DB ?
MIND    DB ?
MINU    DB ?
SEGD    DB ?
SEGU    DB ?

ANIO        DW ?
MES         DB ?
DIA         DB ?
DECIRDIA    DB ?
mens        DB 'FECHA: ',0AH,0DH,'$'
DOM         DB 10,13,'DOMINGO $'
LUN         DB 10,13,'LUNES $'
MAR         DB 10,13,'MARTES $'
MIE         DB 10,13,'MIERCOLES $'
JUE         DB 10,13,'JUEVES $'
VIE         DB 10,13,'VIERNES $'
SAB         DB 10,13,'SABADO $'

.CODE
PROGRAMA:
HORAACTUAL:
        MOV AH, 2CH ;INICIO TOMANDO LA HORA ACTUAL DE LA COMPU
        INT 21H
        
        CALL RELOJINDIVIDUAL
        
        MOV AH,02H
        MOV DL,HRSD
        INT 21H
        MOV DL,HRSU
        INT 21H
        MOV AH,02H
        MOV DL,58
        INT 21H
        
        MOV AH,02H
        MOV DL,MIND
        INT 21H
        MOV DL,MINU
        INT 21H
        MOV AH,02H
        MOV DL,58
        INT 21H
        
        MOV AH,02H
        MOV DL,SEGD
        INT 21H
        MOV DL,SEGU
        INT 21H
        CALL MOSTRARFECHA
        
    RELOJINDIVIDUAL proc
        CALL HORAS
        CALL MINUTOS
        CALL SEGUNDOS
        RET
    RELOJINDIVIDUAL ENDP
    
    HORAS PROC          ;OBTENER LOS HORARIOS (24 HORAS)
        MOV AL,CH      
        AAM             ;______________________________________________________AH GUARDA DECENAS (COCIENTE) Y AL UNIDAD (RESIDUO)
        ADD AX,3030H    ;_________________________________________________________________________________SUMA 30 A AH, 30 A AL
        MOV HRSD,AH
        MOV HRSU,AL 
        RET
        HORAS ENDP
    
    MINUTOS PROC
        MOV AL,CL
        AAM
        ADD AX,3030H
        MOV MIND,AH
        MOV MINU,AL
        RET
        MINUTOS ENDP
         
    SEGUNDOS PROC 
        MOV AL,DH 
        AAM
        ADD AX,3030H
        MOV SEGD,AH
        MOV SEGU,AL
        RET 
        SEGUNDOS ENDP   ;FINALIZACION DE OBTENER LOS HORARIOS (24 HORAS)   
     
    MOSTRARFECHA:
        MOV AH,2AH          ;INICIO TOMANDO LA FECHA ACTUAL DE LA COMPU 
        INT 21h
        
        MOV ANIO,CX 
        MOV MES,DH 
        MOV DIA,DL 
        MOV DECIRDIA,AL
        MOV AH,2
        MOV AH,09h 
        MOV DX,OFFSET mens 
        INT 21H
        MOV AH,2
        
        CMP DECIRDIA,00 
        JE DDOM 
        CMP DECIRDIA,01 
        JE DLUN 
        CMP DECIRDIA,02 
        JE DMAR 
        CMP DECIRDIA,03 
        JE DMIE 
        CMP DECIRDIA,04 
        JE DJUE 
        CMP DECIRDIA,05 
        JE DVIE 
        CMP DECIRDIA,06 
        JE DSAB
 
        DLUN:
        MOV AH,09 
        MOV DX,OFFSET LUN 
        INT 21H 
        MOV AH,2
        JMP IMPDIA
         
        DMAR: 
        MOV AH,09 
        MOV DX,OFFSET MAR 
        INT 21H
        MOV AH,2  
        JMP IMPDIA
         
        DMIE:
        MOV ah,09 
        MOV dx,OFFSET MIE
        INT 21h
        MOV AH,2 
        JMP IMPDIA
      
        DJUE:  
        MOV AH,09 
        MOV DX,OFFSET JUE 
        INT 21h 
        MOV AH,2
        JMP IMPDIA 
         
        DVIE:  
        MOV AH,09 
        MOV DX,OFFSET VIE 
        INT 21h 
        MOV AH,2
        JMP IMPDIA
        
        DSAB:
        MOV AH, 09
        MOV DX,OFFSET SAB
        INT 21H
        MOV AH,2
        JMP IMPDIA
         
        DDOM:
        MOV AH,09 
        MOV DX,OFFSET DOM
        INT 21H
        MOV AH,2
        JMP IMPDIA
        
        IMPDIA:             ;________________________________________________________________________________________MOSTAR DIA
        XOR AX,AX 
        XOR BX,BX 
        XOR DX,DX
        
        MOV AL,DIA 
        MOV BX,0AH
        DIV BL 
        OR  AX,3030H 
        MOV DX,AX 
        MOV AH,02H 
        INT 21H 
        
        XCHG DH,DL 
        MOV AH,02H 
        INT 21H
        
        MOV DL,47 
        MOV AH,02H 
        INT 21H 
         
        XOR AX,AX           ;________________________________________________________________________________________MOSTAR MES
        XOR BX,BX 
        XOR DX,DX
        
        MOV AL,MES 
        MOV BX,0AH
        DIV BL 
        OR  AX,3030H 
        MOV DX,AX 
        MOV AH,02H 
        INT 21H 
        
        XCHG DH,DL 
        MOV AH,02H 
        INT 21H
        
        MOV DL,47 
        MOV AH,02H 
        INT 21H 
 
        XOR AX,AX           ;________________________________________________________________________________________MOSTAR A?O
        XOR BX,BX 
        XOR DX,DX
        
        MOV AX,ANIO 
        MOV BX,0AH
        DIV BX 
        OR  AX,3030H 
        PUSH DX
        XOR DX,DX
        DIV BX
        OR  DX,3030H
        PUSH DX
        XOR DX,DX
        DIV BX
        OR  DX,303H 
        PUSH DX
        OR  AX,303H
        PUSH AX
        POP DX
        MOV AH,02H
        INT 21H 
        POP DX 
        MOV AH,02H 
        INT 21H 
        POP DX 
        MOV AH,02H 
        INT 21H 
        POP DX 
        MOV AH,02H 
        INT 21H
        
        MOV AL, 1
        INT 16H             ;FINALIZACION DE LA FECHA ACTUAL   
    
    
    MOV AH,4CH
    INT 21H
END PROGRAMA