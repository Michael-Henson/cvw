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
// a5: value of x[j-1+(m-1)]

.global fir

fir:
	forj:
		bge a2, t0, endfor
		
		fori:
			bge a4, t1, forj

			//mulq31
				mulh a6, t6, a5

			//addq31
			j fori
		add a2, a2, 01 
	j forj

// loop body

	endfor:
mulq31:
	mulh a6, t6, a5
	//mov a6, a6, lsr #31
addq31:
	add t3, a2, a6
done:
    ret                 # all done; return	
