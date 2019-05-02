//
//  CircuitFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 14/02/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class CircuitFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeCircuitCount = 0
    private (set) var lastMakeCircuitQubitCount: Int?
    private (set) var lastMakeCircuitGates: [FixedGate]?
    var makeCircuitResult: Circuit?
}

// MARK: - CircuitFactory methods

extension CircuitFactoryTestDouble: CircuitFactory {
    func makeCircuit(qubitCount: Int, gates: [FixedGate]) throws -> Circuit {
        makeCircuitCount += 1

        lastMakeCircuitQubitCount = qubitCount
        lastMakeCircuitGates = gates

        if let makeCircuitResult = makeCircuitResult {
            return makeCircuitResult
        }

        throw MakeCircuitError.qubitCountHasToBeBiggerThanZero
    }
}
