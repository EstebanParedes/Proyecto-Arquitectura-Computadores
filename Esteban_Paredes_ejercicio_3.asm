include 'emu8086.inc'
;intento de arbol binario
.stack 100
.data
arbolbinario db 'Raiz: A  Rama: B,C Hoja: D,E,F,G  $'
profundidad db 'Profundidad es: A,B,D,E,C,F,G   $'
anchura db 'Anchura: A,B,C,D,E,F,G$'
.code
; inicializacion de variables
mov ax, @data
mov ds,ax

mov ah,09h ;funcion para imprimir una cadena
lea dx, arbolbinario ; carga a dx lo qe hay en msg
int 21h ; imprime la cadena
GOTOXY 0, 1
lea dx, profundidad ; carga a dx lo qe hay en msg
int 21h ; imprime la cadena
GOTOXY 0, 2
lea dx, anchura ; carga a dx lo qe hay en msg
int 21h ; imprime la cadena
.exit
end