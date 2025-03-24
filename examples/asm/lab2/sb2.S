######################
#      sb TESTS      #
######################

 .globl __start

#  .data

#  tdat:
#  tdat1:  .byte 0xef
#  tdat2:  .byte 0xef
#  tdat3:  .byte 0xef
#  tdat4:  .byte 0xef
#  tdat5:  .byte 0xef
#  tdat6:  .byte 0xef
#  tdat7:  .byte 0xef
#  tdat8:  .byte 0xef
#  tdat9:  .byte 0xef
#  tdat10: .byte 0xef

# text

# __start:

test01:
  li a1, 1
  la x1, 0xef
  li x2, 0xffffffaa
  sb x2, 0(x1)
  lb x30, x1
  li x29, 0xffffffaa
  bne x30, x29, fail

