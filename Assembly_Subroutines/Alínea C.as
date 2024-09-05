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