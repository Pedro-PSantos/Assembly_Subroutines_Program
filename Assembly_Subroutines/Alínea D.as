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