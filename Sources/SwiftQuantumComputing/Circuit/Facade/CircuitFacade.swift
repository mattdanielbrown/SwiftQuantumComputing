//
//  CircuitFacade.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

struct CircuitFacade {

    // MARK: - Circuit properties

    let gates: [FixedGate]

    // MARK: - Private properties

    private let statevectorSimulator: StatevectorSimulator

    // MARK: - Internal init methods

    init(gates: [FixedGate], statevectorSimulator: StatevectorSimulator) {
        self.gates = gates
        self.statevectorSimulator = statevectorSimulator
    }
}

// MARK: - CustomStringConvertible methods

extension CircuitFacade: CustomStringConvertible {
    var description: String {
        return gates.description
    }
}

// MARK: - Circuit methods

extension CircuitFacade: Circuit {
    func statevector(afterInputting bits: String) throws -> [Complex] {
        let state = try statevectorSimulator.statevector(afterInputting: bits, in: gates)

        return state.elements()
    }
}
