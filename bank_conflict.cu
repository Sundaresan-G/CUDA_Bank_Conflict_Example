#include <iostream>

#define N 2

#define number int

using namespace std;

__global__ void add(number *a){
    __shared__ number sharedA[N + 2048];
    // __shared__ number sharedB[N + 2048];

    unsigned int index = blockDim.x * blockIdx.x + threadIdx.x;   

    int stride = 0;

    if (index != 0)
        stride = index*32 - index%32;

    // if (index %2 == 0)
    //     stride = 33;
    // else 
    //     stride = 0;
    sharedA[index + stride] = index;

    // for (stride = 1; stride < 66; stride++)  
    // sharedA[index+stride] = index+stride;  
    // sharedA[index + 1] = sharedA[index + 1 + stride];

    // if (index + stride < N)
    //     sharedA[index] = sharedA[index] + sharedA[index + stride];

    __syncthreads();

    if (index == 0){
        // if (sharedB[0] == 'c')
        *a = sharedA[index];
    }
    
}

int main(){

    number *da, a=0;

    cudaMalloc((void **)&da, sizeof(number));

    int num_threads = N;

    add<<<1, num_threads>>>(da);  

    cudaMemcpy(&a, da, sizeof(number), cudaMemcpyDeviceToHost);

    cout << a << endl;

}