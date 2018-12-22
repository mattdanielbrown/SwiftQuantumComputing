//
//  CircuitFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/08/2018.
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
import os.log

// MARK: - Main body

public struct CircuitFactory {

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Public class methods

    public static func makeEmptyCircuit(qubitCount: Int) -> Circuit? {
        guard let register = Register(qubitCount: qubitCount) else {
            os_log("makeEmptyCircuit failed: unable to build initial register",
                   log: logger,
                   type: .debug)

            return nil
        }

        guard let drawer = CircuitViewDrawer(qubitCount: qubitCount) else {
            os_log("makeEmptyCircuit failed: unable to build circuit drawer",
                   log: logger,
                   type: .debug)

            return nil
        }

        let factory = BackendRegisterGateFactoryAdapter(qubitCount: qubitCount)
        let backend = BackendFacade(initialRegister: register, factory: factory)

        return CircuitFacade(circuit: [], drawer: drawer, qubitCount: qubitCount, backend: backend)
    }

    public static func makeRandomlyGeneratedCircuit(qubitCount: Int,
                                                    depth: Int,
                                                    factories: [CircuitGateFactory]) -> Circuit? {
        let emptyCircuit = makeEmptyCircuit(qubitCount: qubitCount)

        return emptyCircuit?.randomlyApplyingFactories(factories, depth: depth)
    }
}
