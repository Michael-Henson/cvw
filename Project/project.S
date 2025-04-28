.section .text.init
.globl rvtest_entry_point

rvtest_entry_point:

    # set up PMP so all of memory is accessible and we don't trap when entering supervisor mode
    li t0, 0xFFFFFFFF              # t0 = 0xFFFFFFFF
    csrw pmpaddr0, t0      # Set top of range to max address
    
    # Define region 0 to cover all addresses as RWX
    li t1, 0x0F            # 0b00001111 -> R/W/X permissions + TOR mode     L_0_0_AA_X_W_R
    csrw pmpcfg0, t1       # Apply config to pmpcfg0

    nop

    # switch to supervisor mode	

    # Set mstatus.MPP to 01
    
    csrr t0, mstatus
    li   t1, 0x0800           # MPP = 01 (S-mode)
    li   t2, 0xe7ff
    and t0, t0, t2       # Clear MPP bits (12 & 11)
    or   t0, t0, t1           # Set MPP = 01
    csrw mstatus, t0


    # set MEPC to a trampoline address where supervisor should begin, do mret
    la   t0, supervisorstart
    csrw mepc, t0
    
	                        # fill in instructions here			
    mret                    # enter supervisor mode at supervisorstart
    nop

supervisorstart:
    la t0, pagetable        # get address of root page table
	srli t0, t0, 12         # divide address by 12
    li t0, 0x2008001
    			            # fill in instructions here 
    csrw satp, t0         	# enable virtual memory
    
    # now we are execuiting on virtual page 0x80000, which is also physical page 0x80000
    # (this can be whatever you want as long as you use the correct address defined in the proj)	
    li t0, 0x90000300       
    li t1, 42
    sw t1, 0(t0)


    la t0, testcode         # address of a routine to run
    lui t1, 0x10000         
    add t0, t0, t1          # address of testcode on virtual page 0x90000 
    jr t0                   # jump to the testcode on Virtual page 0x90000, 
                            # which still points to same code on physical page 0x80000
    nop                     # shouldn't be executed

testcode:
    li t0, 42                # do something

write_tohost:
    la s1, tohost           # terminate with write tohost
    li t0, 1                # 1 for success, 3 for failure
    sw t0, 0(s1)            # send success code (yay)
    sw zero, 4(s1)          # not obvious why Sail isn't terminating unless this write is done

self_loop:
    j self_loop

tohost:
    .word 0

.data

#     VPN       VPN[1]    VPN[0]     Offset
# 80000000 = 1000000000_0000000000_000000000000
# 90000000 = 1001000000_0000000000_000000000000

# root (L1) Page table situated at 0x80010000
.align 16
pagetable:
    .zero 0x200
    # VPN[1] = 1000000000
    .word 0x80011000
    .align 6
    # VPN[1] = 001001000000
    .word 0x80020000

    # address format PPN_RSW_D_A_G_U_X_W_R_V
    # PPN = 22 bits    RSW = 2 bits

.align 12
# L0 page table situated at 0x80011000
    # VPN[0] = 0000000000
    .word 0x8000000F

    .align 16
    .word 0x8000000F


 # 8000000F