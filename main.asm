.stack 100h
.model small
.data
 
bStart    db "Battle Start!$"
bdis      db "             $" 

command     db "Select your Command: $"
action      db "1.Gun $"
defence     db "2.Shield $"        
health      db "Health: $"

attackmsg1  db "You dealt $"   
attackemsg1 db "Foe dealt $"
attackmsg2  db " damage.$" 
hidemsg     db "                              $"    

defeatmsg   db "Thine foe is defeated.$"            
gover       db "GAME OVER!$"

rowCount db 3h
topMap db "----------------------------$" 
sideMap db "|$"     
wallbrow db 6h
wallRrow db 5h
wallbottom db "------$"     
wallbottomb db "-------------$"   
wall1col db 11h  
wall1count db 7   
uirow db 2h
uibottom db 15h  
fileCount db 0


en1Defence  db 1 
en1Attack   db 2 
enhp        db 15
enfileAttack db 33h, '$'
plfileAttack1 db 35h, '$'
plfileAttack2 db 37h, '$' 

pl1hp       db 2
plhp        db 35h
pldefence   db 5
plAttack    db 4
plexp       db 0
explvl2     db 10


p1        db 50h, "$"
prow      db 0eh
pcol      db 25h
erow      db 4h
ecol      db 13h
     
w_key     db 77h
s_key     db 73h
a_key     db 61h
d_key     db 64h 
shoot_key db 47h

fire      db 0f9h 
efire     db 11h

efireR    db 0bh
efireC    db 29H

PfireR    db 0ch
PfireC    db 29h
playerRow db 0ch
playerCol db 14h  
enemyRow  db 0ah
enemyCol  db 2bh 
 
enemy     db 28h,6fh,5fh,6fh,29h,0ah,8h,8h,8h,8h,5fh,0b3h,5fh,0ah,8h,8h,8h,8h,8h,8h,11h,3dh,3dh,0b3h,5fh,0b3h,0ah,8h,8h,0b3h,0ah,8h,8h,2fh,20h,5ch,0ah,8h,8h,8h,8h,5fh,0b3h,20h,0b3h,5fh
player    db 4fh,0ah,8h,8h,28h,59h,3dh,6fh,0ah,8h,8h,8h,8h,2fh,5fh,5ch,0ah,8h,8h,8h,2fh,20h,5ch

shin db 0,0,0,0,0
file db 'battleLog.txt',0
buffer db 1000 dup(?)  
handle dw ?

nl db 0ah,0dh, '$'
    

.code     
    main proc 
        
         mov ax, @data
         mov ds, ax
         
         mov ah, 3ch
         mov al, 0
         mov dx, offset file
         int 21h
         
        mov ah, 3dh
        mov al, 1
        mov dx, offset file
        int 21h
        mov handle, ax
         
         mov ah, 00h      ;video mode to 80x25
         mov al, 03h 
         int 10h   
         
         mov ch, 32       ;hide blinking cursor
         mov ah, 1
         int 10h      
         
         mov al, 0h   ;setting active page to 1 for map screen
         mov ah, 05h
         int 10h  
         
         first_screen:    ;printing the first map     
         
         topui:
    
        mov dl, 11h           ;drawing ui top
        mov dh, 2h 
        mov ah, 2h
        int 10h
    
        mov dx, offset topMap       ;printing the top ui vairable
        mov ah, 9h
        int 21h   
        
        bottomui:      ;drawing bottom ui
        
        mov dl, 11h                 ;going to the row and column
        mov dh, 15h
        mov ah, 2h
        int 10h
        
        mov dx, offset topMap       ;printing the bottom ui variable
        mov ah, 9h
        int 21h    
        
        mov ch, rowCount           ;readying the ch register with row
        
        leftui:         ;drweaing left ui
        
        mov dh, ch                ;going to the particular row and column
        mov dl, 11h 
        mov bh, 0h
        mov ah, 2h
        int 10h
        
        mov dx, offset sidemap     ;printing the side map vairable
        mov ah, 9h
        int 21h      
        
        inc ch                     ;incrementing the ch register i.e. row
        
        cmp ch, 15h
        jnz leftui                 ;jump to leftui label if row != 15
        
        mov ch,rowCount            ;loading the row to ch for right wall
                   
        rightui:
        mov dh,ch                   ;going to the row and column
        mov dl,2ch
        mov ah,2h
        int 10h
        
        mov dx, offset sidemap      ;printing the side map variable
        mov ah,9h
        int 21h
        inc ch    
        
        cmp ch,15h
        
        jnz rightui                 ;jump to rightui if not equal to 15
        
        ;drawing inner maps
        innermaps:         ;bottom row
        mov dh,6h
        mov dl, 12h
        mov ah,2h 
        int 10h   
        
        mov dx,offset wallbottom
        mov ah,9h
        int 21h   
        
        mov cl, 3h
        innerright:        ;right side
        
        mov dh, cl
        mov dl, 19h
        mov ah, 2h
        int 10h  
        
        mov dx, offset sidemap      ;drawing the right inner map using loop
        mov ah, 9h
        int 21h
        
        inc cl
        
        cmp cl, 6h
        jnz innerright   
        
        mov dh, erow         ;enemy placement
        mov dl, ecol
        mov ah, 2h
        int 10h
        
        mov dl, 45h
        mov ah, 2h
        int 21h 
        
        ;top right room
       
        mov dh, 6h
        mov dl, 26h
        mov ah, 2h
        int 10h  
        
        mov dx, offset wallbottom      ;drawing the right inner map using loop
        mov ah, 9h
        int 21h      
        
        mov cl, 3h
        innerright2:
        
        mov dh, cl
        mov dl, 23h
        mov ah, 2h
        int 10h
        
        mov dx, offset sidemap
        mov ah, 9h
        int 21h
        
        inc cl
        
        cmp cl, 6h
        jnz innerright2 
        
        mov dh, 4h         ;enemy placement
        mov dl, 27h
        mov ah, 2h
        int 10h
        
        mov dl, 45h
        mov ah, 2h
        int 21h     
        
        ;bottom left room
       
        mov dh, 11h
        mov dl, 12h
        mov ah, 2h
        int 10h  
        
        mov dx, offset wallbottom      ;drawing the right inner map using loop
        mov ah, 9h
        int 21h      
        
        mov cl, 12h
        innerright3:
        
        mov dh, cl
        mov dl, 19h
        mov ah, 2h
        int 10h
        
        mov dx, offset sidemap
        mov ah, 9h
        int 21h
        
        inc cl
        
        cmp cl, 15h
        jnz innerright3
        
        mov dh, 13h         ;enemy placement
        mov dl, 14h
        mov ah, 2h
        int 10h
        
        mov dl, 45h
        mov ah, 2h
        int 21h  
        
                
        ;bottom room
       
        mov dh, 10h
        mov dl, 1bh
        mov ah, 2h
        int 10h  
        
        mov dx, offset wallbottomb      ;drawing the right inner map using loop
        mov ah, 9h
        int 21h      
        
        mov cl, 11h
        innerright4:
        
        mov dh, cl
        mov dl, 1bh
        mov ah, 2h
        int 10h
        
        mov dx, offset sidemap
        mov ah, 9h
        int 21h
        
        inc cl
        
        cmp cl, 15h
        jnz innerright4 
        
        mov cl, 11h
        innerright5: 
        
        mov dh, cl
        mov dl, 27h
        mov ah, 2h
        int 10h
        
        mov dx, offset sidemap
        mov ah, 9h
        int 21h
        
        inc cl
        
        cmp cl, 14h
        jnz innerright5    
        
        mov dh, 12h         ;enemy placement
        mov dl, 21h
        mov ah, 2h
        int 10h
        
        mov dl, 42h
        mov ah, 2h
        int 21h    
         
         battle_screen: 
         
         mov al, 1h   ;setting active page to 1 for battle screen
         mov ah, 05h
         int 10h   
         
         mov cl, 11h
         mov ch, 2h
         
         ui_top:      ;for top border
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h  
                  
         mov dl, 0cdh
         mov ah, 2h
         int 21h 
         
         inc cl
         
         cmp cl, 33h
         
         jnz ui_top    
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h
         
         mov dl, 0bbh
         mov ah, 2h
         int 21h 
         
         inc ch
                 
         ui_right:     ;for right border
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h
         
         mov dl, 0bah
         mov ah, 2h
         int 21h
         
         inc ch
         
         cmp ch, 15h
         
         jnz ui_right
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h    
         
         mov dl, 0bch
         mov ah, 2h
         int 21h 
         
         dec cl
         
         ui_bottom:    ;for bottom border
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h      
         
         mov dl, 0cdh
         mov ah, 2h 
         int 21h   
         
         dec cl
         
         cmp cl, 10h
         
         jnz ui_bottom   
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h
         
         mov dl, 0c8h
         mov ah, 2h
         int 21h
         
         dec ch 
         
         ui_left:      ;for left border
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h
         
         mov dl, 0bah
         mov ah, 2h
         int 21h
         
         dec ch
         
         cmp ch, 2h        
         
         jnz ui_left 
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h
         
         mov dl, 0c9h
         mov ah, 2h
         int 21h 
         
         mov ch, 10h
         mov cl, 11h
         
         ground:         ;for ground
         
         mov dh, ch
         mov dl, cl
         mov bh, 1h
         mov ah, 2h
         int 10h
         
         mov dl, 0c4h
         mov ah, 2h
         int 21h     
         
         inc cl    
         
         cmp cl, 33h
         
         jnz ground 
         
         forPlayer:
         
         call playerChar     
         call enemyChar
         
         mov dh, 12h   ;for health status
         mov dl, 12h
         mov bh, 1h
         mov ah, 2h
         int 10h   
         
         mov dx, offset health
         mov ah, 9h
         int 21h
         
         mov dl, pl1hp   
         add dl, 30h
         mov ah, 2h
         int 21h
         
         mov dl, plhp
         mov ah, 2h
         int 21h       
         
         mov dh, 12h     ;for enemy health status
         mov dl, 29h
         mov bh, 1h
         mov ah, 2h  
         int 10h
         
         mov dx, offset health
         mov ah, 9h
         int 21h
         
         mov dl, 3fh
         mov ah, 2h
         int 21h
                       
         concept_design:    
         
         mov cl, 10h
         mov ch, 24h  
         
         mov al, 0h       ;setting active page to 0
         mov ah, 05h
         int 10h  
         
         mov ah, 2     
         mov dh, prow 
         mov dl, pcol
         mov bh, 0         ;moving to row and column       
         int 10h 
    
         mov dx, offset p1  ;printing char
         mov ah, 9
         int 21h    
         
         mov ah, 00h   ;getting input with no echo
         int 16h
        
         cmp al, w_key             
         je collision_up
         
         cmp al, s_key         
         je collision_down
         
         cmp al, d_key        
         je inc_c         
         
         cmp al, a_key         
         je dec_c   
         
         jne final
         
         dec_c:         ;moving left   
         
         dec pcol
        mov bl, pcol       ;for collision left
        cmp bl, 11h
        jz increment_left
        
        cmp bl, 19h            ;for checking with column
        jnz move_left
        
        mov dl, prow       ;for checking with left wall with left key
        mov bl, rowCount
        mov ch, 3    
        
        col4check:
        
        cmp dl, bl             ;for column check
        jz increment_left  
        
        inc bl
        
        dec ch   
        
        cmp ch, 0
        
        jnz col4check     
        
        jmp move_left
        
        increment_left:
        
        inc pcol
        jmp concept_design
    
         move_left:
         
         inc pcol   
                
         mov dh, prow   ;going to the row and column
         mov dl, pcol 
         mov ah, 2
         mov bh, 0 
         int 10h  
                              
         mov dl, 00h    ;printing null
         mov ah, 2h
         int 21h 
         
         dec pcol
         jmp row_encounter
         
         inc_c:        ;moving right  
         
         inc pcol
        mov bl,pcol
        cmp bl,02ch
        jz increament_right
        
        cmp bl, 19h            ;for checking with column
        jnz move_right
        
        mov dl, prow       ;for checking with right wall with right key
        mov bl, rowCount
        mov ch, 3    
        
        col3check:
        
        cmp dl, bl             ;for column check
        jz increament_right  
        
        inc bl
        
        dec ch   
        
        cmp ch, 0
        
        jnz col3check     
        
        jmp move_right
            
        increament_right:
        dec pcol
        jmp concept_design
    
         move_right:
         
         dec pcol
         
         mov dh, prow 
         mov dl, pcol 
         mov ah, 2
         mov bh, 0 
         int 10h  
                              
         mov dl, 00h
         mov ah, 2h
         int 21h 
         
         inc pcol
         jmp row_encounter
         
         collision_down:        ;moving down    
         
        inc prow
        mov bl, prow    ;for collision down
        cmp bl, uibottom
        jz increment_down  
        
        cmp bl, wallbrow
        jnz move_down
        
        mov bl, wall1col
        mov dl, pcol
        mov ch, wall1count          
        
        col2check:
        
        cmp dl, bl             ;for column check
        jz increment_down
        inc bl
        
        dec ch
        
        cmp ch, 0
        jnz col2check                         
        
        jmp move_down
            
        increment_down:
        dec prow
        jmp concept_design
    
         move_down:
         
         dec prow
         
         mov dh, prow 
         mov dl, pcol 
         mov ah, 2
         mov bh, 0 
         int 10h  
                              
         mov dl, 00h
         mov ah, 2h
         int 21h 
         
         inc prow
         jmp row_encounter
         
         collision_up:        ;moving up   
         
        dec prow        ;for collision up
        mov cl, prow
        cmp cl, uirow
        jz increment_up    
        
        cmp cl, wallbrow   ;for row check bottom
        jnz rowwall        ;for row right wall             
        
        mov bl, wall1col  
        mov dl, pcol
        mov ch, wall1count   
        
        colcheck:
        
        cmp dl, bl             ;for column check
        jz increment_up
        inc bl
        
        dec ch
        
        cmp ch, 0
        jnz colcheck     
        
        jmp move_up
        
        rowwall:           ; for checking with right wall
        mov cl, prow
        cmp cl, wallRrow   ;checking row
        jnz move_up
        
        mov cl, pcol
        cmp cl, 19h        ;checking bottom
        jz increment_up
        
        jmp move_up
        
        increment_up:     ;incrementing again for previous state
        inc prow
        jmp concept_design  
    
         move_up:     
         
         inc prow
         
         mov dh, prow    ;going to the particular row and column
         mov dl, pcol 
         mov ah, 2
         mov bh, 0 
         int 10h  
                              
         mov dl, 00h      ;printing null
         mov ah, 2h
         int 21h 
         
         dec prow
         
         jmp row_encounter        
                      
         row_encounter:   
         
         mov cl, prow
         
         cmp cl, erow
         je col_encounter 
         
         cmp cl, 12h 
         je col_encounter
         cmp cl, 13h     
         je col_encounter
         cmp cl, 4h      
         je col_encounter
         
         jne final
         
         
         col_encounter: 
         
         mov ch, pcol
         
         cmp ch, ecol
         je battle   
         cmp ch, 21h
         je battle
         cmp ch, 14h
         je battle
         cmp ch, 27h
         je battle
         
         jne final 
         
         battle:    
         
         mov enhp,15
         
         mov al, 1h   ;setting active page to 1 for battle screen
         mov ah, 05h
         int 10h 
         
         mov dh, 06h  ;showing battle start message
         mov dl, 1ch 
         mov bh, 1h
         mov ah, 2h
         int 10h
         
         mov dx, offset bStart
         mov ah, 9h 
         int 21h                
         
         call battleStart          
         call disNsounBat      
         
         battleAction:
         
         mov pFireR, 0dh
         mov pFireC, 17h  
         
         mov ah, 00h
         int 16h
         
         cmp al, shoot_key
         jne battleAction
         
         call BulletShow  
         
         cmp enhp, 0
         
         jne battleAction 
         
         
         
         final:
         
         jmp concept_design
         
         gameover: 
         
         mov dh, 06h  ;showing game over message
         mov dl, 1ch 
         mov bh, 1h
         mov ah, 2h
         int 10h     
         
         mov dx, offset gover
         mov ah, 9h
         int 21h       
         
        mov dh, playerRow
        mov dl, playerCol
        mov ah, 2h
        mov bh, 1h 
        int 10h   
        
        mov dl, 00h
        mov ah, 2h
        int 21h
        
        mov ah, 00h
        int 16h
        
        mov al, 2h
        mov ah, 05h
        int 10h
        
        mov ah, 3dh
        mov al, 0
        mov dx, offset file
        int 21h
        mov handle, ax
        
        mov ah, 3fh
        mov bx, handle
        mov dx, offset buffer
        mov cx, 378
        int 21h
        
        mov dx, offset buffer
        mov ah, 9h
        int 21h
        
       
         mov ah, 4ch
         int 21h             
        
    main endp  
    
    disNsounBat proc      
        
         mov dh, 06h  ;hiding battle message
         mov dl, 1ch 
         mov bh, 1h
         mov ah, 2h
         int 10h
         
         mov dx, offset bdis
         mov ah, 9h
         int 21h
         
         ret
        
    disNsounBat endp
    
    playerChar proc
        
        mov dh, playerRow
        mov dl, playerCol
        mov ah, 2h
        mov bh, 1h 
        int 10h   
        
        mov bx, 0
        mov bx, offset player
        mov cl, 27 
        
        player_char:  ;for player character
         
        mov dl, [bx]
        mov ah, 2h
        int 21h
         
        inc bx
         
        dec cl
         
        cmp cl, 0
         
        jnz player_char
        
        ret   
        
     playerChar endp 
    
     enemyChar proc
        
        mov dh, enemyRow
        mov dl, enemyCol
        mov ah, 2h
        int 10h
        
        mov bx, 0
        mov bx, offset enemy
        mov cl, 47
        
        enemy_char:    
        
        mov dl, [bx]
        mov ah, 2h
        int 21h
        
        inc bx
        dec cl
        cmp cl, 0
        jnz enemy_char 
        
        ret
          
     enemyChar endp
    
     battleStart proc
        
        mov dh, 5h              ;moving to the right row and col
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h 
        
        mov dx, offset command  ;showing the commands
        mov ah, 9h
        int 21h   
        
        mov dh, 6h
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h
        
        mov dx, offset action
        mov ah, 9h
        int 21h
        
        mov dh, 7h
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h  
        
        mov dx, offset defence
        mov ah, 9h
        int 21h
        
        ret 
        
     battleStart endp   
     
     BulletShow proc 
        
        mov dl, 7h      ;beep sound
        mov ah, 2h
        int 21h
        
        projectile:     ;bullet moving
         
         mov dh, PfireR  ;showing bullet
         mov dl, PfireC
         mov ah, 2h
         mov bh, 1h 
         int 10h
         
         mov dl,  fire
         mov ah, 2h
         int 21h
                  
         mov dh, PfireR  ;hiding it
         mov dl, PfireC
         mov ah, 2h
         mov bh, 1h 
         int 10h
         
         mov dl, 00h
         mov ah, 2h
         int 21h
         
         inc PfireC
         
         cmp PfireC, 2dh  ;until reach border
         
         jnz projectile         
         
         call calpdmg       
         
         ret       
        
     BulletShow endp
     
     calpdmg proc 
        
        mov dh, 9h            ;showing the damage msg and calculate damage
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h
        
        mov dx, offset attackmsg1
        mov ah, 9h
        int 21h
        
        mov bl, plAttack
        sub bl, en1Defence       
        
        sub enhp, bl
        
        mov dl, bl
        add dl, 30h
        mov ah, 2h
        int 21h   
        
        mov dx, offset attackmsg2
        mov ah, 9h
        int 21h    
        
        ;file handling
        
        mov bx, handle
        mov ah, 40h
        mov dx, offset attackmsg1
        mov cx, 10
        int 21h
        
        cmp fileCount, 0
        jz at0
        cmp fileCount, 1
        jz at1
        cmp fileCount, 2
        jz at2
        
        at0:
        
        mov ah, 40h
        mov dx, offset enfileAttack
        mov cx, 1
        int 21h
        
        jmp atout
        
        at1:
        
        mov ah, 40h
        mov dx, offset plfileAttack1
        mov cx, 1
        int 21h  
        
        jmp atout
        
        at2:
        
        mov ah, 40h
        mov dx, offset plfileAttack2
        mov cx, 1
        int 21h
        
        atout:
        
        mov ah, 40h
        mov dx, offset attackmsg2
        mov cx, 8
        int 21h
        
        mov ah, 40h
        mov dx, offset nl
        mov cx, 2
        int 21h  
                
        mov cx, 40
        
        delay:
        
        dec cx
        cmp cx, 1
        jne delay
        
        mov dh, 9h
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h
        
        mov dx, offset hidemsg
        mov ah, 9h
        int 21h   
        
        mov dl, enhp
        add dl, 30h
        cmp dl, 30h
        jg endpcal 
        
        mov dh, 9h
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h
        
        mov dx, offset defeatmsg
        mov ah, 9h
        int 21h
                    
                    
        mov cx, 40
        
        delay3:
        
        dec cx
        cmp cx, 1
        jne delay3
        
        mov dh, 9h
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h
        
        mov dx, offset hidemsg
        mov ah, 9h
        int 21h 
        
        call expcal
        ret        
        
        endpcal:   
        
        call ebulletshow
        
        ret
         
     calpdmg endp  
     
     ebulletshow proc  
        
        mov dl, 07h
        mov ah, 2h
        int 21h     
        
        mov efireR, 0ch
        mov efireC, 29h
        
        eprojectile:
        
        mov dh, efireR
        mov dl, efireC
        mov ah, 2h
        int 10h
        
        mov dl, efire
        mov ah, 2h
        int 21h
        
        mov dh, efireR
        mov dl, efireC
        mov ah, 2h
        int 10h
        
        mov dl, 00h
        mov ah, 2h
        int 21h
        
        dec efireC
        cmp efireC, 14h
        
        jnz eprojectile   
        
        mov dh, efireR
        mov dl, 29h
        mov ah, 2h
        int 10h
        
        mov dl, 11h
        mov ah, 2h
        int 21h
                
        
        call caledmg 
        
        ret
        
        
     ebulletshow endp
     
     caledmg proc    
        
        mov dh, 9h
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h 
        
        mov dx, offset attackemsg1
        mov ah, 9h
        int 21h
        
        mov bl, pldefence
        sub bl, en1attack  
        
        sub plhp, bl
        
        mov dl, bl
        add dl, 30h
        mov ah, 2h
        int 21h
        
        mov dx, offset attackmsg2
        mov ah, 9h
        int 21h     
        
        ;file handling
        
        mov bx, handle
        mov ah, 40h
        mov dx, offset attackemsg1
        mov cx, 10
        int 21h
        
        mov ah, 40h
        mov dl, offset enfileAttack
        mov cx, 1
        int 21h
        
        mov ah, 40h
        mov dx, offset attackmsg2
        mov cx, 8
        int 21h
        
        mov ah, 40h
        mov dx, offset nl
        mov cx, 2
        int 21h 
        
        mov cl, 40
                
        edelay:
        
        dec cl
        cmp cl, 1
        jne edelay       
        
        mov dh, 9h
        mov dl, 36h
        mov ah, 2h
        mov bh, 1h
        int 10h
        
        mov dx, offset hidemsg
        mov ah, 9h
        int 21h
        
        cmp plhp, 30h
        jg printhp
        
        cmp pl1hp, 0
        je zeroHp
        
        dec pl1hp    
  
        mov plhp, 39h 
        
        printhp:
        
        mov dh, 12h   ;for health status
        mov dl, 1ah
        mov bh, 1h
        mov ah, 2h
        int 10h
        
        mov dl, pl1hp
        add dl, 30h
        mov ah, 2h
        int 21h
        
        mov dl, plhp   
        mov ah, 2h
        int 21h
                              
        ret
        
        zeroHp: 
        
        mov dh, 12h   ;for health status
        mov dl, 1ah
        mov bh, 1h
        mov ah, 2h
        int 10h
        
        mov dl, 30h
        mov ah, 2h
        int 21h
        
        mov dl, 30h   
        mov ah, 2h
        int 21h    
        
        je gameover                  
                      
     caledmg endp
     
     expcal proc
        
        add plAttack, 2 
        inc fileCount
            
        ret
        
        
     expcal endp           

end main