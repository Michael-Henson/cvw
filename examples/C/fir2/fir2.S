# fir.S 
# assembly language of Finite Impulse Response (FIR)

// a0: base address of x
// a1: base address of c
// a2: base address of y, later used as pointer to y[j] in j loop
// a3: n
// a4: m

// t0: &y[n-m] to check termination of j loop
// t1: &c[m] to check termination of i loop
// t2: &x[j+m-1]
// t3: sum
// t4: pointer to c[i] in i loop
// t5: pointer to x[j-i+(m-1)] 
// t6: value of c[i]
// a5: value of x[j-i+(m-1)]
// a6: multiplication value
// a7:

.global fir
//accumulate in t3
//xxxxxxxxxxreset t3 before going in loop
//increment t2 to next address in endi
//xxxxxxxdont forget to shift after mul (signed shifting)


fir:
	sub t0, a3, a4
	slli t0, t0, 2
	add t0, t0, a2

	add t1, a4, 0
	slli t1, t1, 2
	add t1, t1, a1

	add t2, a4, -1
	slli t2, t2, 2
	add t2, t2, a0

	mv t4, a1 //set the current c adress to the base c adress

	and t3, t3, x0
	forj:
		bgt a2, t0, endfor //set end condition for j loop
		mv t5, t2
		fori:
			bge t4, t1, endi //set end condition for i loop

				lw t6, 0(t4) //take the value at c[i]
				lw a5, 0(t5) //take the value at x[j-i+m-1]
				mul a6, t6, a5 // multiply c[i] and x[j-i+(m+1)] 
				srli a6, a6, 31 // shift the 64 bit number back to q_31
				add t3, t3, a6 //add multiplication result into y[j] 

				add t4, t4, 4 //incriment c by 1 address
				add t5, t5, -4 //decrement x by 1 address
			j fori
		//end fori
		endi:
		mv t4, a1 // reset C back to base address
		sw t3, 0(a2)
		add a2, a2, 4
		add t2, t2, 4
		and t3, t3, x0
		j forj
	//end forj

	endfor:
                # all done; return	
