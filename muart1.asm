M1_RCU	EQU	0D000H			; Registo controlo da MUART-1
M1_REP	EQU	0D002H			; Registo estado da MUART-1
M1_RD1	EQU	0D004H			; Registo dados da UART 1 da MUART-1 (porto de Rx)
M1_RD2	EQU	0D006H			; Registo dados da UART 2 da MUART-1 (porto de Tx)



PLACE 			3300H
tab:			WORD	0		
				WORD	0
				WORD	varrermuart
				WORD	enviarmuart





PLACE 0000H
				MOV 	R9, 4000H
				MOV		SP, 3000H
				MOV		BTE, tab
				EI0
				EI1
				EI2
				EI3
				EI
				CALL 	inicmuart		; inicializa MUART-1
				MOV 	R7, 0H

inicio:				
				MOV 	[R9], R5
				ADD 	R9, 2
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
				JMP 	inicio






; ******************************************************************************
; * ROTINA:		muart
; * DESCRICAO: 	rotina para tratar da muart
; * PARAMETROS:	-
; * RETORNA:	R5 (tecla premida)
; * NOTAS: 		-
; ******************************************************************************
;muart: 		PUSH 	R2
;				CALL	varrermuart		; espera que haja caracter
;				CMP		R2, 0			;
;				JNZ 	ciclo_envia
;				MOV 	R5, 11H
;				JMP		fimmuart	
;ciclo_envia:	CALL	enviarmuart		; escreve outra vez
;				CMP		R2, 1			; conseguiu?
;				JZ		ciclo_envia		; vai tentando
;
;fimmuart: 		POP 	R2
;				RET


; ******************************************************************************
; * ROTINA:		inicmuart
; * DESCRICAO: 	rotina inicializar muart
; * PARAMETROS:	-
; * RETORNA:	-
; * NOTAS: 		-
; ******************************************************************************

inicmuart:		PUSH	R0
				PUSH	R1
				MOV		R0, M1_RCU
				MOV		R1, 00H
				MOVB	[R0], R1
				POP		R1
				POP		R0
				RET

; ******************************************************************************
; * ROTINA:		varrermuart
; * DESCRICAO: 	verificar se ha caracter novo e devolver o seu valor
; * PARAMETROS:	-
; * RETORNA:	R2 (chegou caracter? 0/1), R3 (valor caracter)
; * NOTAS: 		-
; ******************************************************************************

varrermuart:	PUSH	R0
				PUSH	R1

				ADD 	R7, 1H

				MOV		R0, M1_REP		; registo de estado da MUART-1
				MOVB	R1, [R0]		; lê estado
				BIT		R1, 0			; bit=1 se tiver chegado um novo caracter
				JZ		no_char
				MOV		R0, M1_RD1		; registo de dados (canal 1)
				MOVB	R3, [R0]		; caracter que chegou
				MOV		R2, 1			; chegou caracter
				JMP		fimvarmuart

no_char:		MOV		R2, 0			; nao ha nenhum caracter novo

fimvarmuart:	MOV 	R5, R3
				POP		R1
				POP		R0
				RFE

; ******************************************************************************
; * ROTINA:		enviarmuart
; * DESCRICAO: 	tenta enviar caracter para muart se estiver pronta
; * PARAMETROS:	R5 (caracter a enviar)
; * RETORNA:	R2 (chegou caracter? 0/1), R5 (tecla premida)
; * NOTAS: 		-
; ******************************************************************************

enviarmuart:	PUSH	R0
				PUSH	R1

				MOV 	R8, 0FFFFH

				MOV		R0, M1_REP			; registo de estado da MUART-1
				MOVB	R1, [R0]			; lê estado
				BIT		R1, 5				; bit=1 se o canal 2 estiver pronto a enviar
				JZ		naoconseguiu
				MOV		R0, M1_RD2			; registo de dados (canal 2)
				MOVB	[R0], R5 			; envia o caracter
				MOV		R2, 1				; conseguiu enviar o caracter
				JMP		fimenvmuart	

naoconseguiu:	MOV		R2, 0				; nao conseguiu enviar o caracter

fimenvmuart:	POP	R1
				POP	R0
				RFE
