import Foundation

public struct Matrix {
    let rows: Int, columns: Int
    var grid: [Int]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0, count: rows * columns)
    }
    
    init(_ array: [Int]) {
        self.rows = Int(sqrt(Double(array.count)))
        self.columns = self.rows
        self.grid = array
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    func indexIsValid(index: Int) -> Bool {
        return index >= 0 && index < grid.count
    }
    
    subscript(index: Int) -> Int {
        get {
            assert(indexIsValid(index: index), "Index out of range")
            return grid[index]
        }
        set {
            assert(indexIsValid(index: index), "Index out of range")
            grid[index] = newValue
        }
    }
    
    subscript(row: Int, column: Int) -> Int {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
    func toString() -> String{
        var text = ""
        for i in 0..<self.rows {
            for j in 0..<self.columns {
                text += "\(self[i,j]) "
            }
            text += "\n"
        }
        return text
    }
}
