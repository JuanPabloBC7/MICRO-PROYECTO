.MODEL SMALL
.STACK
.DATA
SMS0    DB  13,10,'--------------MENU PRINCIPAL-----------------'
SMS1    DB  13,10,'|1.?DESEA VER LA HORA ACTUAL?               | $'
SMS2    DB  13,10,'|2.?DESEA VER LA HORA EN 5 DISTINTOS PAISES?| $'
SMS3    DB  13,10,'|3.?DESEA INGRESAR UN FORMATO UTC?          | $'
SMS4    DB  13,10,'|4.?DESEA CAMBIAR LA HORA ACTUAL?           | $'
SMS5    DB  13,10,'|5.VISTA ANALOGA DE UN RELOJ                | $'
SMS6    DB  13,10,'|6.SALIR                                    | $'
SMSO    DB  13,10,'--------------------------------------------- $'

SMS01   DB  13,10,'HORARIO DE INDIA     (UTC+5:30): $'
SMS02   DB  'HORARIO DE ALEMANIA  (UTC+2):    $'
SMS03   DB  'HORARIO DE CHICAGO   (UTC-5):    $'
SMS04   DB  'HORARIO DE ARGENTINA (UTC-3):    $'
SMS05   DB  'HORARIO DE JAPON     (UTC+9):    $'

SMSUTC  DB  'INGRESAR UTC+:$'

SMS DB  'HOLA $'
SMSHOLA3 DB  13,10,'HOLA3 $'
SMSHOLA4 DB  13,10,'HOLA4 $'
SMSHOLA5 DB  13,10,'HOLA5 $'

MENU    DB ?
HRSD    DB ?
HRSU    DB ?
MIND    DB ?
MINU    DB ?
SEGD    DB ?
SEGU    DB ?

HRS     DB ?
HRSPAISES     DB ?
MIN     DB ?
SEG     DB ?

HRSDAUX     DB ?
HRSUAUX     DB ?
MINDAUX     DB ?
MINUAUX     DB ?
HRSUTC      DB ?
MINUTC      DB ?

ANIO        DW ?
MES         DB ?
DIA         DB ?
DECIRDIA    DB ?
FECHA       DB ' FECHA: $'
DOM         DB 'DOMINGO $'
LUN         DB 'LUNES $'
MAR         DB 'MARTES $'
MIE         DB 'MIERCOLES $'
JUE         DB 'JUEVES $'
VIE         DB 'VIERNES $'
SAB         DB 'SABADO $'

.386
.CODE
PROGRAMA:
    MOV AX,@data
    MOV DS,AX
    CALL MENUPRINCIPAL
        
        MOV AX,0600H
        INT 10H    
    
    HORA PROC      ;++++++++++++++++++++++++++++++++++++++++++++++++++INICIO PROCEDIMIENTO HORA ACTUAL DE LA COMPU
        MOV AH,2CH ;INICIO TOMANDO LA HORA ACTUAL DE LA COMPU
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
        CALL MENUPRINCIPAL
        
        RELOJINDIVIDUAL proc
            CALL SEGUNDOS
            CALL MINUTOS
            CALL HORAS
            RET
            RELOJINDIVIDUAL ENDP
        
        HORAS PROC          ;OBTENER LOS HORARIOS (24 HORAS)
            MOV AL,CH  
            MOV HRS,CH 
            MOV HRSPAISES,CH   
            AAM             ;______________________________________________________AH GUARDA DECENAS (COCIENTE) Y AL UNIDAD (RESIDUO)
            ADD AX,3030H    ;_________________________________________________________________________________SUMA 30 A AH, 30 A AL
            MOV HRSD,AH
            MOV HRSU,AL 
            RET
            HORAS ENDP
        
        MINUTOS PROC
            MOV AL,CL
            MOV MIN,CL
            AAM
            ADD AX,3030H
            MOV MIND,AH
            MOV MINU,AL
            RET
            MINUTOS ENDP
             
        SEGUNDOS PROC 
            MOV AL,DH
            MOV SEG,DH
            AAM
            ADD AX,3030H
            MOV SEGD,AH
            MOV SEGU,AL
            RET 
            SEGUNDOS ENDP   ;FINALIZACION DE OBTENER LOS HORARIOS (24 HORAS)   
         
        MOSTRARFECHA PROC
            MOV AH,2AH          ;INICIO TOMANDO LA FECHA ACTUAL DE LA COMPU 
            INT 21h
            
            MOV ANIO,CX 
            MOV MES,DH 
            MOV DIA,DL 
            MOV DECIRDIA,AL
            MOV DX,OFFSET FECHA
            CALL IMPRIMIR
            
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
            MOV DX,OFFSET LUN 
            CALL IMPRIMIR 
            JMP IMPDIA
             
            DMAR:  
            MOV DX,OFFSET MAR 
            CALL IMPRIMIR 
            JMP IMPDIA
             
            DMIE:
            MOV dx,OFFSET MIE
            CALL IMPRIMIR
            JMP IMPDIA
          
            DJUE:  
            MOV DX,OFFSET JUE 
            CALL IMPRIMIR 
            JMP IMPDIA 
             
            DVIE:  
            MOV DX,OFFSET VIE 
            CALL IMPRIMIR 
            JMP IMPDIA
            
            DSAB:
            MOV DX,OFFSET SAB
            CALL IMPRIMIR
            JMP IMPDIA
             
            DDOM:
            MOV DX,OFFSET DOM
            CALL IMPRIMIR
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
            OR  DX,3030H 
            PUSH DX
            XOR DX,DX
            DIV BX
            OR  DX,3030H
            PUSH DX
            XOR DX,DX
            DIV BX
            OR  DX,3030H
            PUSH DX
            OR  AX,3030H
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
            INT 16H
            CALL LINEA
            RET
            MOSTRARFECHA ENDP                 ;FINALIZACION DE LA FECHA ACTUAL  
        HORA ENDP               ;++++++++++++++++++++++++++++++++++++++FINALIZACION DEL PRCEDIMIENTO DE HORA ACTUAL DE LA COMPU
        
    PAIS PROC                   ;+++++++++++++++++++++++++++++++++++++++++++++++++INICIO PROCEDIMIENTO DE LOS UTC DE LOS PAISES
        MOV DX,OFFSET SMS01
        CALL IMPRIMIR
        CALL HACERINDIA
        MOV DX,OFFSET SMS02
        CALL IMPRIMIR
        CALL HACERALEMANIA
        MOV DX,OFFSET SMS03
        CALL IMPRIMIR
        CALL HACERCHICAGO
        MOV DX,OFFSET SMS04
        CALL IMPRIMIR
        CALL HACERARGENTINA
        MOV DX,OFFSET SMS05
        CALL IMPRIMIR
        CALL HACERJAPON
        CALL MENUPRINCIPAL
        PAIS ENDP               ;+++++++++++++++++++++++++++++++++++++++FINALIZACION DEL PROCEDIMIENTO DE LOS UTC DE LOS PAISES
    FUTC PROC                   ;+++++++++++++++++++++++++++++++++++++++INICIO PROCEDIMIENTO DEL PROCEDIMIENTO DEL CAMBIO DE UTC
        MOV DX,OFFSET SMSUTC
        CALL IMPRIMIR 
        MOV AH,01H  ;_________________________________________________________________________________RECIBIR UN DATO DEL TECLADO
        INT 21H
        SUB AL,30H
        MOV HRSUTC,AL
        CALL MENUPRINCIPAL
        FUTC ENDP               ;++++++++++++++++++++++++++++++++++++++++++++++FINALIZACION DEL PROCEDIMIENTO DEL CAMBIO DE UTC
    CAMBIO PROC                 ;++++++++++++++++++++++++++++++++++++++++++++++++INICIO PROCEDIMIENTO DEL CAMBIO DE HORA ACTUAL
        MOV DX,OFFSET SMSHOLA4
        CALL IMPRIMIR
        CAMBIO ENDP             ;++++++++++++++++++++++++++++++++++++++FINALIZACION DEL PROCEDIMIENTO DEL CAMBIO DE HORA ACTUAL
    ANALOGICO PROC              ;++++++++++++++++++++++++++++++++++++++++++++++++++++++INICIO PROCEDIMIENTO DEL RELOJ ANALOGICO
        MOV DX,OFFSET SMSHOLA5
        CALL IMPRIMIR
        ANALOGICO ENDP          ;++++++++++++++++++++++++++++++++++++++++++++++FINALIZACION DEL PRCEDIMIENTO DEL RELOJ ANALOGICO

    MENUPRINCIPAL PROC
        XOR DX,DX
        MOV DX,OFFSET SMS0  ;IMPRIMIR MENSAJES INICIALES DEL MENU PRINCIPAL
        CALL IMPRIMIR
        ;MOV DX,OFFSET SMS1
        ;CALL IMPRIMIR
        MOV DX,OFFSET SMS2
        CALL IMPRIMIR
        MOV DX,OFFSET SMS3
        CALL IMPRIMIR
        MOV DX,OFFSET SMS4
        CALL IMPRIMIR
        MOV DX,OFFSET SMS5
        CALL IMPRIMIR
        MOV DX,OFFSET SMS6
        CALL IMPRIMIR
        MOV DX,OFFSET SMSO
        CALL IMPRIMIR        ;FINALIZACION DE LA IMPRESION DE MENSAJES DEL MENU PRINCIPAL
        CALL LINEA 
        
        MOV AH,01H  ;_________________________________________________________________________________RECIBIR UN DATO DEL TECLADO
        INT 21H
        SUB AL,30H
        MOV MENU,AL
        CALL LINEA
        
        ADD MENU,30H    ;_______________________________________________________________________________________PASARLO A DECIMAL
        CMP MENU,49     ;INICIO DE COMPARACIONES DEL MENU PRINCIPAL PARA IRME A LOS DISTINTOS PROCEDIMIENTOS
        JE HORA
        CMP MENU,50
        JE PAIS
        CMP MENU,51
        JE FUTC
        CMP MENU,52
        JE CAMBIO
        CMP MENU,53
        JE ANALOGICO
        CMP MENU,54
        JE SALIR        ;FINALIZACION DE COMPARACIONES PARA EL MENU PRINCIPAL DE LOS DISTINTOS PROCEDIMIENTOS
        RET
        MENUPRINCIPAL ENDP
        
    IMPRIMIR PROC
        MOV AH,09H
        INT 21H
        RET
        IMPRIMIR ENDP
    
    LINEA PROC 
        MOV DL,10   
        MOV AH,02H
        INT 21H
        RET
        LINEA ENDP
        
        
        
        
    HACERINDIA PROC
        XOR AX,AX
        MOV AL,MIN
        ADD AL,30
        ADD AL,MINUTC
        CMP AL,60
        JGE CAMBIARHORAMAS
        CALL MINDUAAM
        
        XOR AX,AX
        MOV AL,HRS
        ADD AL,11
        ADD AL,HRSUTC
        CMP AL,24
        JGE CAMBIARDIAMAS
        CALL HRSDUAAM
        RET
        HACERINDIA ENDP
        
    CAMBIARDIAMAS PROC
        SUB AL,24
        CALL HRSDUAAM
        RET
        CAMBIARDIAMAS ENDP
    
    CAMBIARHORAMAS PROC
        SUB AL,60
        ADD HRS,1
        CALL MINDUAAM
        RET
        CAMBIARHORAMAS ENDP
        
    MINDUAAM PROC
        AAM
        ADD AX,3030H
        MOV MINDAUX,AH
        MOV MINUAUX,AL
        RET
        MINDUAAM ENDP
    
    HRSDUAAM PROC
        AAM
        ADD AX,3030H
        MOV HRSDAUX,AH
        MOV HRSUAUX,AL
        CALL IMPRIMIRPAISES
        RET
        HRSDUAAM ENDP
        
    IMPRIMIRPAISES PROC
        MOV AH,02H
        MOV DL,HRSDAUX
        INT 21H
        MOV DL,HRSUAUX
        INT 21H
        MOV AH,02H
        MOV DL,58
        INT 21H
    
        MOV AH,02H
        MOV DL,MINDAUX
        INT 21H
        MOV DL,MINUAUX
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
        RET
        IMPRIMIRPAISES ENDP
        
    HACERALEMANIA PROC
        XOR AX,AX
        MOV AL,MIN
        ADD AL,MINUTC
        CMP AL,60
        JGE CAMBIARHORAMAS
        CALL MINDUAAM
        
        XOR AX,AX
        MOV AL,HRS
        ADD AL,8
        ADD AL,HRSUTC
        CMP AL,24
        JGE CAMBIARDIAMAS
        CALL HRSDUAAM
        RET
        HACERALEMANIA ENDP
        
    HACERCHICAGO PROC
        XOR AX,AX
        MOV AL,MIN
        ADD AL,MINUTC
        CMP AL,60
        JGE CAMBIARHORAMAS
        CALL MINDUAAM
        
        XOR AX,AX
        MOV AL,HRS
        ADD AL,1
        ADD AL,HRSUTC
        CMP AL,24
        JGE CAMBIARDIAMAS
        CALL HRSDUAAM
        RET
        HACERCHICAGO ENDP

    HACERARGENTINA PROC
        XOR AX,AX
        MOV AL,MIN
        ADD AL,MINUTC
        CMP AL,60
        JGE CAMBIARHORAMAS
        CALL MINDUAAM
        
        XOR AX,AX
        MOV AL,HRS
        ADD AL,3
        ADD AL,HRSUTC
        CMP AL,24
        JGE CAMBIARDIAMAS
        CALL HRSDUAAM
        RET
        HACERARGENTINA ENDP
        
    HACERJAPON PROC
        XOR AX,AX
        MOV AL,MIN
        ADD AL,MINUTC
        CMP AL,60
        JGE CAMBIARHORAMAS
        CALL MINDUAAM
        
        XOR AX,AX
        MOV AL,HRS
        ADD AL,15
        ADD AL,HRSUTC
        CMP AL,24
        JGE CAMBIARDIAMAS
        CALL HRSDUAAM
        RET
        HACERJAPON ENDP
        
    
    SALIR:
    MOV AH,4CH
    INT 21H
END PROGRAMA