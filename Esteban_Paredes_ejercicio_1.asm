
org 100h

jmp start

;........................................................................................................................................
;Declarando variables


msg1 db "Ingrese el numero de elementos en la secuencia: $"
msg2 db "Ingrese un numero adecuado en el rango de [1-25]: $"
inputarr db '0','0'         ;entrada interna para generar secuencia                     
myinput db 10,?,10 dup (']')  ;var para tomar la entrada del usuario y guardarla en inputarr
;.........................................................................................................................................

;.........................................................................................................................................

program:
                call newline

start:
                jmp print_msg1          ;imprime el primer mensaje
new_input:
                call take_input        ;Toma el numero del usuario
next:
                call check_ZERO         ;si se presiona cero, el programa se termina
                jmp check_suitable      ;si la entrada no es adecuada imprime msg2
continue: 
                call intialization      ;establece los registros que se utilizaran para generar la secuencia 
                call get_CX             ;establece el registro "CX" para que sea el registro de iteracion

                call sequence_generate  ;genera la secuencia utilizando solo registros AX, BX, CX                       
terminate:
                hlt                     ;Termina el programa !!!
;.........................................................................................................................................

sequence_generate:

        mov dx,ax           ;mover AX -> DX para imprimir (el AX contiene el índice impar de números en secuencia  
        call print_DX       
        call print_comma    ;imprimir coma entre los numeros

        dec cx              ;cx = cx-1 "se imprime un numero"

        cmp cx,0            ;marque cx para finalizar la secuencia 'en caso de que se ingrese un numero impar'
        je  program

        mov dx,bx           ;mov BX -> DX a imprimir (el BX contiene el indice par de numeros en secuencia)
        call print_DX         
        call print_comma    ;imprimir coma entre numeros
                                                
        dec cx              ;cx = cx-1 "se imprime un numero"

        add ax,bx           ;AX=AX+BX 
                                        ;;;;;;;; la formula para calcular los dos numeros siguientes en secuencia ;;;;;;;

        add bx,ax           ;BX=BX+AX 

        cmp cx,0            ; marque CX para finalizar la secuencia 'en caso de que se ingrese un numero par'
        jne sequence_generate                                                                      
                                                                                                                                          
        jmp program
 

;.........................................................................................................................................

                            ;;;;;; << imprimir nueva linea >> ;;;;;;;
newline:
        pusha 
        mov bh,0
        mov ah,03h
        int 10h                        ;obtener la posicion del cursor 

        inc dh                          ;linea siguiente
        mov dl,0                        ;col =0
        mov cx,0

        mov ah,2                        ;mover el cursor a la siguiente linea
        int 10h

        popa                               
        ret
;.........................................................................................................................................
verify0:
        pusha                            ;;;;; << verifique que la 1ra entrada esta guardada en inputarr [0] >> ;;;;;;;
        mov bx,offset inputarr[0]
        mov al,[bx]
        mov ah,0eh                      ;funcion de impresion
        int 10h
        popa                            
        ret
;.........................................................................................................................................

verify1:
        pusha                            ;;;;; << verifique que la 1ra entrada esta guardada en inputarr [0] >> ;;;;;;;
        mov bx,offset inputarr[1]
        mov al,[bx]
        mov ah,0eh                      ;funcion de impresion
        int 10h
        popa                            
        ret
;.........................................................................................................................................

check_ZERO:                                ;revisa si es cero el numero
        pusha
        mov bx,offset inputarr[0]
        mov bl,[bx]
        cmp bl,0
        je nextdigit
        back1:
        popa
        ret      
;.........................................................................................................................................
nextdigit:                           ;digito siguiente 
        mov bx,offset inputarr[1]
        mov bl,[bx]
        cmp bl,0h
        je terminate
        jmp back1

;.........................................................................................................................................
check_suitable:      ;comprueba el digito adecuado
        mov bx,offset inputarr[0]
        mov bl,[bx]                     

        cmp bl,32h
        jg  print_msg2
     
        cmp bl,2dh
        je print_msg2
           
        cmp bl,0h
        je onedigit2
        mov bx,offset inputarr[1]
        mov bl,[bx]
        cmp bl,35h
        jg print_msg2
onedigit2:       
        mov bx,offset inputarr[1]
        mov bl,[bx]
        cmp bl,39h
        jg print_msg2

        jmp continue
;.........................................................................................................................................
print_msg2:    ;imprime el mensaje msg2
        mov dx,offset msg2
        mov ah,9
        int 21h
        jmp new_input
;.........................................................................................................................................

take_input: ;toma la entrada
        mov dx, offset myinput
        mov ah,0ah
        int 21h    
        jmp move_to_inputarr

move_to_inputarr:  ;mueve a unputtar

        mov ch,myinput[2]
        mov cl,myinput[3]

        cmp myinput[4],5dh
        je onedigit         
    cont0:        
        cmp myinput[4],0dh
        jne  here2
    cont1:    
        cmp cl,0dh
        je  onedigit   
        
        cmp cl,0
        je twodigit


    twodigit:   ;segundo digito
        mov inputarr[0],ch
        mov inputarr[1],cl
        call newline
        jmp next



    onedigit:         ;primer digito

        cmp ch,30h
        je  terminate

        mov inputarr[1],ch
        mov inputarr[0],0             
        call newline
        jmp next


    here2:                 
        call newline
        call print_msg2

;.........................................................................................................................................
print_msg1:  ;imprime mensaje msg1
        mov dx,offset msg1              ;mov el tamano de msg1 en DX
        mov ah,9                        ;imprime funcion
        int 21h                         ; imprime la nota msg1
        jmp new_input                                                                                        
;.........................................................................................................................................
intialization:    ;inicializacion
        mov ax,0
        mov bx,1
        mov dx,0
        mov cx,0
        ret
;.........................................................................................................................................
get_CX:      ;obtiene CX 
        push ax
        push bx
        push dx

        mov cx,0                    ;prepara CX 
        mov ax,0                    ;prepara AX
        mov bx,0                    ;prepara BX
        mov dx,0                    ;prepara DX
        cmp inputarr[0],0
        je one           
        mov bx,offset inputarr[0]   ;bx=direccion
        mov bl,[bx]                 ;bl=primer digito+30h
        sub bl,30h                  ;bl=primer digito
        mov al,bl                   ;al=primer digito
        mov dl,10                   ;dl=10
        mul dl                      ;al=primer digito*10
        mov cx,ax
one:                                ;CH=0,CL=primer digito*10                                            
        mov bx,offset inputarr[1]   ;bx=direccion
        mov bl,[bx]                 ;BL=segundo digito+30h
        sub bl,30h                  ;BL=segundo digito
        add al,bl                   ;AL=primer digito*10+segundo digito 
                                    ;AH=0
        mov cx,ax                   ;CH=AH=0, CL=AL=primer digito*10+ segundo digito
            
        pop dx
        pop bx
        pop ax                                             
        ret

print_DX proc           ;este procedimiento se utiliza para convertir el numero en secuencia a caracteres ASCII 

        pusha          
;..............................................
digit1:   ;digito 1
        mov bx,2710h    ; bx=10000
    
        mov ax,dx       ;AX=numero
        mov dx,0        ;preparar dx como recordatorio  


        div bx          ;AX=numero/bx
                        ;AX=digito
                        ;DX=otros digitos
        cmp ax,0
        je  digit2
        push dx         ;Almacenar valor original de DX
        add al,30h      ;Convertir a ascii
        mov dl,al       ;Preparar digitos para imprimir
        mov ah,2        ;imprime funcion
        int 21h
        pop dx          ;Restaurar el valor de DX
;..............................................
digit2:  ;digito 2
        mov bx,3e8h     ;bx=1000
    
        mov ax,dx       ;AX=numero
        mov dx,0        ;Prepara dx como recordatorio  


        div bx          ;AX=numero/bx
                        ;AX=digit
                        ;DX=otros digitos
        cmp ax,0
        je  digit3

        push dx         ;Almacenar valor original de DX
        add al,30h      ;Convertir a ascii
        mov dl,al       ;Preparar digitos para imprimir
        mov ah,2        ;imprime funcion
        int 21h
        pop dx          ;Restaurar el valor de DX
;..............................................
digit3:     ;digito 3
        mov bx,64h      ;bx=100
     
        cmp dx,0
        je digit4

        mov ax,dx       ;AX=numero
        mov dx,0        ;Prepara dx como recordatorio  


        div bx          ;AX=numero/bx
                        ;AX=digito
                        ;DX=otros digitos

        cmp ax,0
        je digit4

        push dx         ;Almacenar valor original de DX
        add al,30h      ;Convertir a ascii
        mov dl,al       ;Preparar digitos para imprimir
        mov ah,2        ;imprime funcion
        int 21h
        pop dx          ;Restaurar el valor de DX
;..............................................
digit4:           ;digito 4
        mov bx,0ah      
 

        mov ax,dx       
        mov dx,0        


        div bx          
                        
                       

        cmp ax,0
        je digit5

        push dx         
        add al,30h      
        mov dl,al       
        mov ah,2        
        int 21h
        pop dx          
;..............................................
digit5:         ;digito 5
        mov bx,01h      
 

        mov ax,dx       
        mov dx,0          


        div bx          
                        
                        

        cmp ax,0
        je  zero

        push dx         
        add al,30h      
        mov dl,al       
        mov ah,2        
        int 21h
        pop dx          

jmp done
;..............................................
zero:   ;cero

        mov al,'0'
        mov ah,0eh
        int 10h
;..............................................
done:
        popa
        ret
        endp
;.........................................................................................................................................
print_comma:      ;para imprimir la coma
        pusha
        mov al,','
        mov ah,0eh
        int 10h
        popa   
        ret 