//
//  NotGateFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre (dev) on 21/12/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
//

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class NotGateFactoryTests: XCTestCase {

    // MARK: - Properties

    let factory = NotGateFactory()

    // MARK: - Tests

    func testAnyFactoryAndZeroInputs_makeGate_returnNil() {
        // Then
        XCTAssertNil(factory.makeGate(inputs: []))
    }

    func testAnyFactoryAndTwoInputs_makeGate_returnExpectedGate() {
        // Given
        let inputs = [0, 1]

        // When
        guard let result = factory.makeGate(inputs: inputs) else {
            XCTAssert(false)

            return
        }

        // Then
        switch result {
        case let .not(target):
            XCTAssertEqual(inputs[0], target)
        default:
            XCTAssert(false)
        }
    }
}
