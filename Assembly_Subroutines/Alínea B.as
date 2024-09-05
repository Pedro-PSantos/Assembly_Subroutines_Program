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