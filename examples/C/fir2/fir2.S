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
// a6: mulh value

.global fir

fir:
	//addi t0, a2, 0 //set the current y adress to the base y adress
	//addi t1, a1, 0 //set the cirrent c adress to the base c adress
	//addi t2, a0, 0 //set the cirrent x adress to the base x adress
	forj:
		bge a3, t0, endfor
		addi 0(a2), zero, 0 //set y[j] = 0;
		
		fori:
			bge a4, t1, forj

				mulh a6, t6, a5

			j fori
		//end fori
		add a2, a2, 01 
		j forj
	//end forj

	endfor:
mulq31:
	mulh a6, t6, a5
	//mov a6, a6, lsr #31
addq31:
	add t3, a2, a6
done:
    ret                 # all done; return	
