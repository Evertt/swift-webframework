import Foundation

public struct OrderedDictionary<Tk: Hashable, Tv> : MutableCollectionType {
    var keys: Array<Tk> = []
    var values: Dictionary<Tk,Tv> = [:]
    
    public typealias Index = Array<Tk>.Index
    
    public var count: Int {
        return self.keys.count;
    }
    
    public var isEmpty: Bool {
        return self.keys.isEmpty
    }
    
    public var startIndex: Index {
        return self.keys.startIndex
    }
    
    public var endIndex: Index {
        return self.keys.endIndex
    }
    
    public subscript(index: Index) -> (Tk, Tv) {
        get {
            let key = self.keys[index]
            
            return (key, self.values[key]!)
        }
        set(newValue) {
            let key = self.keys[index]
            self.values.removeValueForKey(key)
            
            self.keys[index] = newValue.0
            self.values[newValue.0] = newValue.1
        }
    }

    public subscript(key: Tk) -> Tv? {
        get {
            return self.values[key]
        }
        set(newValue) {
            if newValue == nil {
                self.values.removeValueForKey(key)
                self.keys = self.keys.filter {$0 != key}
            }
            
            let oldValue = self.values.updateValue(newValue!, forKey: key)
            if oldValue == nil {
                self.keys.append(key)
            }
        }
    }
    
    public var description: String {
        var result = "{\n"
        for i in 0..<self.count {
            result += "[\(i)]: \(self.keys[i]) => \(self[i])\n"
        }
        result += "}"
        return result
    }
}