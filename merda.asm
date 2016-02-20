
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
SEISCENTOS		EQU 	258H 			; 1 minuto
MILDUZENTOS 	EQU 	4B0H		
DIA 			EQU		18H 			; 24 horas			
BYTESCREEN		EQU		80H 			; numero bytes do pixelscreen
BYTESRELOGIO 	EQU 	1CH 			; numero bytes do relogio
ULTIMA			EQU 	8H      		; ultima linha/coluna
DEZOITO 		EQU		14H 			; linha onde comecar a apagar relogio
NENHUMA 		EQU 	69H				; nenhuma tecla foi premida



; ******************************************************************************
; * ENDERECOS MEMORIA
; ******************************************************************************

TECLADO			EQU		0B000H			; endereco teclado
STACK			EQU 	5000H 			; endereco do stack point

PIXELSCREEN 	EQU 	0C000H			; endereco do pixelscreen
NUMS 			EQU		1000H

SCREENS 		EQU 	2020H
SCREENM 		EQU 	2022H
SCREENH 		EQU 	2024H

RSEGUNDOS 		EQU		2010H			; endereco guardar segundos
RMINUTOS 		EQU		2012H			; endereco guardar minutos
RHORAS 			EQU		2014H			; endereco guardar horas
RELOGE			EQU 	2016H

CSEGUNDOS 		EQU		2000H			; endereco guardar segundos
CMINUTOS 		EQU		2002H			; endereco guardar minutos
CHORAS 			EQU		2004H			; endereco guardar horas

TSEGUNDOS 		EQU		2050H			; endereco guardar segundos
TMINUTOS 		EQU		2052H			; endereco guardar minutos
THORAS 			EQU		2054H			; endereco guardar horas

SEGUNDOS 		EQU		2000H			; endereco guardar segundos
MINUTOS 		EQU		2002H			; endereco guardar minutos
HORAS 			EQU		2004H			; endereco guardar horas	

ALARMPROG 		EQU 	2108H 			; endereco guardar num do alarme a ser programado
ALARMPRE 		EQU 	2106H 			; endereco guardar num do alarme a ser programado
ALARMON 		EQU 	1FFEH 			; endereco guardar alarmes activos (bit 1 a 3)

ALARM1M 		EQU 	2112H 			; endereco para tempoM do alarme1
ALARM1H 		EQU 	2114H 			; endereco para tempoH do alarme1

ALARM2M 		EQU 	2122H 			; endereco para tempoM do alarme2
ALARM2H 		EQU 	2124H 			; endereco para tempoH do alarme2

ALARM3M			EQU 	2132H 			; endereco para tempoM do alarme3
ALARM3H			EQU  	2134H 			; endereco para tempoH do alarme4

TEMPORIZE 		EQU 	2046H 			; endereco para tempo do temporizador
TEMPORIZS 		EQU 	2040H 			; endereco para tempo do temporizador
TEMPORIZM 		EQU 	2042H 			; endereco para tempo do temporizador
TEMPORIZH 		EQU 	2044H 			; endereco para tempo do temporizador


PTEMPORIZ 		EQU 	2048H


ACERTOEND 		EQU 	2060H 			; endereco guardar se ha acerto de relogio




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



PLACE		3900H
tab:		WORD	rot0 					; Tabela de vectores de interrupção
			WORD	rot1					; Tabela de vectores de interrupção




PLACE 0
; ******************************************************************************
; * CORPO DO PROGRAMA
; *
; * 
; * MostrarRelogio:	R0(8)=1 		MostrarCronom: R0(8)=0
; * MostrarCronom: 	R0(7)=0 		MostrarTempor: R0(7)=1 	
; * 
; * ActiveCronom: 	R0(6)=1 		PauseCronom: R0(5)=1 
; * ActiveTempor: 	R0(4)=1 		PauseTempor: R0(3)=1
; * 
; * Programacoes: 	R0(1)=1
; ******************************************************************************

				MOV 	SP, STACK 			; inicializa SP
				MOV		BTE, tab			; inicializa BTE
				CALL	inicializacao		; inicializar o programa
				EI0
				EI


inicio: 		MOV 	R2, R5 				; ultima tecla premida
				CALL	varrimento 			; verificar tecla premida
				MOV 	R1, NENHUMA 		; nenhuma tecla premida
				CMP 	R5, R1  			; verificar se nenhuma tecla foi premida
				JZ 		clock 				; nao actualiza estados se tecla=NENHUMA
				CMP 	R5, R2  			; verificar tecla premida
				JZ 		clock 				; nao actualiza estados se tecla igual anterior


				MOV 	R1, 1H 				; verificar se ha programacoes a decorrer 
				AND 	R1, R0 				; activar as flags
				JNZ 	prgrmc 				; ha programacoes, nao actualizar estados
				CALL	estadoupdate  		; actualizar estado conforme tecla
				JMP 	clock 				; comecar o relogio
prgrmc:			CALL 	program 			; programar alarmes/tempor/acerto


clock:			CALL	cronometro
				;CALL	alarmcheck
				CALL	relogio

				CALL 	timescreen

fim:			JMP 	inicio




; ******************************************************************************
; * ROTINA:		timescreen
; * DESCRICAO: 	rotina para gerir programacoes (acerto, temporizador e alarmes)
; * PARAMETROS:	R5 (tecla premida)
; * RETORNA:	R0 (estado do programa)
; * NOTAS: 		-
; ******************************************************************************

timescreen: 	PUSH 	R0
				PUSH 	R1
				PUSH 	R2
				PUSH 	R3
				PUSH 	R4
				PUSH 	R5
				PUSH 	R6

				MOV 	R4, 14H
				MOV 	R3, R0 				; verificar se estado = cron ou relog
				SHR 	R3, 7
				MOV 	R1, 10H 			; enderecos de memorio de relog ou cron
				MOV 	R2, R3
				MUL 	R3, R1 				; endercos de relogio ou cronometro
				MOV 	R1, 0AH
				MUL		R2, R1
				SUB 	R4, R2 				; segundos de relogio ou segundos de cronm

				MOV 	R6, TEMPORIZE 		; endereco do alarme a ser programado
				MOV 	R6, [R6] 			; verificar se ha alarme a ser programado	
				AND 	R6, R6
				JZ 		tmscrnrel1
				MOV 	R3, 40H
				MOV 	R4, 1H
				JMP 	tmscrnrel2

tmscrnrel1:		MOV 	R6, RELOGE	 		; endereco do alarme a ser programado
				MOV 	R6, [R6] 			; verificar se ha alarme a ser programado	
				AND 	R6, R6
				JZ 		tmscrnrel2
				MOV 	R3, 10H
				MOV 	R4, 10H

tmscrnrel2:		MOV 	R1, SCREENS 		; endereco dos ultimos segundos escritos
				MOV 	R2, [R1] 			; ultimo valor escrito dos segundos
				MOV 	R1, SEGUNDOS 		; endereco dos segundos a escrever
				ADD 	R1, R3
				MOV 	R5, [R1] 			; ultimo valor escrito dos segundos
				DIV 	R5, R4 				; converter decimas segundo para segundo
				AND 	R6, R6
				JNZ 	ncptmscrn1
				CMP 	R5, R2 				; verificar se ha valor novo
				JZ 		fimtimescreen
ncptmscrn1:		MOV 	R0, 17H 			; posicao dos segundos
				CALL 	escrevenum 			; apagar segundos
				MOV 	R2, R5 				; novo valor a escrever
				CALL 	escrevenum 			; escrever segundos
				MOV 	R1, SCREENS 		; endereco dos ultimos segundos escritos
				MOV 	[R1],R2	 			; ultimo valor escrito dos segundos

				MOV 	R1, SCREENM 		; endereco dos ultimos minutos escritos
				MOV 	R2, [R1] 			; ultimo valor escrito dos minutos
				MOV 	R1, MINUTOS 		; endereco dos minutos a escrever
				ADD 	R1, R3
				MOV 	R5, [R1] 			; ultimo valor escrito dos minutos
				AND 	R6, R6
				JNZ 	ncptmscrn2
				CMP 	R5, R2 				; verificar se ha valor novo
				JZ 		fimtimescreen
ncptmscrn2:		MOV 	R0, 0DH 			; posicao dos minutos
				CALL 	escrevenum 			; apagar minutos
				MOV 	R2, R5 				; novo valor a escrever
				CALL 	escrevenum 			; escrever minutos
				MOV 	R1, SCREENM 		; endereco dos ultimos minutos escritos
				MOV 	[R1],R2	 			; ultimo valor escrito dos minutos

				MOV 	R1, SCREENH 		; endereco dos ultimos horas escritos
				MOV 	R2, [R1] 			; ultimo valor escrito dos horas
				MOV 	R1, HORAS 			; endereco dos horas a escrever
				ADD 	R1, R3
				MOV 	R5, [R1] 			; ultimo valor escrito dos horas
				CMP 	R5, R2 				; verificar se ha valor novo
				JZ 		fimtimescreen
				MOV 	R0, 3H 				; posicao dos horas
				CALL 	escrevenum 			; apagar horas
				MOV 	R2, R5 				; novo valor a escrever
				CALL 	escrevenum 			; escrever horas
				MOV 	R1, SCREENH 		; endereco dos ultimos horas escritos
				MOV 	[R1],R2	 			; ultimo valor escrito dos horas

fimtimescreen:	POP 	R6
				POP 	R5
				POP 	R4
				POP 	R3
				POP 	R2
				POP 	R1
				POP 	R0
				RET




; ******************************************************************************
; * ROTINA:		inicializacao
; * DESCRICAO: 	rotina para inicializar o programa
; * PARAMETROS:	-
; * DESTROI:	-
; * NOTAS: 		-
; ******************************************************************************

inicializacao:	CALL	limpar				; limpar pixelscreen

				MOV 	R10, 0H
 
 				MOV 	R7, 0H				; inicializar segundos 00
				MOV 	R8, 0H				; inicializar minutos 00
				MOV 	R9, 0H				; inicializar horas 00
				CALL 	iniciarel 			; iniciar relogio

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

				MOV 	R0, 80H 			; R0=estado relogio 1000 0000
				MOV 	R1, 0H
				MOV 	R2, 0H
				MOV 	R3, 0H

				MOV 	R5, NENHUMA 		; nenhuma tecla premida

				RET



; ******************************************************************************
; * ROTINA:		iniciarel
; * DESCRICAO: 	rotina para inicializar o relogio
; * PARAMETROS:	R7, R8, R9
; * DESTROI:	-
; * NOTAS: 		-
; ******************************************************************************

iniciarel: 		PUSH 	R9
				PUSH 	R8
				PUSH 	R7
				PUSH 	R2
				PUSH 	R1
				PUSH 	R0

				MOV 	R1, RSEGUNDOS 		; endereco segundos do relogio
				MOV 	[R1], R7
				MOV 	R1, RMINUTOS 		; endereco minutos do relogio
				MOV 	[R1], R8
				MOV 	R1, RHORAS 			; endereco horas do relogio
				MOV 	[R1], R9 

				MOV 	R1, SCREENS 		; endereco segundos do screen
				MOV 	[R1], R7
				MOV 	R1, SCREENM 		; endereco minutos do screen
				MOV 	[R1], R8
				MOV 	R1, SCREENH 		; endereco horas do screen
				MOV 	[R1], R9

				MOV 	R2, R7 				; escrever 00:00:00 no pixelscreen
				MOV 	R0, 17H 			
				CALL	escrevenum
				
				MOV 	R2, R8
				MOV 	R0, 0DH
				CALL	escrevenum
				
				MOV 	R2, R9
				MOV 	R0, 3H
				CALL	escrevenum

				POP 	R0
				POP 	R1
				POP 	R2
				POP 	R7
				POP 	R8
				POP 	R9

				RET



; ******************************************************************************
; * ROTINA:		program
; * DESCRICAO: 	rotina para gerir programacoes (acerto, temporizador e alarmes)
; * PARAMETROS:	R5 (tecla premida)
; * RETORNA:	R0 (estado do programa)
; * NOTAS: 		-
; ******************************************************************************

program: 		PUSH 	R1
				PUSH	R2
				PUSH 	R3
				PUSH 	R5


				MOV 	R3, ALARMPROG 		; endereco do alarme a ser programado
				MOV 	R1, [R3] 			; verificar se ha alarme a ser programado	
				AND 	R1, R1 				; activar as flags
				JZ 		cont1 				; nao ha alarme a ser programado
				MOV 	R2, 0AH 			; constante=alarme desconhecido a ser programa
				CMP 	R1, R2 				; verificar qual o alarme a ser programado
				JNZ 	contalm 			; saltar se ja se sabe alarme a ser programado
				MOV 	[R3], R5 			; alarme 1/2/3 a ser programa
				MOV 	R3, ALARMPRE
				MOV 	R2, 10H 			; constante multiplicacao
				MUL 	R5, R2 				
				ADD 	R3, R5 				; encontrar endereco do alarme
				MOV 	R2, 0H 				; 00
				MOV 	[R3-2], R2 			; colocar alarme HH a 00
				MOV 	[R3-4], R2 			; colocar alarme MM a 00
				JMP 	fimprogram
contalm:		MOV 	R3, ALARMPRE 		; endereco do alarme a ser programado
				MOV 	R2, 10H 			; endereco dos alarmes de 10H em 10H
				MUL 	R1, R2 				; escolher alarme a programar
				ADD 	R3, R1 				; adicionar ao endereco dos alarmes
				CALL 	acertos 			; comecar a programar cronometro/temporizador
				JMP 	fimprogram

cont1:			MOV 	R3, TEMPORIZE 		; endereco temporizador a ser programado
				MOV 	R1, [R3] 			; verificar se temporizador esta ser programado
				AND 	R1, R1 				; activar flags
				JZ 		cont2 				; temporizador nao esta a ser programado
				CALL 	acertos 			; comecar a programar cronometro/temporizador
				JMP		fimprogram

cont2:			MOV 	R3, RELOGE 			; endereco acerto relogio a ser programado
				MOV 	R1, [R3] 			; verificar se acerto esta ser programado
				AND 	R1, R1 				; activar flags
				JZ 		fimprogram			; relogio nao esta a ser programado
				CALL 	acertos				; comecar a programar relogio
				JMP		fimprogram 			

fimprogram:		POP 	R5
				POP 	R3
				POP 	R2
				POP 	R1
				RET 



; ******************************************************************************
; * ROTINA:		acertos
; * DESCRICAO: 	rotina para receber valores teclado e colocar na memoria
; * PARAMETROS:	R3 (endereco pa guardar algarismo), R5 (tecla premida)
; * RETORNA:	actualiza [R4] e R0 (estado)
; * NOTAS: 		-
; ******************************************************************************

acertos:		PUSH 	R1
				PUSH 	R2
				PUSH 	R4
				PUSH 	R6

				MOV 	R2, 2H
				MOV 	R1, [R3]
		
contprogtem:	MOV 	R4, 0AH		    	; factor da multiplicacao		
				SUB 	R1, 1H
				PUSH 	R1			
				MOV 	[R3], R1 			; guardar algarismo a ser programado					
				DIV 	R1, R2 				; endereco de horas ou minutos ou segundos
				SHL 	R1, 1H 				; R1=4 -> horas, R1=2 -> minutos, R1=0 segundos

				SUB 	R3, 6H 		 		; endereco do temporizador
				ADD  	R3, R1 				; endereco para horas ou minutos ou segundos
				MOV 	R6, [R3] 			; sacar maior peso ou 0 em memoria
				POP 	R1
				PUSH 	R1
				PUSH 	R5 					; nao destruir tecla varrimento
				MOD 	R1, R2 				; verificar se esta a actualizar maior peso ou menor
				JZ 		tempmenorpeso	
				MUL 	R5, R4 				; se for maior peso, multiplicar por 10
tempmenorpeso:	ADD 	R6, R5 				; se for menor peso, somar ao de maior peso
				MOV 	[R3], R6 
				MOV 	R4, RSEGUNDOS
				CMP 	R3, R4 				; verificar se esta a acertar relogio
				JNZ 	acertohh
				MOV 	R4, 0AH 			; constante para multiplicar
				MUL 	R6, R4 				; passar segundos para secimas segundos
				MOV 	R7, R6 				; colocar segundos no R7 do relogio
				MOV 	[R3], R6
acertohh:		POP 	R5 					; recuperar valor de R5
				POP 	R1
				MOV 	R2, ALARMPROG		; endereco programar alarme
				CMP 	R3, R2 				; verificar se esta a programar alarme
				JNN		alarmscerto 		; saltar para verificao de alarmes
				AND 	R1, R1 				; activar flags
				JZ 		certoend
				JMP 	fimacertos 		
alarmscerto:	MOV 	R2, 2H 				; alarmes nao precisam de programacao segundos
				CMP 	R1, R2 				; verificar se ja chegou aos segundos
				JNZ 	fimacertos	 		; se ja esta nos segundos, continuar		
certoend:		MOV 	R4, 1H 				; se ja acabou programacao temporizador
				XOR 	R0, R4 				; desativar programacoes
				MOV 	R4, 0H
				MOV 	R1, ALARMPROG
				MOV 	[R1], R4
				EI0
				EI

fimacertos:		POP 	R6
				POP 	R4
				POP 	R2
				POP 	R1
				RET		



; ******************************************************************************
; * ROTINA:		estadoupdate
; * DESCRICAO: 	rotina para actualizar estado conforme tecla premida
; * PARAMETROS:	R5 (tecla premida)
; * RETORNA:	R0 (estado do programa)
; * NOTAS: 		-
; ******************************************************************************

estadoupdate:	PUSH 	R1
				PUSH 	R2
				PUSH 	R3
				PUSH 	R5

verifica0:		MOV 	R1, 0H 				; tecla 0 no R1
				CMP 	R5, R1 				; verificar se tecla 0 foi premida
				JNZ		verificaF			; tecla 0 nao premida 

				PUSH 	R0
				MOV 	R0, 1FH				; coordenada x do primeiro ponto
				MOV 	R1, 1FH				; coordenada y do primeiro ponto
				CALL	desenhar 			; desenhar primeiro ponto
				POP 	R0

				MOV 	R1, 80H 			; colocar 1 no bit 8
				XOR 	R0, R1				; Toogle no R0(8)
				MOV 	R1, R0 				; nao destruir R0
				SHR 	R1, 7 				; colocar bit 8 em 1
				AND 	R1, R1 				; activar flags
				JNZ		fimestadupdte 		; se vem de cronometro para relogio
				MOV 	R1, R0 				; nao destruir R0
				SHR 	R1, 5 				; colocar bit 6 em 1
				AND 	R1, R1 				; activar flags
				JNZ 	fimestadupdte
				MOV 	R1, 40H 			; se vem de relogio para cronometro
				OR 		R0, R1 				; activa cronometro/temporizador
				EI1
				EI
				JMP 	fimestadupdte		; ir para fim

verificaF:		MOV 	R1, 0FH 			; tecla F no R1
				CMP 	R5, R1 				; verificar se tecla F foi premida
				JNZ		verificaA			; tecla F nao premida 
				MOV 	R1, RELOGE 			; endereco de programar relogio
				MOV 	R2, 6H 				; comecar programar relogio
				MOV		[R1], R2 			; estado: a programar relogio
				MOV 	R2, 1H
				XOR 	R0, R2 				; activar modo programacao
				MOV 	R2, 0H
				DI0							; desativar relogio
				DI
				MOV 	R1, RSEGUNDOS
				MOV 	[R1], R2
				MOV 	R1, RMINUTOS
				MOV 	[R1], R2
				MOV 	R1, RHORAS
				MOV 	[R1], R2
				MOV 	R7, R2
				JMP 	fimestadupdte		; ir para fim

verificaA:		MOV 	R1, 0AH 			; tecla A no R1
				CMP 	R5, R1 				; verificar se tecla A foi premida
				JNZ		verificaC			; tecla A nao premida 
				MOV 	R1, ALARMPROG 		; endereco de programar alarme
				MOV		[R1], R5			; estado: a programar alarme
				
				MOV 	R1, ALARMPRE
				MOV 	R2, 6H
				MOV 	R3, 10H
				ADD		R1, R3
				MOV 	[R1], R2
				ADD		R1, R3
				MOV 	[R1], R2
				ADD		R1, R3
				MOV 	[R1], R2
				
				MOV 	R2, 1H
				XOR 	R0, R2
				JMP 	fimestadupdte		; ir para fim

verificaC:		MOV 	R1, 0CH 			; tecla C no R1
				CMP 	R5, R1 				; verificar se tecla C foi premida
				JNZ		verifica123			; tecla C nao premida 
				MOV 	R1, TEMPORIZE 		; endereco de programar alarme
				MOV 	R2, 6H 			; comecar programar temporizador
				MOV		[R1], R2 			; estado: a programar alarme
				MOV 	R2, 1H
				XOR 	R0, R2 				; activar modo programacao
				MOV 	R2, 0H
				MOV 	R1, TEMPORIZH
				MOV 	[R1], R2
				MOV 	R1, TEMPORIZM
				MOV 	[R1], R2
				MOV 	R1, TEMPORIZS
				MOV 	[R1], R2
				JMP 	fimestadupdte		; ir para fim

verifica123:	MOV 	R2, ALARMON 		; endereco dos alarmes ligados
				MOV 	R1, 4H 				; tecla 4 no R1
				CMP 	R5, R1 				; verificar se tecla 3/2/1 foi premida
				JN		verifica4			; tecla 1 nao foi premida 		
				MOV 	R1, 1H
passa0:			SUB 	R5, 1
				JZ 		passa1
				SHR 	R1, 1
				JMP 	passa0
passa1:			MOV 	R5, [R2] 			; buscar alarmes ligados
				XOR 	R5, R1				; Toogle no ALARMON(1)
				MOV 	[R2], R5 			; voltar a guardar em memoria
				JMP 	fimestadupdte		; ir para fim

verifica4:		MOV 	R1, 4H 				; tecla 4 no R2
				CMP 	R5, R1 				; verificar se tecla 3 foi premida
				JNZ		fimestadupdte		; tecla 3 nao foi premida 
				MOV 	R1, 40H				; colocar 1 no bit 4 (temporizador)
				XOR 	R0, R1				; Toogle no R0(7)
				JMP 	fimestadupdte		; ir para fim

fimestadupdte:	POP 	R5
				POP 	R3
				POP 	R2
				POP 	R1
				RET



; ******************************************************************************
; * ROTINA:		relogio
; * DESCRICAO: 	rotina para escrever relogio no pixelscreen  R9:R8:R7
; * PARAMETROS:	R9, R8, R7
; * DESTROI:	-
; * NOTAS: 		valores x para (h,m,s) sao: (3, D, 17)
; ******************************************************************************

relogio:		PUSH 	R1
				PUSH 	R2
				PUSH 	R8
				PUSH	R9


				MOV 	R2, SEISCENTOS 		; 600ds
				CMP 	R7,	R2				; se chegou aos 60 segundos
				JN		rsegundos

				MOV 	R7, ZERO			; voltar a por segundos a 00
				MOV 	R1, RMINUTOS
				MOV 	R8, [R1]
				ADD		R8, 1H 				; somar 1 minuto
				MOV 	R2, SESSENTA 		; 60m
				CMP 	R8, R2				; verificar se chegou a 60minutos
				JNZ		rminutos

				MOV 	R8, ZERO			; voltar a por minutos a zero
				MOV 	R1, RHORAS
				MOV 	R9, [R1]
				ADD		R9, 1H 				; somar 1 hora
				MOV 	R2,	DIA				; 24 horas
				CMP 	R9, R2				; verificar se chegou a 24 horas
				JNZ		rhoras
				MOV 	R9, ZERO			; voltar a por minutos a zero

rhoras:			MOV 	R1, RHORAS
				MOV 	[R1], R9
rminutos:		MOV 	R1, RMINUTOS
				MOV 	[R1], R8	
rsegundos:		MOV 	R1, RSEGUNDOS
				MOV 	[R1], R7

fimrelogio:		POP 	R9
				POP 	R8
				POP 	R2
				POP 	R1
				RET



; ******************************************************************************
; * ROTINA:		cronometro
; * DESCRICAO: 	rotina para actualizar cronometro
; * PARAMETROS:	-
; * DESTROI:	-
; ******************************************************************************

cronometro:		PUSH 	R1
				PUSH 	R2
				PUSH 	R8
				PUSH	R9


				MOV 	R2, MILDUZENTOS 	; 1200*50ms
				CMP 	R10,R2				; se chegou aos 60 segundos
				JN		csegundos

				MOV 	R10, ZERO			; voltar a por segundos a 00
				MOV 	R1, CMINUTOS
				MOV 	R8, [R1]
				ADD		R8, 1H 				; somar 1 minuto
				MOV 	R2, SESSENTA 		; 60m
				CMP 	R8, R2				; verificar se chegou a 60minutos
				JNZ		cminutos

				MOV 	R8, ZERO			; voltar a por minutos a zero
				MOV 	R1, CHORAS
				MOV 	R9, [R1]
				ADD		R9, 1H 				; somar 1 hora
				MOV 	R2,	DIA				; 24 horas
				CMP 	R9, R2				; verificar se chegou a 24 horas
				JNZ		choras
				MOV 	R9, ZERO			; voltar a por minutos a zero

choras:			MOV 	R1, CHORAS
				MOV 	[R1], R9
cminutos:		MOV 	R1, CMINUTOS
				MOV 	[R1], R8	
csegundos:		MOV 	R1, CSEGUNDOS
				MOV 	[R1], R10

fimcronometro:	POP 	R9
				POP 	R8
				POP 	R2
				POP 	R1
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

			MOV 	R2, 8 			; registo auxiliar

			SHL 	R1, 2			; cada linha tem 4 bytes (y*4)
			DIV		R0, R2			; descobrir indice do byte na linha
			ADD		R1, R0
			MOV 	R0, PIXELSCREEN
			ADD		R1,	R0			; R1 com endereco do byte a escrever
			POP		R0 				; restaurar valor de x
			PUSH 	R0
			
			MOD		R0, R2 			; numero do bit a escrever no byte
			MOV 	R2, 80H 		; byte com ultimo bit a 1
			AND		R0,R0			; activar flags para R0
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
; * ROTINA:		Interrupcao 0
; * DESCRICAO: 	Incrementar valor de R7
; * PARAMETROS:	R7 (valor a incrementar)
; * DESTROI:	-
; ******************************************************************************

rot0:		ADD		R7, 1H 			; incrementa valor
			RFE


; ******************************************************************************
; * ROTINA:		Interrupcao 1
; * DESCRICAO: 	Incrementar valor de R10
; * PARAMETROS:	R10 (valor a incrementar)
; * DESTROI:	-
; ******************************************************************************

rot1:		ADD		R10, 1H 		; incrementa valor
			RFE




; ******************************************************************************
; * ROTINA:		limpar
; * DESCRICAO: 	limpar o pixelscreen todo
; * PARAMETROS:	-
; * DESTROI:	-
; ******************************************************************************

limpar:		PUSH	R1
			PUSH	R2
			PUSH	R3

			MOV 	R3,	0
			MOV 	R1,	BYTESCREEN
			MOV 	R2,	PIXELSCREEN

ciclolimp:	MOVB 	[R2], R3
			ADD		R2,	1
			SUB		R1,	1
			JNZ		ciclolimp

			POP 	R3
			POP 	R2
			POP 	R1
			RET



; ******************************************************************************
; * ROTINA:		varimento
; * DESCRICAO: 	rotina para varrer teclado e retornar tecla premida ou retornar
; * a constante 'NENHUMA' se nenhuma tecla foi premida.
; * PARAMETROS:	-
; * DESTROI:	R5
; * RETORNA:	R5, valor da tecla ou valor nenhuma tecla
; ******************************************************************************

varrimento:		PUSH 	R1
				PUSH 	R2
				PUSH 	R3
				PUSH 	R4
				PUSH    R6
  

				MOV		R1, UM			; testar a linha 1 
				MOV		R4, TECLADO		; endereço do teclado
				MOV 	R2, ULTIMA 		; valor da ultima linha
				MOV 	R6, 0FH 		; mascara primeiros 4 bits

verlinha:		MOVB	[R4], R1		; mandar linha para o teclado
				MOVB	R3, [R4]		; ler coluna do teclado (tecla premida)
				AND	 	R3, R6			; mascara do rocha
				AND 	R3,R3 			; acctivar as flags
				JNZ		teclapremida	; alguma tecla foi premida na linha 'R1'
				CMP		R1, R2 			; verificar se esta na ultima linha
				JZ 		fimteclado		; se ja verificou as linhas todas
				SHL		R1, UM 			; verificar linha seguinte
				JMP 	verlinha

fimteclado:		MOV 	R5, NENHUMA 	; nenhuma tecla foi premida
				JMP		fimvarrimento


teclapremida:  	MOV 	R5, 0H

teclapremida1:	SHR 	R3, 1 			; coluna SHR 1
				ADD 	R5, 1H 			; foi feito 1 SHR
				AND		R3, R3 			; activar as flags
				JNZ 	teclapremida1 	; se ja chegou a 0, avancar
				SUB 	R5, 1H 			; numero da tecla da primeira linha

				MOV 	R6, 0H

teclapremida2:	SHR 	R1, 1 			; SHR do numero da linha
				ADD 	R6, 1H 			; foi feito 1 SHR
				AND		R1, R1			; activar as flags
				JNZ 	teclapremida2 	; se ja chegou a 0, avancar
				SUB 	R6, 1H 			; numero da linha da tecla premida

				SHL 	R6, 2 			; cada linha tem 4 teclas
				ADD		R5, R6 			; numero da tecla premida

fimvarrimento:	POP 	R6
				POP 	R4
				POP 	R3
				POP 	R2
				POP 	R1
				RET


