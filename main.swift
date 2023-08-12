import Metal

func multiplyMatrices() {
    guard let device = MTLCreateSystemDefaultDevice(),
          let commandQueue = device.makeCommandQueue(),
          let library = device.makeDefaultLibrary(),
          let function = library.makeFunction(name: "matrix_multiplication"),
          let pipelineState = try? device.makeComputePipelineState(function: function)
    else { return }

    let matrix1: matrix_float3x3 = [ [1, 2, 3], [4, 5, 6], [7, 8, 9] ]
    let matrix2: matrix_float3x3 = [ [3, 6, 9], [2, 5, 8], [1, 4, 7] ]
    var resultMatrix = matrix_float3x3()

    let buffer1 = device.makeBuffer(bytes: &matrix1, length: MemoryLayout<matrix_float3x3>.stride, options: [])
    let buffer2 = device.makeBuffer(bytes: &matrix2, length: MemoryLayout<matrix_float3x3>.stride, options: [])
    let bufferResult = device.makeBuffer(bytes: &resultMatrix, length: MemoryLayout<matrix_float3x3>.stride, options: [.storageModeShared])

    let commandBuffer = commandQueue.makeCommandBuffer()!
    let commandEncoder = commandBuffer.makeComputeCommandEncoder()!

    commandEncoder.setComputePipelineState(pipelineState)
    commandEncoder.setBuffer(buffer1, offset: 0, index: 0)
    commandEncoder.setBuffer(buffer2, offset: 0, index: 1)
    commandEncoder.setBuffer(bufferResult, offset: 0, index: 2)
    commandEncoder.dispatchThreads(MTLSize(width: 3, height: 3, depth: 1), threadsPerThreadgroup: MTLSize(width: 1, height: 1, depth: 1))

    commandEncoder.endEncoding()
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()

    let pointer = bufferResult!.contents().bindMemory(to: matrix_float3x3.self, capacity: 1)
    resultMatrix = pointer.pointee

    print("Result Matrix:")
    for i in 0..<3 {
        for j in 0..<3 {
            print(resultMatrix[i][j], terminator: " ")
        }
        print()
    }
}

// Call the function
multiplyMatrices()
