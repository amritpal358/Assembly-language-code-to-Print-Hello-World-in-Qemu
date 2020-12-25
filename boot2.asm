[BITS 16]     ;output 16 bit instructions
[ORG 0x7c00]  

part:
	MOV ax, 0x2401    ;A20 bit
	MOV ah, 0x0e 
	MOV ax, 0x3        ; vga text mode
	INT 0x10            
	CLI			
	LGDT [pointer]  
	MOV eax, cr0	
	OR eax,0x1          
	MOV cr0, eax		
	JMP code - start:part1  ;jump to code segment  
start:
	DQ 0x0
code:
	DW 0xFFFF
	DW 0x0
	DB 0x0
	DB 10011010b
	DB 11001111b
	DB 0x0
data:
	DW 0xFFFF
	DW 0x0
	DB 0x0
	DB 10010010b
	DB 11001111b
	DB 0x0
end:
pointer:
	DW end-start
	DD start

[BITS 32]
part1:
	MOV ax, data - start
	MOV ss, ax
	MOV gs, ax
	MOV fs, ax
	MOV es, ax
	MOV ds, ax
	MOV esi,print_helloworld
	MOV ebx,0xb8000
.lop:
	LODSB
	OR eax,0x0100
	MOV word [ebx], ax
	ADD ebx,2
	JMP .lop
halt:
	CLI ;clear interrupt flag
	HLT ;halt execution
print_helloworld:  db "hello world!",0

times 510 - ($-$$) db 0
dw 0xaa55
