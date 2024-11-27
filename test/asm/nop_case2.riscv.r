li t0, 10      # t0 = 10
li t1, 15      # t1 = 15
li t2, 20      # t2 = 20
add t3, t0, t1 # t3 = t0 + t1 (t3 = 10 + 15 = 25)
sub t4, t3, t2 # t4 = t3 - t2 (RAW hazard t3)
and t5, t4, t1 # t5 = t4 AND t1 (RAW hazard t4)
add t6, t5, t0 # t6 = t5 + t0 (RAW hazard t5)
addi t5, t6, 3 # t5 = t6 + 3 (RAW hazard t6)
xor t3, t5, t0 # t3 = t5 XOR t0 (RAW hazard t5)
slli t4, t3, 2 # t4 = t3 << 2 (RAW hazard t3)
srai t6, t4, 1 # t6 = t4 >> 1 (RAW hazard t4)

sw t6, 0x0000(x0)       # Lưu t6 vào địa chỉ của x (RAW hazard với t6)

