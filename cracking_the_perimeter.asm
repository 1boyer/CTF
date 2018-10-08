; This file contains assembly code associated with a challenge by Offensive Security.
; In order to sign up for their advanced penetration testing course, a student must solve
; a javascript and x86 assembly language challenge. After using javascript to find a secret
; key online we're greeted with a base64 decodable text which gives the following:
;
; Email: XXXXX@gmail.com , Registration Code: 47444 | Now decode your CTP Secret Key and you are done! :\x31\xC0\x50\x68\x74\x74\x73\x71\x68\x20\x25\x24\x22\x68\x22\x76\x78\x71\x68\x70\x25\x75\x76\x68\x75\x75\x73\x24\x68\x78\x24\x25\x20\x68\x20\x23\x78\x24\x68\x25\x73\x77\x20\x68\x70\x73\x73\x76\x68\x20\x24\x22\x76\x68\x20\x78\x20\x72\x68\x25\x77\x25\x79\x68\x27\x23\x25\x20\x68\x71\x74\x78\x23\x68\x20\x24\x27\x23\x68\x75\x23\x70\x74\x68\x23\x73\x73\x22\x68\x78\x72\x74\x27\x68\x73\x78\x78\x20\x68\x20\x70\x75\x77\x68\x77\x79\x78\x76\x68\x78\x79\x20\x76\x68\x76\x20\x79\x75\x68\x79\x78\x20\x74\x68\x73\x77\x22\x75\x68\x74\x72\x72\x74\x68\x77\x23\x77\x70\x68\x24\x73\x27\x79\x68\x78\x27\x76\x79\x68\x24\x76\x20\x73\x68\x78\x73\x76\x70\x68\x72\x76\x72\x71\x54\x5E\x8B\xFE\x8B\xD7\\xB9\x80\x00\x00\x00\xBB\x41\x00\x00\x00\x31\xC0\x50\xAC\x33\xC3\xAA\xE2\xFA\x54\x5E\xCC
;
; The hexadecimal can be dissassembled to give x86 code that I've modified into the following program.
; 

section	.text            
	global _start       ; gcc requires _start to be declared for linking
_start: 

; Begin CTP given code
  push 0x71737474
  push 0x22242520
  push 0x71787622
  push 0x76752570
  push 0x24737575
  push 0x20252478
  push 0x24782320
  push 0x20777325
  push 0x76737370
  push 0x76222420
  push 0x72207820
  push 0x79257725
  push 0x20252327
  push 0x23787471
  push 0x23272420
  push 0x74702375
  push 0x22737323
  push 0x27747278
  push 0x20787873
  push 0x77757020
  push 0x76787977
  push 0x76207978
  push 0x75792076
  push 0x74207879
  push 0x75227773
  push 0x74727274
  push 0x70772377
  push 0x79277324
  push 0x79762778
  push 0x73207624
  push 0x70767378
  push 0x71727672

  push esp
  pop esi
  mov edi,esi
  mov edx,edi
  cld
  mov ecx,0x80
  mov ebx, 0x41
  xor eax,eax
  push eax
loop1:
  lodsb
  xor eax,ebx
  stosb
  loop loop1

  push esp
  pop esi
;;;;;;;;;;;;;;;; At this point the unencrypted key is on the stack
;;;;;;;;;;;;;;;;   so we just have to read it out in loop2 below.


  mov ecx, 0x21  ; Load the counter with the number of  
  cld ; redundant clearing of direction flag

loop2:
  lodsd                 ; load the 4 bytes at [esi] into eax
  push ecx              ; saving the number of loops to go
  mov [message], eax
  mov ecx, message
  mov edx, 4
  call displaytext      ; call sys_write(stdout, ecx, edx)
  pop ecx               ; the number of loops is loaded
  loop loop2            ; jumps to loop2 and decrements ecx

    
  mov	eax, 1	    ;system call number (sys_exit)
  int	0x80        ;call kernel
	
displaytext:
    mov eax, 4
    mov ebx, 1
    int 80H
    ret
    
section .data
    message db 0xfeedface
