//
//  StatevectorRegisterAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/05/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

// MARK: - Main body

struct StatevectorRegisterAdapter {

    // MARK: - Private properties

    private let qubitCount: Int
    private let vector: Vector
    private let transformation: StatevectorTransformation

    // MARK: - Internal init methods

    enum InitError: Error {
        case vectorCountHasToBeAPowerOfTwo
    }

    init(vector: Vector, transformation: StatevectorTransformation) throws {
        guard vector.count.isPowerOfTwo else {
            throw InitError.vectorCountHasToBeAPowerOfTwo
        }

        qubitCount = Int.log2(vector.count)
        self.vector = vector
        self.transformation = transformation
    }
}

// MARK: - StatevectorRegister methods

extension StatevectorRegisterAdapter: StatevectorRegister {
    func measure() -> Vector {
        return vector
    }

    func applying(_ gate: SimulatorGate) -> Result<StatevectorRegister, GateError> {
        switch gate.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
        case .success((let matrix, _, let inputs)):
            let nextVector = transformation.apply(gateMatrix: matrix,
                                                  toStatevector: vector,
                                                  atInputs: inputs)
            let adapter = try! StatevectorRegisterAdapter(vector: nextVector,
                                                          transformation: transformation)
            return .success(adapter)
        case .failure(let error):
            return .failure(error)
        }
    }
}
