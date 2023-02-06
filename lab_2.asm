;5. Протабулировать функцию у(x), заданную в виде:
;		y(x) = ах + b , если 1 < x <= 5
;		y(x) = bx + а , если 5 < x <= 10
;		где а - max(A(I)), а в - max(B(I)); I=1,2,...,5
;		Нахождение max оформить в виде подпрограммы
;		Шаг табуляции x=1.

.286C
.model small
.stack 100h

.data
	arrayA db 1,2,3,4,5
	arrayB db 6,7,8,9,10
	textX  db 'X = $'
	textY  db 'Y = $'
	x      db 2
	skip   db ' ',0Dh,0Ah,'$'
	value  db 0


.code

	start:    
	          mov   ax, @data
	          mov   ds, ax

	CycleX:   

	          cmp   x, 5
	          jle   onetofive
	          cmp   x, 10
	          jle   fivetoten
	          jmp   cycleend

	onetofive:

	          mov   ah, 09h
	          mov   dx, offset textX  	; выводим X =
	          int   21h
	          mov   al, x
	          call  PrintNum          	; выводим сам X

	          mov   ah, 02h
	          mov   dx, ' '           	; выводим пробел
	          int   21h

	          mov   ah, 09h
	          mov   dx, offset textY  	; выводим Y =
	          int   21h

	          lea   bx, arrayA        	; адрес массива
	          call  FindMax           	; находим максимум в А

	          fild  word ptr x        	; перемещение операнда в верхушку стека
	          mov   byte ptr value, al	; чтение переменной, как байт и перемещение
	          fimul word ptr value    	; умножение верхушки стека

	          lea   bx, arrayB        	; адрес массива
	          call  FindMax           	; находим максимум в В

	          mov   byte ptr value, al	; чтение переменной, как байт и перемещение
	          fiadd word ptr value    	; сложение с верхушкой стека и её перезапись

	          fistp word ptr value    	; вытаскиваем верхушку стека в переменную
	          mov   al, value
	          call  PrintNum
	          mov   ah, 09h
	          mov   dx, offset skip
	          int   21h

	          add   x, 1
	          jmp   CycleX

	fivetoten:

	          mov   ah, 09h
	          mov   dx, offset textX  	; выводим X =
	          int   21h
	          mov   al, x
	          call  PrintNum          	; выводим сам X

	          mov   ah, 02h
	          mov   dx, ' '           	; выводим пробел
	          int   21h

	          mov   ah, 09h
	          mov   dx, offset textY  	; выводим Y =
	          int   21h

	          lea   bx, arrayB        	; адрес массива
	          call  FindMax           	; находим максимум в B

	          fild  word ptr x        	; перемещение операнда в верхушку стека
	          mov   byte ptr value, al	; чтение переменной, как байт и перемещение
	          fimul word ptr value    	; умножение верхушки стека

	          lea   bx, arrayA        	; адрес массива
	          call  FindMax           	; находим максимум в A

	          mov   byte ptr value, al	; чтение переменной, как байт и перемещение
	          fiadd word ptr value    	; сложение с верхушкой стека и её перезапись

	          fistp word ptr value    	; вытаскиваем верхушку стека в переменную
	          mov   al, value
	          call  PrintNum
	          mov   ah, 09h
	          mov   dx, offset skip
	          int   21h

	          add   x, 1
	          jmp   CycleX

	cycleend: 

	          mov   ax, 4c00h         	; стандартный выход
	          int   21h               	; прерывание


FindMax PROC                      		;max будет в al

	          mov   si, 0             	; i-ое
	          mov   al, [bx][si]      	; присваем первый эл
	          inc   si                	; увеличение счетчика
	searchmax:
	          mov   cl, [bx][si]      	; присваем эл[i+1]
	          cmp   cl, al            	; сравниваем первый и следующий
	          jg    max               	; jump if greater
	          jmp   maxend            	; jump
	max:      
	          mov   al, [bx][si]
	maxend:   
	          inc   si
	          cmp   si, 5
	          jl    searchmax

	          ret
FindMax ENDP

PrintNum PROC                     		;В al число
	          push  ax                	; заносим в стек
	          push  cx
	          push  bx

	          xor   cx, cx
	          mov   bl, 10
	DivLoop:  
	          xor   ah, ah
	          div   bl                	; /10
	          add   ah, '0'           	; делаем символ
	          push  ax
	          inc   cx
	          test  al, al
	          jnz   DivLoop
	PrintLoop:
	          pop   ax
	          xchg  al, ah            	; меняем местами
	          int   29h               	; короткое прерывание
	          loop  PrintLoop
	          pop   bx
	          pop   cx
	          pop   ax

	          ret
PrintNum ENDP

end start
