#include <iostream>
#include <chrono>
#include <vector>

int main() {
  const int N = 1000;
  std::vector<std::vector<int>> A(N, std::vector<int>(N, 2));
  std::vector<std::vector<int>> B(N, std::vector<int>(N, 3));
  std::vector<std::vector<int>> C(N, std::vector<int>(N, 0));

  auto start = std::chrono::high_resolution_clock::now();

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      for (int k = 0; k < N; k++) {
        C[i][j] += A[i][k] * B[k][j];
      }
    }
  }

  auto stop = std::chrono::high_resolution_clock::now();
  auto duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start);

  std::cout << "Time taken by CPU: " << duration.count() << " microseconds" << std::endl;

  return 0;
}
