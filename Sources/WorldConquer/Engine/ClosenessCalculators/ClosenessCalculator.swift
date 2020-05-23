//
//  File.swift
//  
//
//  Created by Alfredo Cadiz on 20.05.20.
//

import Foundation

protocol ClosenessCalculator {
    func getRandomCloseTerritory(for territory: Territory, in world: World) -> Territory?
}
