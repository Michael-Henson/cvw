######################
#      sb TESTS      #
######################

 .globl __start

# __start:

test01:
  li a1, 1
  la x1, 0xef
  li x2, 0xffffffaa
  sb x2, 0(x1)
  lb x30, x1
  li x29, 0xffffffaa
  bne x30, x29, fail

