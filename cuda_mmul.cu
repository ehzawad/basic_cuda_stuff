#include <cstdio>
#include <iostream>
#include <chrono>

#define X 3
#define Y 6
#define Z 10

__global__ void multiplyMatrices(int *a, int *b, int *c) {
  int x = blockIdx.x;
  int y = blockIdx.y;
  int z = threadIdx.x;

  c[x * Y * Z + y * Z + z] = a[x * Y * Z + y * Z + z] * b[x * Y * Z + y * Z + z];
}

int main() {
  int a[X * Y * Z];
  int b[X * Y * Z];
  int c[X * Y * Z];

  for(int i = 0; i < X * Y * Z; i++) {
    a[i] = i + 1;
    b[i] = i + 1;
  }

  int *d_a, *d_b, *d_c;
  cudaMalloc(&d_a, X * Y * Z * sizeof(int));
  cudaMalloc(&d_b, X * Y * Z * sizeof(int));
  cudaMalloc(&d_c, X * Y * Z * sizeof(int));

  cudaMemcpy(d_a, a, X * Y * Z * sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, b, X * Y * Z * sizeof(int), cudaMemcpyHostToDevice);

  dim3 blocks(X, Y);
  dim3 threads(Z);

  auto start = std::chrono::high_resolution_clock::now();
  multiplyMatrices<<<blocks, threads>>>(d_a, d_b, d_c);
  cudaDeviceSynchronize();
  auto end = std::chrono::high_resolution_clock::now();

  cudaMemcpy(c, d_c, X * Y * Z * sizeof(int), cudaMemcpyDeviceToHost);

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  // Print result
  printf("Result (3D Matrix):\n");
  for (int x = 0; x < X; x++) {
    for (int y = 0; y < Y; y++) {
      for (int z = 0; z < Z; z++) {
        printf("%d ", c[x * Y * Z + y * Z + z]);
      }
      printf("\n");
    }
    printf("\n");
  }

  auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
  std::cout << "Execution Time (CUDA): " << duration.count() << " microseconds\n";
}

