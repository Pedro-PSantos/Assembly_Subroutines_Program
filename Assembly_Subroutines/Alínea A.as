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