//
//  StatevectorTimeEvolutionFactoryAdapterTests.swift
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class StatevectorTimeEvolutionFactoryAdapterTests: XCTestCase {

    // MARK: - Properties

    let transformation = StatevectorTransformationTestDouble()

    // MARK: - Tests

    func testAnyCircuitStateVector_makeTimeEvolution_returnValue() {
        // Given
        let adapter = StatevectorTimeEvolutionFactoryAdapter(transformation: transformation)

        let vector = try! Vector([.zero, .zero, .zero, .one])
        let statevector = try! CircuitStatevectorAdapter(statevector: vector)

        // When
        let register = adapter.makeTimeEvolution(state: statevector)

        // Then
        XCTAssertEqual(register.state, vector)
    }

    static var allTests = [
        ("testAnyCircuitStateVector_makeTimeEvolution_returnValue",
         testAnyCircuitStateVector_makeTimeEvolution_returnValue)
    ]
}
