// #ip 2
const IP = 1
1 mem[5] = 123 // seti 123 0 5
2 mem[5] = mem[5] & 456 // bani 5 456 5
3 mem[5] = mem[5] === 72 ? 1 : 0 // eqri 5 72 5
4 IP = mem[5] + IP //addr 5 2 2
5 IP = 0 // seti 0 0 2
6 mem[5] = 0 // seti 0 4 5
7 mem[4] = mem[5] | 65536 // bori 5 65536 4
8 mem[5] = 15466939 // seti 15466939 9 5
9 mem[3] = mem[4] & 255 // bani 4 255 3
10 mem[5] += mem[3] // addr 5 3 5
11 mem[5] = mem[5] & 16777215 // bani 5 16777215 5
12 mem[5] *= 65899 // muli 5 65899 5
13 mem[5] = mem[5] & 16777215 // bani 5 16777215 5
14 mem[3] = 256 > mem[4] ? 1 : 0 // gtir 256 4 3
15 IP += mem[3] // addr 3 2 2
16 IP++ // addi 2 1 2
17 IP = 27 // seti 27 8 2
18 mem[3] = 0 // seti 0 7 3
19 mem[1] = mem[3] + 1 // addi 3 1 1
20 mem[1] *= 256 // muli 1 256 1
21 mem[1] = mem[1] > mem[4] ? 1 : 0 // gtrr 1 4 1
22 IP += mem[1] // addr 1 2 2
23 IP++ // addi 2 1 2
24 IP = 25 // seti 25 2 2
25 mem[3]++ // addi 3 1 3
26 IP = 17 // seti 17 7 2
27 mem[4] = mem[3] // setr 3 7 4
28 IP = 7 // seti 7 3 2
29 mem[3] = mem[5] === mem[0] ? 1 : 0 // eqrr 5 0 3
30 IP += mem[3] // addr 3 2 2
31 IP = 5 // seti 5 9 2
