//
//  LigandCIFParser.swift
//  DomainProteins
//
//  Created by Chan on 9/28/26.
//

import Foundation

import DomainProteinsInterface

/// RCSB Chemical Component Dictionary 형식의 .cif 텍스트를 `Ligand`로 변환한다.
/// `_chem_comp_atom`(원자)과 `_chem_comp_bond`(결합) 카테고리만 사용한다.
public struct LigandCIFParser {

    public init() {}

    public func parse(_ text: String) throws -> Ligand {
        let document = try CIFDocument(text: text)

        guard let atomTable = document.table(named: "_chem_comp_atom"),
              let nameColumn = atomTable.column("atom_id"),
              let elementColumn = atomTable.column("type_symbol") else {
            throw LigandError.parsingFailed
        }

        var atoms: [Atom] = []
        var atomIndexByName: [String: Int] = [:]

        for row in atomTable.rows {
            // ideal 좌표가 없는 리간드도 있어서 실험 좌표(model)로 대체한다.
            guard let position = Self.position(in: row, of: atomTable, suffix: "_ideal", prefix: "pdbx_model_cartn_")
                    ?? Self.position(in: row, of: atomTable, suffix: "", prefix: "model_cartn_") else {
                continue
            }

            let name = row[nameColumn]
            atomIndexByName[name] = atoms.count
            atoms.append(Atom(name: name, element: Self.normalizedElement(row[elementColumn]), position: position))
        }

        guard !atoms.isEmpty else {
            throw LigandError.parsingFailed
        }

        // 원자가 하나뿐인 리간드(ZN, CA 등)에는 결합 카테고리가 없다.
        var bonds: [Bond] = []
        if let bondTable = document.table(named: "_chem_comp_bond"),
           let firstColumn = bondTable.column("atom_id_1"),
           let secondColumn = bondTable.column("atom_id_2") {
            let orderColumn = bondTable.column("value_order")

            for row in bondTable.rows {
                guard let index1 = atomIndexByName[row[firstColumn]],
                      let index2 = atomIndexByName[row[secondColumn]] else {
                    continue
                }
                let order = orderColumn.map { Self.bondOrder(row[$0]) } ?? .single
                bonds.append(Bond(atomIndex1: index1, atomIndex2: index2, order: order))
            }
        }

        let identifier = document.table(named: "_chem_comp")?.firstValue(of: "id")
            ?? atomTable.firstValue(of: "comp_id")
            ?? ""

        return Ligand(identifier: identifier, atoms: atoms, bonds: bonds)
    }

    private static func position(in row: [String], of table: CIFTable, suffix: String, prefix: String) -> SIMD3<Float>? {
        guard let xColumn = table.column(prefix + "x" + suffix),
              let yColumn = table.column(prefix + "y" + suffix),
              let zColumn = table.column(prefix + "z" + suffix),
              let x = Float(row[xColumn]), x.isFinite,
              let y = Float(row[yColumn]), y.isFinite,
              let z = Float(row[zColumn]), z.isFinite else {
            return nil
        }
        return SIMD3(x, y, z)
    }

    /// "CL" -> "Cl", "FE" -> "Fe"
    private static func normalizedElement(_ symbol: String) -> String {
        guard let first = symbol.first else { return symbol }
        return first.uppercased() + symbol.dropFirst().lowercased()
    }

    private static func bondOrder(_ value: String) -> Bond.Order {
        switch value.uppercased() {
        case "SING": return .single
        case "DOUB": return .double
        case "TRIP": return .triple
        case "AROM": return .aromatic
        default: return .other
        }
    }
}

// MARK: - CIF 문법

/// 하나의 카테고리(예: `_chem_comp_atom`)에 해당하는 표.
/// `loop_`이 없는 키-값 형식은 한 행짜리 표로 다룬다.
struct CIFTable {
    private(set) var columns: [String] = []
    private(set) var rows: [[String]] = []

    func column(_ name: String) -> Int? {
        columns.firstIndex(of: name)
    }

    func firstValue(of name: String) -> String? {
        guard let index = column(name), let row = rows.first else { return nil }
        let value = row[index]
        return value == "?" || value == "." ? nil : value
    }

    mutating func appendPair(column: String, value: String) {
        if rows.isEmpty {
            rows.append([])
        }
        columns.append(column)
        rows[0].append(value)
    }

    init() {}

    init(columns: [String], values: [String]) {
        self.columns = columns
        self.rows = stride(from: 0, to: values.count, by: columns.count).map {
            Array(values[$0..<$0 + columns.count])
        }
    }
}

struct CIFDocument {
    private var tables: [String: CIFTable] = [:]

    func table(named name: String) -> CIFTable? {
        tables[name]
    }

    init(text: String) throws {
        let tokens = try CIFTokenizer.tokenize(text)
        var index = 0

        while index < tokens.count {
            switch tokens[index] {
            case .dataBlock:
                index += 1

            case .loop:
                index += 1
                var tags: [String] = []
                while index < tokens.count, case .tag(let tag) = tokens[index] {
                    tags.append(tag)
                    index += 1
                }
                var values: [String] = []
                while index < tokens.count, case .value(let value) = tokens[index] {
                    values.append(value)
                    index += 1
                }

                let split = tags.map(Self.split)
                guard let category = split.first?.category,
                      split.allSatisfy({ $0.category == category }),
                      values.count % tags.count == 0 else {
                    throw LigandError.parsingFailed
                }
                tables[category] = CIFTable(columns: split.map(\.field), values: values)

            case .tag(let tag):
                guard index + 1 < tokens.count, case .value(let value) = tokens[index + 1] else {
                    throw LigandError.parsingFailed
                }
                let (category, field) = Self.split(tag)
                tables[category, default: CIFTable()].appendPair(column: field, value: value)
                index += 2

            case .value:
                throw LigandError.parsingFailed
            }
        }
    }

    /// "_chem_comp_atom.type_symbol" -> ("_chem_comp_atom", "type_symbol")
    /// CIF의 태그는 대소문자를 구분하지 않으므로 소문자로 맞춘다.
    private static func split(_ tag: String) -> (category: String, field: String) {
        let lowercased = tag.lowercased()
        guard let dot = lowercased.firstIndex(of: ".") else {
            return (lowercased, "")
        }
        return (String(lowercased[..<dot]), String(lowercased[lowercased.index(after: dot)...]))
    }
}

enum CIFToken: Equatable {
    case dataBlock
    case loop
    case tag(String)
    case value(String)
}

enum CIFTokenizer {
    static func tokenize(_ text: String) throws -> [CIFToken] {
        let lines = text.components(separatedBy: .newlines)
        var tokens: [CIFToken] = []
        var lineIndex = 0

        while lineIndex < lines.count {
            let line = lines[lineIndex]

            // 줄 맨 앞의 ';'부터 다음 ';' 줄까지는 여러 줄짜리 값이다.
            if line.hasPrefix(";") {
                var textLines = [String(line.dropFirst())]
                lineIndex += 1
                while lineIndex < lines.count, !lines[lineIndex].hasPrefix(";") {
                    textLines.append(lines[lineIndex])
                    lineIndex += 1
                }
                guard lineIndex < lines.count else {
                    throw LigandError.parsingFailed
                }
                tokens.append(.value(textLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)))
                tokens += try tokenize(line: String(lines[lineIndex].dropFirst()))
                lineIndex += 1
                continue
            }

            tokens += try tokenize(line: line)
            lineIndex += 1
        }

        return tokens
    }

    private static func tokenize(line: String) throws -> [CIFToken] {
        let characters = Array(line)
        var tokens: [CIFToken] = []
        var position = 0

        while position < characters.count {
            let character = characters[position]

            if character.isWhitespace {
                position += 1
                continue
            }

            if character == "#" {
                break
            }

            // 따옴표 값은 같은 따옴표 뒤에 공백이나 줄 끝이 올 때 끝난다. 예: "O5'"
            if character == "'" || character == "\"" {
                var end = position + 1
                while end < characters.count {
                    if characters[end] == character, end + 1 == characters.count || characters[end + 1].isWhitespace {
                        break
                    }
                    end += 1
                }
                guard end < characters.count else {
                    throw LigandError.parsingFailed
                }
                tokens.append(.value(String(characters[(position + 1)..<end])))
                position = end + 1
                continue
            }

            var end = position
            while end < characters.count, !characters[end].isWhitespace {
                end += 1
            }
            let word = String(characters[position..<end])
            position = end

            let lowercased = word.lowercased()
            if lowercased.hasPrefix("data_") {
                tokens.append(.dataBlock)
            } else if lowercased == "loop_" {
                tokens.append(.loop)
            } else if word.hasPrefix("_") {
                tokens.append(.tag(word))
            } else {
                tokens.append(.value(word))
            }
        }

        return tokens
    }
}
