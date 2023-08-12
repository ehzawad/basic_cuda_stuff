kernel void matrix_multiplication(constant float3x3 *matrix1 [[ buffer(0) ]],
                                   constant float3x3 *matrix2 [[ buffer(1) ]],
                                   device float3x3 *result [[ buffer(2) ]],
                                   uint id [[ thread_position_in_grid ]]) {
    uint row = id / 3;
    uint col = id % 3;

    result[id] = 0.0f;
    for (uint i = 0; i < 3; ++i) {
        result[id] += matrix1[row][i] * matrix2[i][col];
    }
}
