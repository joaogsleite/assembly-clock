; ******************************************************************************
; * CONSTANTES
; ******************************************************************************
ZERO			EQU 	0H
UM 				EQU 	1H      		; primeira linha/coluna
ULTIMA			EQU 	8H      		; ultima linha/coluna
NENHUMA 		EQU 	11H				; nenhuma tecla foi premida



; ******************************************************************************
; * ENDERECOS MEMORIA
; ******************************************************************************
TECLADO			EQU		0B000H			; endereco teclado
MEMORIA			EQU 	6000H 			; primeiro endereco pa guardar teclas premidas



PLACE 0H
; ******************************************************************************
; * CORPO DO PROGRAMA
; * escreve teclas premidas a partir do endereco 6000H na memoria
; ******************************************************************************

				MOV 	R6, MEMORIA
				DI0
				DI


varrinicio:		MOV		R1, UM			; testar a linha 1 
				MOV		R4, TECLADO		; endereço do teclado
				MOV 	R10, ULTIMA 	; valor da ultima linha

verlinha:		MOVB	[R4], R1		; mandar linha para o teclado
				MOVB	R3, [R4]		; ler coluna do teclado (tecla premida)
				MOV 	R7, 0FH			;
				AND	 	R3, R7
				AND 	R3,R3
				JNZ		teclapremida	; alguma tecla foi premida na linha 'R1'
				CMP		R1, R10
				JZ 		fimteclado		; se ja verificou as linhas todas
				SHL		R1, UM			; verificar linha seguinte
				JMP 	verlinha

fimteclado:		MOV 	R5, NENHUMA 	; nenhuma tecla foi premida
				JMP		fimvarrimento


teclapremida:  	MOV 	R9, 0H

inicio1:		SHR 	R3, 1
				ADD 	R9, 1H
				AND		R3, R3
				JNZ 	inicio1
				SUB 	R9,1H 			; numero da tecla da primeira linha

				MOV 	R8, 0H

inicio2:		SHR 	R1, 1
				ADD 	R8, 1H
				AND		R1, R1
				JNZ 	inicio2
				SUB 	R8, 1H 			; numero da linha da tecla premida

				SHL 	R8, 2 			; cada linha tem 4 teclas
				ADD		R9, R8 			; numero da tecla premida
				MOV 	R5,R9

fimvarrimento: 	MOV 	[R6],R5
				ADD 	R6, 2H	
				JMP  	varrinicio







