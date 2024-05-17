
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include "kernel.h"

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

__global__ void addKernel(Coords* c, const Coords* a, const Coords* b, float t, int numParticulas)
{
    const float G = 0.00001f;
    vec2 sum = vec2(0, 0);
    int i = threadIdx.x;
    for (int j = 0; j < i; ++j) {
        float d = length(a[j] - a[i]);
        if (d >= 0.01f) sum += (G / (d * d * d)) * (a[j] - a[i]);
    }
    for (int j = i + 1; j < numParticulas; ++j) {
        float d = length(a[j] - a[i]);
        if (d >= 0.01f) sum += (G / (d * d * d)) * (a[j] - a[i]);
    }

    c[i] = a[i] + a[i] - b[i] + (t * t) * sum;

}

// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size)
{
    cudaError_t cudaStatus;

    // Launch a kernel on the GPU with one thread for each element.
   // ------------------> USAR ESTO addKernel<<<1, size>>>(dev_c, dev_a, dev_b);

    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    
    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    // ------------------> USAR ESTO cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

Error:
    
    return cudaStatus;
}

void Kernel::kernel()
{

}

void Kernel::CUDAliberar()
{
    cudaError_t cudaStatus;
    cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
    }

}

void Kernel::CUDASimular(Coords* coordsPrevias, Coords* coords, Coords* coordsSiguientes, int numParticulas, float pasoT)
{
    Coords* dev_previas = 0;
    Coords* dev_coords = 0;
    Coords* dev_siguientes = 0;
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_siguientes, numParticulas * sizeof(Coords));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_previas, numParticulas * sizeof(Coords));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_coords, numParticulas * sizeof(Coords));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_previas, coordsPrevias, numParticulas * sizeof(Coords), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_coords, coords, numParticulas * sizeof(Coords), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    addKernel <<<1, numParticulas >>> (dev_siguientes, dev_coords, dev_previas, pasoT, numParticulas);
    cudaStatus = cudaMemcpy(coordsSiguientes, dev_siguientes, numParticulas * sizeof(Coords), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }


Error:
    cudaFree(dev_siguientes);
    cudaFree(dev_coords);
    cudaFree(dev_previas);

}
