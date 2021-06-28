//
//  SimulatorControlledMatrixAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/04/2021.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class SimulatorControlledMatrixAdapterTests: XCTestCase {

    // MARK: - Tests

    func testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException() {
        // Given
        let controlledMatrix = Matrix.makeNot()
        let controlCount = 1
        let truthTable = [try! TruthTableEntry(repeating: "1", count: controlCount)]
        let sut = SimulatorControlledMatrixAdapter(truthTable: truthTable,
                                                   controlCount: controlCount,
                                                   controlledCountableMatrix: controlledMatrix)

        // Then
        var error: ExpandedRawMatrixError?
        if case .failure(let e) = sut.expandedOracleMatrix().expandedRawMatrix(maxConcurrency: 0) {
            error = e
        }
        XCTAssertEqual(error, .passMaxConcurrencyBiggerThanZero)
    }

    func testNotMatrixAndControlCountToOne_expandedRawMatrix_returnExpectedMatrix() {
        // Given
        let controlledMatrix = Matrix.makeNot()
        let controlCount = 1
        let truthTable = [try! TruthTableEntry(repeating: "1", count: controlCount)]
        let sut = SimulatorControlledMatrixAdapter(truthTable: truthTable,
                                                   controlCount: controlCount,
                                                   controlledCountableMatrix: controlledMatrix)

        // Then
        XCTAssertEqual(try? sut.expandedOracleMatrix().expandedRawMatrix(maxConcurrency: 1).get(),
                       Matrix.makeControlledNot())
    }

    static var allTests = [
        ("testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException",
         testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException),
        ("testNotMatrixAndControlCountToOne_expandedRawMatrix_returnExpectedMatrix",
         testNotMatrixAndControlCountToOne_expandedRawMatrix_returnExpectedMatrix)
    ]
}
