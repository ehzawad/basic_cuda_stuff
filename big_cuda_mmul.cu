#include <iostream>
#include <chrono>
#include <cuda_runtime.h>

#define N 1000

__global__ void multiply(int* A, int* B, int* C) {
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int col = blockIdx.x * blockDim.x + threadIdx.x;

  int sum = 0;
  for (int k = 0; k < N; k++) {
    sum += A[row * N + k] * B[k * N + col];
  }

  C[row * N + col] = sum;
}

int main() {
  int *A, *B, *C;
  cudaMallocManaged(&A, N * N * sizeof(int));
  cudaMallocManaged(&B, N * N * sizeof(int));
  cudaMallocManaged(&C, N * N * sizeof(int));

  for (int i = 0; i < N * N; i++) {
    A[i] = 2;
    B[i] = 3;
  }

  auto start = std::chrono::high_resolution_clock::now();

  dim3 threadsPerBlock(16, 16);
  dim3 numBlocks((N + threadsPerBlock.x - 1) / threadsPerBlock.x, (N + threadsPerBlock.y - 1) / threadsPerBlock.y);

  multiply<<<numBlocks, threadsPerBlock>>>(A, B, C);
  cudaDeviceSynchronize();

  auto stop = std::chrono::high_resolution_clock::now();
  auto duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start);

  std::cout << "Time taken by GPU: " << duration.count() << " microseconds" << std::endl;

  cudaFree(A);
  cudaFree(B);
  cudaFree(C);

  return 0;
}
