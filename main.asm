; ******************************************************************************
; *
; * PROJECTO - ARQUITECTURA DE COMPUTADORES - 2 SEM - 2013/2014
; * 
; * JOAO LEITE - JOAO TOMAZIO - TIAGO FERNANDES
; *
; ******************************************************************************

; ******************************************************************************
; * CONSTANTES
; ******************************************************************************

ZERO			EQU 	0H
UM 				EQU 	1H      		; primeira linha/coluna
TRES			EQU 	3H
DEZ				EQU		0AH
SESSENTA		EQU		3CH				; 60 segundos/minutos	
DIA 			EQU		18H 			; 24 horas			
BYTESCREEN		EQU		80H 			; numero bytes do pixelscreen
ULTIMA			EQU 	8H      		; ultima linha/coluna

; ******************************************************************************
; * ENDERECOS MEMORIA
; ******************************************************************************

PINPOUT			EQU		8000H			; endereco teclado
PIN 			EQU		0E000H			; endereco teclado
NENHUMA 		EQU 	11H				; valor a mostrar se nenhuma tecla foi premida
STACK			EQU 	5000H 			; endereco do stack point

PIXELSCREEN 	EQU 	0C000H			; endereco do pixelscreen
NUMS 			EQU		1000H

SEGUNDOS 		EQU		2002H			; endereco guardar segundos
MINUTOS 		EQU		2004H			; endereco guardar minutos
HORAS 			EQU		2006H			; endereco guardar horas					



; ******************************************************************************
; * TABELA NUMEROS DO PIXELSCREEN
; ******************************************************************************

PLACE 1000H
table0:		STRING 1,1,1,  1,0,1,  1,0,1,  1,0,1,  1,0,1,  1,0,1,  1,1,1

PLACE 1100H
table1:		STRING 0,0,1,  0,1,1,  0,0,1,  0,0,1,  0,0,1,  0,0,1,  0,0,1

PLACE 1200H
table2:		STRING 1,1,1,  0,0,1,  0,0,1,  1,1,1,  1,0,0,  1,0,0,  1,1,1

PLACE 1300H
table3:		STRING 1,1,1,  0,0,1,  0,0,1,  1,1,1,  0,0,1,  0,0,1,  1,1,1

PLACE 1400H
table4:		STRING 1,0,1,  1,0,1,  1,0,1,  1,1,1,  0,0,1,  0,0,1,  0,0,1

PLACE 1500H
table5:		STRING 1,1,1,  1,0,0,  1,0,0,  1,1,1,  0,0,1,  0,0,1,  1,1,1

PLACE 1600H
table6:		STRING 1,1,1,  1,0,0,  1,0,0,  1,1,1,  1,0,1,  1,0,1,  1,1,1

PLACE 1700H
table7:		STRING 1,1,1,  0,0,1,  0,0,1,  0,0,1,  0,0,1,  0,0,1,  0,0,1

PLACE 1800H
table8:		STRING 1,1,1,  1,0,1,  1,0,1,  1,1,1,  1,0,1,  1,0,1,  1,1,1

PLACE 1900H
table9:		STRING 1,1,1,  1,0,1,  1,0,1,  1,1,1,  0,0,1,  0,0,1,  1,1,1


; ******************************************************************************
; * TABELA DE INTERRUPCOES
; ******************************************************************************

PLACE		3000H
tab:		WORD	rot0 					; Tabela de vectores de interrupção


PLACE 0
; ******************************************************************************
; * CORPO DO PROGRAMA
; *
; *
; * HH:MM:SS => R9:R8:R7
; ******************************************************************************

				MOV 	SP, STACK 			; inicializa SP
				MOV		BTE, tab			; inicializa BTE

				CALL	inicializa

				EI0
				EI


inicio:			MOV 	R3, SEGUNDOS
				MOV 	R2, [R3]
verificar:		CMP 	R7, R2
				JZ 		verificar			; se num nao foi alterado
				CALL	relogio
				JMP		inicio





; ******************************************************************************
; * ROTINA:		relogio
; * DESCRICAO: 	rotina para escrever relogio no pixelescreen  R9:R8:R7
; * PARAMETROS:	R9, R8, R7
; * DESTROI:	-
; * NOTAS: 		valores x para (h,m,s) sao: (3, D, 17)
; ******************************************************************************

relogio:		PUSH 	R6
				PUSH 	R0
				PUSH 	R2
				PUSH 	R3

				MOV 	R6, SESSENTA
				CMP 	R7,	R6				; se chegou aos 60 segundos
				JNZ		rsegundos

				MOV 	R7, ZERO			; voltar a por segundos a 00
				ADD		R8, 1H 				; somar 1 minuto
				CMP 	R8, R6				; verificar se chegou a 60minutos
				JNZ		rminutos

				MOV 	R8, ZERO			; voltar a por minutos a zero
				ADD		R9, 1H 				; somar 1 minuto
				MOV 	R6,	DIA				; 24 horas
				CMP 	R9, R6				; verificar se chegou a 24 horas
				JNZ		rhoras
				MOV 	R9, ZERO			; voltar a por minutos a zero

rhoras:			MOV 	R0, 3H 				; endereco x=3 (horas)
				MOV 	R3, HORAS 
				MOV 	R2, [R3] 			; ver valor actual dos minutos
				CALL	escrevenum 
				MOV 	R2, R9
				MOV 	[R3], R2 			; guardar valor actual dos minutos
				CALL	escrevenum

rminutos:		MOV 	R0, 0DH 			; endereco x=13 (minutos)
				MOV 	R3, MINUTOS 
				MOV 	R2, [R3] 			; ver valor actual dos minutos
				CALL	escrevenum 
				MOV 	R2, R8
				MOV 	[R3], R2 			; guardar valor actual dos minutos
				CALL	escrevenum

rsegundos:		MOV 	R0, 17H 			; endereco x=23 (segundos)
				MOV 	R3, SEGUNDOS 
				MOV 	R2, [R3] 			; ver valor actual dos segundos
				CALL	escrevenum			; apagar valor dos segundos
				MOV 	R2, R7
				MOV 	[R3], R2 			; guardar valor actual dos segundos
				CALL	escrevenum

fimrelogio:		POP 	R3
				POP 	R2
				POP 	R0
				POP 	R6
				RET


		





; ******************************************************************************
; * ROTINA:		escrevenum
; * DESCRICAO: 	rotina para escrever segundos no pixelescreen (R0,5) do registo R2
; * PARAMETROS:	R0, R2
; * DESTROI:	-
; ******************************************************************************

escrevenum:	PUSH 	R0
			PUSH 	R1
			PUSH 	R2
			PUSH	R3

			MOV 	R3,	R2
			MOV 	R1,	DEZ
			MOD		R3, R1 					; algarismo de menor peso no R3
			DIV		R2,	R1					; algarismo de maior peso no R2

			MOV 	R1, 5H					; coordenada y=5
			CALL	algarismo				; escrever algarismo maior peso
			
			MOV 	R2,	R3					; mover algarismo menor peso para R2
			ADD 	R0, 4H					; coordenada x do maior pesso
			CALL	algarismo				; escrever algarismo menor peso

			POP 	R3
			POP 	R2
			POP 	R1
			POP 	R0	
			RET



; ******************************************************************************
; * ROTINA:		algarismo
; * DESCRICAO: 	rotina para escrever numero R2 no pixelscreen a comecar nas 
; * coordenadas R0 e R1 que vao de 0 a 31
; * PARAMETROS:	R0, R1, R2
; * DESTROI:	-
; ******************************************************************************

algarismo:	PUSH 	R4
			PUSH	R3
			PUSH	R2
			PUSH 	R1
			PUSH	R0

			MOV		R4, NUMS
			SHL		R2, 8H
			ADD		R4, R2			; inicio da string do numero R2

			MOV 	R2, 0H

ciclo:		MOV		R3, R4
			ADD		R3, R2
			MOVB	R3, [R3]		; valor do pixel da tabela
			CMP		R3,	1
			JNZ 	naodesenha		; se for 0, nao desenha		

			CALL 	desenhar		; desenhar pixel (R0,R1)

naodesenha:	ADD 	R2, 1 			; passar para o pixel seguinte (i++)
			MOV 	R3, 15H 		
			CMP		R2, R3 			; se ja chegou ao ultimo, terminar funcao
			JZ		fim_num

verifica:	POP		R3				 
			PUSH	R3				
			SUB		R0, R3
			MOV 	R3, 3
			
			ADD		R0, 1
			MOD		R0,	R3
			

			JZ		continua
			POP		R3
			PUSH	R3
			ADD		R0, R3
			JMP		ciclo

continua:	POP		R0
			PUSH 	R0
			ADD 	R1, 1
			JMP		ciclo

fim_num:	POP	R0
			POP	R1
			POP R2
			POP R3
			POP	R4
			RET


; ******************************************************************************
; * ROTINA:		desenhar
; * DESCRICAO: 	rotina para desenhar pixel com coordenadas (R0,R1) : [0,31]
; * PARAMETROS:	R0, R1
; * DESTROI:	-
; ******************************************************************************

desenhar:	PUSH 	R2
			PUSH 	R1
			PUSH 	R0
			MOV 	R2, 8H 			; registo auxiliar

			SHL 	R1, 2			; cada linha tem 4 bytes (y*4)
			DIV		R0, R2			; descobrir indice do byte na linha (entre 0 e 3)
			ADD		R1, R0 			; R1 com a distancia do byte pretendido ao inicial (C000)
			MOV 	R0, PIXELSCREEN
			ADD		R1,	R0			; R1 com endereco do byte a escrever
			POP		R0 				; restaurar valor de x
			PUSH 	R0
			
			MOD		R0, R2 			; numero do bit a escrever no byte
			MOV 	R2, 80H 		; byte com ultimo bit a 1
			AND		R0, R0			; activar flags para R0

mascara:	JZ 		comparar
			SHR  	R2, 1 			; mascara: colocar 1 no bit certo
			SUB		R0, 1
			JMP		mascara		

comparar:	MOVB 	R0, [R1] 		; R1 com valor actual do byte no ecra
			XOR		R0, R2 			; colocar 1 no bit sem destroir os outros
			MOVB 	[R1], R0 		; mandar para o pixelscreen

			POP 	R0
			POP		R1
			POP		R2
			RET

; ******************************************************************************
; * ROTINA:		Interrupcao 1
; * DESCRICAO: 	Incrementar valor de R7
; * PARAMETROS:	R7 (valor a incrementar)
; * DESTROI:	-
; ******************************************************************************

rot0:		ADD		R7, 1H 			; incrementa valor
			RFE

; ******************************************************************************
; * ROTINA:		inicializa
; * DESCRICAO: 	inicializa o pixelscreen
; * PARAMETROS:	-
; * DESTROI:	-
; ******************************************************************************

inicializa:	PUSH	R0
			PUSH	R1
			PUSH	R2

			MOV 	R0,	0
			MOV 	R1,	BYTESCREEN
			MOV 	R2,	PIXELSCREEN

ciclolimp:	MOVB 	[R2], R0
			ADD		R2,	1H
			SUB		R1,	1H
			JNZ		ciclolimp

			POP 	R2
			POP 	R1
			POP 	R0

			MOV 	R7, ZERO			; inicializar segundos 00
			MOV 	R8, ZERO			; inicializar minutos 00
			MOV 	R9, ZERO			; inicializar horas 00

			MOV 	R0, 0BH				; coordenada x do primeiro ponto
			MOV 	R1, 7H				; coordenada y do primeiro ponto
			CALL	desenhar 			; desenhar primeiro ponto

			MOV 	R0, 0BH				; coordenada x do segundo ponto
			MOV 	R1, 9H 				; coordenada y do segundo ponto
			CALL	desenhar 			; desenhar segundo ponto

			MOV 	R0, 15H 			; coordenada x do terceiro ponto	
			MOV 	R1, 7H 				; coordenada y do terceiro ponto
			CALL	desenhar 			; desenhar terceiro ponto

			MOV 	R0, 15H 			; coordenada x do quarto ponto
			MOV 	R1, 9H 				; coordenada y do quarto ponto
			CALL	desenhar 			; desenhar quarto ponto

			MOV 	R2, R7 				; escrever 00:00:00 no pixelscreen
			MOV 	R0, 17H 			; x dos segundos
			MOV 	R3,	SEGUNDOS
			MOV 	[R3], R7
			CALL	escrevenum
			
			MOV 	R2, R8
			MOV 	R0, 0DH
			MOV 	R3,	MINUTOS      	; x dos minutos
			MOV 	[R3], R8
			CALL	escrevenum
			
			MOV 	R2, R9
			MOV 	R0, 3H
			MOV 	R3,	HORAS
			MOV 	[R3], R9
			CALL	escrevenum

			RET