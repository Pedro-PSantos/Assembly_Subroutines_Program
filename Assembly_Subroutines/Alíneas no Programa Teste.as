; zona de colocação de dados entrada/saida
ORIG 8000h
testeN STR 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
testeM STR 0,1,2,1,2,3,4,0,7,5, 2, 3, 4, 1, 4, 5
resultadosA TAB 16
resultadosB TAB 16
resultadosC TAB 64
resultadosD TAB 64
testes EQU 16
testesC EQU 64
testesD EQU 1024
; zona do código
ORIG 0000h
; inicialização do stack
Inicio: MOV R1, fd1fh
MOV SP, R1



; TESTE alinea A
MOV R3, testes
CicloA: DEC R3
BR.N FimA
MOV R1, M[R3+testeN] ; R1 - enviado valor de N
MOV R2, M[R3+testeM] ; R2 - enviado valor de M
PUSH R3 ; manter a variável iteradora
CALL TesteNM ; chamada ao procedimento solicitado
POP R3
MOV M[R3+resultadosA],R1 ; guardar resultado retornado
BR CicloA
FimA: Nop



; TESTE alinea B
MOV R2, testes
CicloTesteN: DEC R2
BR.N FimB
MOV R1, M[R2+testeN] ; R1 - enviado valor de N
PUSH R2 ; manter a variável iteradora
CALL TesteN ; chamada ao procedimento solicitado
POP R2
MOV M[R2+resultadosB],R1 ; guardar resultado retornado
BR CicloTesteN
FimB: Nop


; TESTE alinea C
MOV R1, testesC
MOV R2, resultadosC
CALL TesteVetorN
FimC: Nop


; TESTE alinea D
MOV R1, testesD
MOV R2, resultadosD
CALL TesteVetorB
FimD: JMP Fim


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; função TesteNM solicitada na alínea A
; Entrada: R1 - valor de N; R2 - valor de M
; Saída: R1 - resultado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TesteNM:        MOV     R4, R1          ;Copiar R1(n) para R4, uma vez que as operações Mul. e Div. são destructivas
                
CalculosA:      DIV     R4, R2          ;Em R2 obtemos o resto da divisão(n%m), o valor em r1 não importa.
                MOV     R3, R2          ;Multiplicação é também uma operação destrutiva,
                MOV     R4, R2          ;logo Copiamos R2(n%m).
                MUL     R4, R3          ;(n%m)^2 fica em R3, O valor de R4 não interessa
                MOV     R4, 2           ;Na multiplicação precisamos de 2 registos, logo guardar 2 em R1 para
                MUL     R4, R2          ;obter 2.(n%m) em R2, o valor de R1 não interessa
                ADD     R3, R2          ;R3=(n%m)^2+2.(n%m)=X
                INC     R2              ;R2=2.(n%m)+1=W
                
TestarPertenceA:CMP     R1, R3          ;N=X??
                BR.Z    PertenceA       ;Se não,
                CMP     R1, R2          ;N=W?
                BR.Z    PertenceA       ;Se não,
                MOV     R1, R0          ;R1=0
                BR      RetornarA       ;E Retornar
PertenceA:      MOV     R1, 1           ;Se sim, R1=1 

RetornarA:      RET                     ;E Retornar
        



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; função TesteN solicitada na alínea B
; Entrada: R1 - valor de N
; Saída: R1 - resultado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TesteN:         MOV     R2, R1          ;Copiar N para R2, uma vez que R1 ira mostrar se N pertence a S

TestarMenor3B:  CMP     R2, 2           ;N< ou = 2?
                BR.P    Nmaiorque2B     ;Se não, verificar se N pertence a S com TesteNM,        
                MOV     R1, 1           ;caso contrário, N Pertence a S (R1=1)
                JMP     RetornarB       ;Return

Nmaiorque2B:    PUSH    R2              ;Guardar o valor de N no stack
                MOV     R1, R0          ;Iniciar M=0
                
TestarNB:       CALL    TesteN          ;Chamada Recursiva à Sub-Rotina

                CMP     R1, R0          ;N Pertence a S?(R1=1?)
                BR.Z    NaoPertenceSB   ;Se não, Verificar se próximo M pertence a S
                POP     R1              ;Se sim, recuperar valor de N, para utilizar em TesteNM
                PUSH    R1              ;Voltar a guardar no stack R1 e R2
                PUSH    R2              ;Para recupera-los depois da Sub-Rotina TesteNM
                CALL    TesteNM
                CMP     R1, R0          ;N Pertence a S?(R1=1?)
                POP     R2              ;(Recupera valor de M)
                BR.Z    NaoPertenceSB   ;Se Sim, valor de M não é relevante e recupera
                POP     R2              ;Valor de N em R2, pois R1 tem info. se N pertence a S
                JMP     RetornarB

                                
NaoPertenceSB:  POP     R1              ;Caso contrário, Recuperar N
                INC     R2              ;Próximo valor de M, M+1
                CMP     R2, R1          ;M+1=N<=>M=N-1?
                BR.Z    NaoPertenceB    ;Se sim, retornar
                PUSH    R1              ;Se não, Guarda Valor de N
                MOV     R1, R2          ;Copiar M para N
                JMP     TestarNB        ;E verifica se M pertence a S
                
NaoPertenceB:   MOV     R1, R0          ;Caso contrário, R1=0 e               

RetornarB:      RET                     ;Retornar


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; função TesteVetorN solicitada na alínea C
; Entrada: R1 - valor máximo de N; R2 - vetor
; Saída: vetor em R2 corretamente preenchido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TesteVetorN:    MOV     R6, R1          ;Copia R1(NMAX) para R6 e Copia R2(Vetor) para R7, 
                MOV     R7, R2          ;uma vez que R1 e R2 são necessários alterar durante a sub-rotina
                MOV     R3, R2          ;R3=Posição do Vetor
                MOV     R5, R0          ;Variável N
   
                
;Testar < ou Igual a 2

TestarMenor3C:  CMP     R5, 2           ;N Menor ou = a 2?
                BR.P    Maior2C         ;Se não, verificar se N pertence a S com TesteNM                                 
                MOV     R1, 1           ;Caso contrário, R1=1               
                MOV     M[R3], R1       ;Guarda no vetor o valor
                INC     R3              ;INC Posição no Vetor
                CMP     R5, R6          ;N=NMAX?                
                JMP.Z   RetornarC       ;Se sim, Retornar
                INC     R5              ;Se Não, Incrementa N
                BR      TestarMenor3C     
                
Maior2C:        MOV     R2, R0          ;Inicia M=0                
                MOV     R4, R7          ;Copiar Início do Vetor para Verificar o valor presente em cada elemento
TestarMSC:      CMP     M[R4], R0       ;M Pertence a S? (R1=1 ou =0?)
                BR.NZ   TestarNMC       ;Se sim, TestarNM
MnaoPertenceSC: INC     R2              ;Incrementa M e Posição AUX. do Vetor
                INC     R4              ;e verifica se
                CMP     R2, R5          ;M<N?
                BR.NZ   TestarMSC       ;Se sim, voltar a testar se M pertence a S
                JMP     GuardaValorC    ;Caso contrário, guardar o Valor.
                
TestarNMC:      PUSH    R3              ;Guardar Pos Atual Vetor
                PUSH    R4              ;Guardar Pos Aux Vetor
                PUSH    R2              ;Envia para o stack M
                MOV     R1, R5          ;Passar N para R1 para chamar TesteNM
                CALL    TesteNM         ;Testar NM
                POP     R2              ;Recupera M
                POP     R4              ;Recupera Pos Atual Vetor
                POP     R3              ;Recupera Pos Max Vetor
                CMP     R1, R0          ;R1=1?
                BR.NZ   GuardaValorC    ;Se sim, guarda valor,
                JMP     MnaoPertenceSC  ;Se não,Testar próximo M.          
                        
GuardaValorC:   MOV     M[R3], R1       ;Guarda Valor no Vetor
                CMP     R5, R6          ;N=NMAX??
                JMP.Z   RetornarC       ;Se sim, Retornar
                INC     R3              ;Caso Contrário, Aumenta Pos Atual Vetor
                INC     R5              ;Incrementa N
VoltarATestarC: JMP     Maior2C         ;E Testa se N pertence a S

RetornarC:      RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; função TesteVetorB solicitada na alínea D
; Entrada: R1 - valor máximo de N; R2 - vetor binário
; Saída: vetor em R2 corretamente preenchido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TesteVetorB:    MOV     R3, 1           ;AUX1=1
                MOV     R4, R0          ;Variavel N
                MOV     R7, R2          ;Copiar Início do vetor para atualizações
                PUSH    R2              ;Guarda Valor de início do vetor para repôr com novo N
                
Menorque3D:     CMP     R4, 2           ;N < ou =2??
                BR.P    Maiorque2D      ;Se não, TestarNM  
                ADD     M[R2], R3       ;Caso contrário, Guarda no vetor a informação de que N pertence a S
                CMP     R4, R1          ;N=NMAX??
                JMP.Z   RetornarD       ;Se sim, Retornar
                SHL     R3, 1           ;Caso contrário, próxima posição no vetor,
                INC     R4              ;próximo N e
                BR      Menorque3D      ;Testar se próximo N < = 2
                
Maiorque2D:     MOV     R6, R0          ;Inicía M=0
                MOV     R5, 1           ;AUX2=1=1ª posição de M(M=0)

VerificaPosD:   TEST    R5, M[R7]       ;Verifica se a posição corrente pertence a S
                BR.NZ   MPertenceSD     ;Se pertence, Testar NM
                                        ;Caso contrário, verificar se M.atual<N
TestarMmenorND: INC     R6              ;Próximo M(M+1)
                CMP     R6, R4          ;M+1=N<=>M=N-1?
                BR.NZ   MmenorqueND     ;Se não verifica se próximo M pertence a N
                
TestarLimitesD: CMP     R4, R1          ;Caso contrário, N=NMAX?
                JMP.Z   RetornarD       ;Se sim, Retornar com posição atual do vetor a 0
                SHL     R3, 1           ;Caso contrário, deixar posição atual do vetor a 0 e Testar limite
                                        ;da próxima posição. Foi Gerado Carry?(Próxima Posição > 16?)
                BR.NC   NextD           ;Se não, testar se próximo N pertence a S
                INC     R2              ;Se sim
                INC     R3              ;Próxima posição de memória e meter apontador no primeiro bit da mesma
NextD:          INC     R4              ;E testar se próximo N pertence a S
                POP     R7              ;Recupera Início do Vetor
                PUSH    R7              ;Volta a Guarda-lo
                BR      Maiorque2D      ;Testar Próximo N a partir de M=0

MmenorqueND:    SHL     R5, 1           ;Próxima Posição a comparar M
                                        ;Foi Gerado Carry?(Próxima Posição > 16?)
                BR.NC   VerificaPosD    ;Se não, Verificar se próximo M pertence a S
                INC     R5              ;AUX2=1ª posição da próxima posição de memória
                INC     R7              ;Próxima posição de memória a testar
                BR      VerificaPosD    ;Verificar se próximo M pertence a S 
                
MPertenceSD:    PUSH    R1              ;Guarda em Stack
                PUSH    R2              ;Tanto NMAX(R1) como posição atual do vetor(R2)
                PUSH    R3              ;Guardar também  
                PUSH    R4              ;Variável AUX1 e N atual
                MOV     R1, R4          ;Copiar para R1 e R2 os valores de N e M, que
                MOV     R2, R6          ;são os parametros de entrada de TesteNM
TestarNMD:      CALL    TesteNM
                CMP     R1, R0          ;N pertence a S?(R1=1?)
                POP     R4              ;(Recuperar
                POP     R3              ;Valores
                POP     R2              ;da 
                POP     R1              ;Stack)
                JMP.Z   TestarMmenorND  ;Se não pertence, Verificar com próximo M
                ADD     M[R2], R3       ;Caso contrário, guarda, no vetor, que pertence 
                JMP     TestarLimitesD  ;Testar limites

RetornarD:      POP     R0              ;Apagar Valor Guardado em stack para ter Endereço de Retorno em SP
                RET   
; manter a última instrução intacta
Fim: JMP Fim