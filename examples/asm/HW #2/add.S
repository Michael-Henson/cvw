// sum.s
// David_Harris@hmc.edu 24 December 2021
// Add up numbers from 1 to N.

// result in s0, i in s1, N in a0, return answer in a0
//
// long sum(long N) {
//   long result, i;
//   result = 0;
//   for (i=1; i<=N; i++) result = result + i;
//   return result;
// }

.global add
add:
    li a0, 0x42
    li a1, 0xED
    add a0, a0, a1
done:
    