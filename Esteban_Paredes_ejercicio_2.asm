
 
include 'emu8086.inc' 
 
datos segment
    ;inicio declaracion de variables
    ;byte
    varbyte db 255 
    
    ;word
    varword dw 65535
    
    arreglo   db 0, 255
     
   

    ;fin declaracion de variables
datos ends

pila segment

    db 64 dup(0)

pila ends

codigo segment
    
    inicio proc far
        assume ds:datos, cs:codigo, ss:pila
        push ds
        mov ax,0
        push ax
        
        mov ax,datos
        mov ds,ax
        mov es, ax
            
            ;comienza a pedir numeros al usuario y llena el arreglo
            GOTOXY 10, 5
            print 'Ingrese el primer numero:'
            call scan_num
            mov arreglo[0],cl
            mov ax,0
            mov al,cl
            call print_num
            
            
            GOTOXY 10, 6
            print 'Ingrese el segundo numero:'
            call scan_num
            mov arreglo[1],cl
            GOTOXY 10, 7
            
            print 'Ingrese el tercer numero:'
            call scan_num
            mov arreglo[2],cl
            GOTOXY 10, 8
            
            print 'Ingrese el cuarto numero:'
            call scan_num
            mov arreglo[3],cl
            GOTOXY 10, 9
            
            print 'Ingrese el quinto numero:'
            call scan_num
            mov arreglo[4],cl
            GOTOXY 10, 10
            ;termina el arreglo con 5 numeros
            
                                 
            
                          
  
;sort proc ;aqui comienza el ordenamiento pero no logre hacerlo funcionar   

    ;mov cx, size      
    ;mov si, 0 
    ;mov di, 0
    ;mov ax, 1 ; esto esta hecho 
    ;dec cx    ; esto es para evitar la ultima comparacion

    ;outerLoop:        

        ;push cx  ; almacena el limite de outerLoop en la pila  

        ;mov bl, arreglo[si]    ; almacena el elemento en bl indicado por si                                                  

        ;mov cx, size   ; almacena el valor del tamano en cx para innerLoop        
        ;sub cx, ax     ; esto se hace para que el limite no continue con el limite de elementos del arreglo.

        ;innerLoop:

             ;inc di                   

             ;cmp bl, arreglo[di]  ; comparar si BL no es mayor que  
             ;jna continue          ; contenido del elemento senalado por DI, si es asi, continue; de lo contrario, cambie el valor ejecutando las siguientes declaraciones  

             ;mov dl, numero[di]   ; obtener el elemento apuntado por DI en DL
             ;mov arreglo[di], bl   ; intercambia los 
             ;mov arreglo[si], dl   ; elementos
             ;mov bl, dl             ; almacena el elemento mas pequeno en BL                              

             ;continue: 

        ;loop inner 

        ;inc ax                                                         

        ;pop cx  ; obtiene el limite del bucle externo

        ;inc si  ; incrementa el indice de bucle externo para apuntar al siguiente elemento  
                                
        ;mov di, si 

        ;loop outer                        

    ;return2:    

         ;ret     

;sort end:aqui terminaria el ordenamiento               

;end       
        
            ;comienza a imprimir el arreglo
            GOTOXY 0, 11
            print 'Arreglo:'
            
            mov ax,0
            mov al, arreglo[0]   
            GOTOXY 10, 11
            call print_num 
            mov ax,0
            mov al, arreglo[1]   
            GOTOXY 15, 11
            call print_num   
            mov ax,0
            mov al, arreglo[2]   
            GOTOXY 20, 11
            call print_num            
            mov ax,0
            mov al, arreglo[3]   
            GOTOXY 25, 11
            call print_num          
            mov ax,0
            mov al, arreglo[4]   
            GOTOXY 30, 11
            call print_num           
            ;termina impresion del arreglo
              
          
        ;fin codigo del programa -------------------------------------        
        
        
        ret
    inicio endp 
    
    
codigo ends

    DEFINE_PRINT_STRING  
    DEFINE_GET_STRING  
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM 
    DEFINE_PRINT_NUM_UNS
    end inicio