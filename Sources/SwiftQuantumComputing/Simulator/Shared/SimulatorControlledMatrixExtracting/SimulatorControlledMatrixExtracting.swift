//
//  SimulatorControlledMatrixExtracting.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/04/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

// MARK: - Protocol definition

protocol SimulatorControlledMatrixExtracting {
    func extractControlledMatrix() -> Result<SimulatorControlledMatrix, GateError>
}

// MARK: - SimulatorControlledMatrixExtracting default implementations

extension SimulatorControlledMatrixExtracting where Self: RawSimulatorMatrixFactory {
    func extractControlledMatrix() -> Result<SimulatorControlledMatrix, GateError> {
        switch makeRawMatrix() {
        case .success(let matrix):
            return .success(matrix)
        case .failure(let error):
            return .failure(error)
        }
    }
}


extension SimulatorControlledMatrixExtracting where Self: SimulatorControlledMatrixAdapterFactory {
    func extractControlledMatrix() -> Result<SimulatorControlledMatrix, GateError> {
        switch makeControlledMatrixAdapter() {
        case .success(let adapter):
            return .success(adapter)
        case .failure(let error):
            return .failure(error)
        }
    }
}
