//
//  File.swift
//  
//
//  Created by Alfredo Cadiz on 21.05.20.
//

import Foundation

public protocol WinningTerritoryCalculator {
    func winningTerritory(in world: World) -> Territory?
}
