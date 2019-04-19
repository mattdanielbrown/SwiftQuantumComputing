//
//  MainGeneticFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/02/2019.
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
import os.log

// MARK: - Main body

public struct MainGeneticFactory {

    // MARK: - Private properties

    private let initialPopulationFactory: InitialPopulationProducerFactory
    private let fitness: Fitness
    private let reproductionFactory: GeneticPopulationReproductionFactory
    private let oracleFactory: OracleCircuitFactory

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Public init methods

    public init() {
        let generatorFactory = MainGeneticGatesRandomizerFactory()
        let circuitFactory = MainCircuitFactory()
        let oracleFactory = MainOracleCircuitFactory()
        let useCaseEvaluatorFactory = MainGeneticUseCaseEvaluatorFactory(factory: circuitFactory,
                                                                         oracleFactory:oracleFactory)
        let evaluatorFactory = MainGeneticCircuitEvaluatorFactory(factory: useCaseEvaluatorFactory)
        let score = MainGeneticCircuitScore()
        let producerFactory = MainInitialPopulationProducerFactory(generatorFactory: generatorFactory,
                                                                   evaluatorFactory: evaluatorFactory,
                                                                   score: score)

        let fitness = MainFitness()
        let circuitCrossover = MainGeneticCircuitCrossover()
        let crossoverFactory = MainGeneticPopulationCrossoverFactory(fitness: fitness,
                                                                     crossover: circuitCrossover,
                                                                     score: score)
        let circuitMutationFactory = MainGeneticCircuitMutationFactory(factory: generatorFactory)
        let mutationFactory = MainGeneticPopulationMutationFactory(fitness: fitness,
                                                                   factory: circuitMutationFactory,
                                                                   score: score)
        let reproductionFactory = MainGeneticPopulationReproductionFactory(evaluatorFactory: evaluatorFactory,
                                                                           crossoverFactory: crossoverFactory,
                                                                           mutationFactory: mutationFactory)

        self.init(initialPopulationFactory: producerFactory,
                  fitness: fitness,
                  reproductionFactory: reproductionFactory,
                  oracleFactory: oracleFactory)
    }

    // MARK: - Internal init methods

    init(initialPopulationFactory: InitialPopulationProducerFactory,
         fitness: Fitness,
         reproductionFactory: GeneticPopulationReproductionFactory,
         oracleFactory: OracleCircuitFactory) {
        self.initialPopulationFactory = initialPopulationFactory
        self.fitness = fitness
        self.reproductionFactory = reproductionFactory
        self.oracleFactory = oracleFactory
    }
}


// MARK: - GeneticFactory methods

extension MainGeneticFactory: GeneticFactory {
    public func evolveCircuit(configuration config: GeneticConfiguration,
                              useCases: [GeneticUseCase],
                              gates: [Gate]) -> EvolvedCircuit? {
        guard let initSize = config.populationSize.first else {
            os_log("evolveCircuit: pop. size empty", log: MainGeneticFactory.logger, type: .debug)

            return nil
        }
        let maxSize = config.populationSize.last!

        guard let maxDepth = config.depth.last else {
            os_log("evolveCircuit: depth empty", log: MainGeneticFactory.logger, type: .debug)

            return nil
        }

        guard let firstCase = useCases.first else {
            os_log("evolveCircuit: use cases empty", log: MainGeneticFactory.logger, type: .debug)

            return nil
        }

        let qubitCount = firstCase.circuit.qubitCount
        guard useCases.reduce(true, { $0 && $1.circuit.qubitCount == qubitCount })  else {
            os_log("evolveCircuit: use cases do not specify same circuit qubit count",
                   log: MainGeneticFactory.logger,
                   type: .debug)

            return nil
        }

        guard let initialPopulation = initialPopulationFactory.makeProducer(qubitCount: qubitCount,
                                                                            threshold: config.threshold,
                                                                            useCases: useCases,
                                                                            gates: gates) else {
                                                                                return nil
        }

        guard let reproduction = reproductionFactory.makeReproduction(qubitCount: qubitCount,
                                                                      tournamentSize: config.tournamentSize,
                                                                      mutationProbability: config.mutationProbability,
                                                                      threshold: config.threshold,
                                                                      maxDepth: maxDepth,
                                                                      useCases: useCases,
                                                                      gates: gates) else {
                                                                        return nil
        }

        os_log("Producing initial population...", log: MainGeneticFactory.logger, type: .info)
        guard var population = try? initialPopulation.execute(size: initSize, depth: config.depth) else {
            return nil
        }
        os_log("Initial population completed", log: MainGeneticFactory.logger, type: .info)

        guard var candidate = fitness.fittest(in: population) else {
            os_log("evolveCircuit: no first candid.", log: MainGeneticFactory.logger, type: .debug)

            return nil
        }

        var currGen = 0
        let errProb = config.errorProbability
        let genCount = config.generationCount
        while (candidate.eval > errProb) && (currGen < genCount) && (population.count < maxSize) {
            os_log("Init. generation %d...", log: MainGeneticFactory.logger, type: .info, currGen)

            let offspring = reproduction.applied(to: population)
            if (offspring.isEmpty) {
                os_log("evolveCircuit: empty offspr.", log: MainGeneticFactory.logger, type: .debug)
            } else {
                population.append(contentsOf: offspring)
                candidate = fitness.fittest(in: population)!
            }

            os_log("Generation %d completed. Population: %d. Evaluation: %s",
                   log: MainGeneticFactory.logger,
                   type: .info,
                   currGen, population.count, String(candidate.eval))

            currGen += 1
        }

        guard let circuit = try? oracleFactory.makeOracleCircuit(geneticCircuit: candidate.circuit,
                                                                 useCase: firstCase) else {
                                                                    return nil
        }

        return (candidate.eval, circuit.circuit, circuit.oracleAt)
    }
}
