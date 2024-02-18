## This program is to simulate the effects of Shared Memory Bank conflicts in CUDA for both float and double

Double does not show bank conflict for a simple program as it proceeds as half-warp.

However, the given program in this ensures that in double too, bank conflict occurs.

Compilation using : 
```bash
nvcc -arch=sm_70 -g -lineinfo bank_conflict.cu
```

Run and test it using :
```bash 
ncu --metrics=l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum,l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum,l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum,l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum,smsp__inst_executed_op_shared_ld.sum,smsp__inst_executed_op_shared_st.sum a.out
```
