# This program is to simulate the effects of Shared Memory Bank conflicts in CUDA for Float

Compilation using : (change arch= based on GPU)
```bash
nvcc -arch=sm_70 bank_conflict.cu
```

Run and test it using :
```bash 
ncu --metrics=l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum,l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum,l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum,l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum,smsp__inst_executed_op_shared_ld.sum,smsp__inst_executed_op_shared_st.sum a.out
```

Or just use 
```bash
./a.out
```
