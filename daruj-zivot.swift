#!/usr/bin/swift

//
//  daruj-zivot.swift
//  Created by Jakub Marek on 10/07/2019.
//
//  Zadání
//
//  Vaším úkolem je napsat program, který vypočítá následující generace hry života, jejíž tajemství poprvé objevil prof. Conway (Conway's Game of Life).
//  Začínáme s dvoudimenzionální mřížkou buňek. Každá buňka může být buďto živá nebo mrtvá. Mřížka je konečná a mimo její hranice neexistuje žádný život.
//
//  Další generaci mřížky vypočítáme podle následujících pravidel:
//
//    - Pokud má živá buňka méně než dva sousedy, umírá v osamění.
//    - Pokud má živá buňka více než 3 sousedy, umírá přeplněním.
//    - Pokud má živá buňka 2 nebo 3 sousedy, přežívá do další generace.
//    - Pokud má mrtvá buňka přesně 3 sousedy, v další generaci ožívá.
//    - Jako sousední buňky považujeme ty, které se nacházejí v osmiokolí dané buňky.
//

import Foundation

// MARK: Constants

typealias Grid = [[Character]]
let life: Character = "*"
let dead: Character = "."

struct Coordinates {
    let row: Int
    let column: Int
}

// MARK: Helper functions

func printGrid(grid: Grid) {
    for row in grid {
        for item in row {
            print(item, terminator: "")
        }
        print()
    }
}

func getCountOfNeighbours(for coordinates: Coordinates, in grid: Grid) -> Int {
    var neighboursCounter = 0
    for row in coordinates.row - 1...coordinates.row + 1 {
        if row < 0 || row >= grid.count { continue } // Check boundaries
        for column in coordinates.column - 1...coordinates.column + 1 {
            if column < 0 || column >= grid[0].count || (row == coordinates.row && column == coordinates.column) { continue } // Check boundaries & skip input coordinates
            if grid[row][column] == life {
                neighboursCounter += 1
            }
        }
    }
    return neighboursCounter
}

// MARK: Read input

guard CommandLine.argc == 2 else {
    print("Invalid input params (Use file location as the only parameter)")
    exit(0)
}

let filePath = CommandLine.arguments[1]
guard let fileContent = try? String(contentsOfFile: filePath) else {
    print("Invalid input file")
    exit(0)
}
let inputArray = fileContent.components(separatedBy: "\n") // Array of strings (one string per one file line)

var inputGrid = inputArray.map { Array($0) } // Split every string to array of chars => Grid
var helperGrid = inputGrid

// MARK: God section

func godMagic() { // God decides on life and death of every item in grid
    for row in 0...inputGrid.count - 1 {
        for column in 0...inputGrid[0].count - 1 {
            switch getCountOfNeighbours(for: Coordinates(row: row, column: column), in: inputGrid) {
            case let count where count < 2 || count > 3:
                helperGrid[row][column] = dead
            case let count where count == 3:
                helperGrid[row][column] = life
            default:
                break
            }
        }
    }
    inputGrid = helperGrid
}

// MARK: Task execution

print("Zygote")
printGrid(grid: inputGrid)
for generation in 1...10 {
    godMagic()
    print("Generation: \(generation)")
    printGrid(grid: inputGrid)
}
