//
//  FixedOracleGate+SimulatorControlledMatrixExtracting.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/02/2021.
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

// MARK: - SimulatorControlledMatrixExtracting methods

extension FixedOracleGate: SimulatorControlledMatrixExtracting {
    func extractControlledMatrix() -> Result<SimulatorControlledMatrix, GateError> {
        guard !controls.isEmpty else {
            return .failure(.gateControlsCanNotBeAnEmptyList)
        }

        switch gate.extractControlledMatrix() {
        case .failure(let error):
            return .failure(error)
        case .success(let controlledMatrix):
            return .success(OracleSimulatorMatrix(truthTable: truthTable,
                                                  controlCount: controls.count,
                                                  controlledMatrix: controlledMatrix.expandedMatrix()))
        }
    }
}
