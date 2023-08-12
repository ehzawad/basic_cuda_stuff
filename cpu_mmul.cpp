#include <iostream>
#include <chrono>

#define X 3
#define Y 6
#define Z 10

int main() {
  int a[X][Y][Z];
  int b[X][Y][Z];
  int c[X][Y][Z];

  for(int x = 0; x < X; x++) {
    for(int y = 0; y < Y; y++) {
      for(int z = 0; z < Z; z++) {
        a[x][y][z] = x * Y * Z + y * Z + z + 1;
        b[x][y][z] = x * Y * Z + y * Z + z + 1;
      }
    }
  }

  auto start = std::chrono::high_resolution_clock::now();
  for(int x = 0; x < X; x++) {
    for(int y = 0; y < Y; y++) {
      for(int z = 0; z < Z; z++) {
        c[x][y][z] = a[x][y][z] * b[x][y][z];
      }
    }
  }
  auto end = std::chrono::high_resolution_clock::now();

  // Print result
  std::cout << "Result (3D Matrix):\n";
  for (int x = 0; x < X; x++) {
    for (int y = 0; y < Y; y++) {
      for (int z = 0; z < Z; z++) {
        std::cout << c[x][y][z] << " ";
      }
      std::cout << "\n";
    }
    std::cout << "\n";
  }

  auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
  std::cout << "Execution Time (C++11): " << duration.count() << " microseconds\n";
}
