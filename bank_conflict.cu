#include <iostream>

#define number float

constexpr int THREADS_PER_BLOCK=256;

constexpr size_t N = (size_t)8192*8192;

// Issue 1 to avoid all bank conflicts or 32 in case of int or float to get max bank conflicts
int OFFSET = 1;

using namespace std;

__global__ void bankConflictKernel(number *a, int OFFSET){
    extern __shared__ number sharedA[];
    // __shared__ number sharedB[N + 2048];

    size_t index = blockDim.x * blockIdx.x + threadIdx.x;   

    if (index >= N) return;

    int stride = threadIdx.x*OFFSET;

    // if (index != 0)
    //     stride = index*32 - index%32;

    // if (index %2 == 0)
    //     stride = 33;
    // else 
    //     stride = 0;
    sharedA[stride] = index;

    // for (stride = 1; stride < 66; stride++)  
    // sharedA[index+stride] = index+stride;  
    // sharedA[index + 1] = sharedA[index + 1 + stride];

    // if (index + stride < N)
    //     sharedA[index] = sharedA[index] + sharedA[index + stride];

    __syncthreads();

    // This is included so that compiler does not eliminate the dead code
    // if (index == 0){
    //     // if (sharedB[0] == 'c')
    //     *a = sharedA[index];
    // }

    a[index] = sharedA[stride];
    
}

int main(){

    number *da;

    cudaMalloc((void **)&da, sizeof(number) * N);

    size_t num_threads = THREADS_PER_BLOCK;

    size_t num_blocks = (N + num_threads - 1)/num_threads;

    // Warmup
    // 8 * sizeof(number) is 32 or 64 depending on float or double
    bankConflictKernel<<<num_blocks, num_threads, THREADS_PER_BLOCK * 8 * sizeof(number) * sizeof(number)>>>(da, OFFSET); 
    // cudaDeviceSynchronize();

    cudaEvent_t start, stop;

    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // cudaDeviceSynchronize();

    cout << "Total Elapsed time for " << N << " elements is \n";
    printf("Offset ElapsedTime\n");

    for (OFFSET = 1; OFFSET <= 32; OFFSET ++){

        cudaEventRecord(start, 0);
        bankConflictKernel<<<num_blocks, num_threads, THREADS_PER_BLOCK * 8 * sizeof(number) * sizeof(number)>>>(da, OFFSET);  
        cudaEventRecord(stop, 0);

        cudaEventSynchronize(stop);

        float elapsedTime = 0;

        cudaEventElapsedTime(&elapsedTime, start, stop);

        printf("%6d %10.8f\n", OFFSET, elapsedTime);

        // cout << "Total Elapsed time for " << N << " elements with offset " << OFFSET << " is "<<elapsedTime <<" ms\n";
    }

    return 0;

}