import SwiftUI



func deleteView(deletedViewNum: Int,  maxViewNum: Int)->([[CGPoint]]) {
    if deletedViewNum == maxViewNum{
        let keyToDelete = keyName + String(deletedViewNum)
        UserDefaults.standard.removeObject(forKey: keyToDelete)
            
    }
    else {
        for viewNum in deletedViewNum...(maxViewNum - 1){
            let keyToDelete = keyName + String(viewNum)
            //
            let keyToReassign = keyName + String(viewNum+1)
            guard let encodedData = UserDefaults.standard.array(forKey: keyToReassign) as? [Data] else {
                return [[]]
            }
            
            let encodedReturn = encodedData.map { try! JSONDecoder().decode([CGPoint].self, from: $0) }
            
            let data = encodedReturn.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data as Any?, forKey: keyToDelete)
            //
        }
        let keyToDelete = keyName + String(maxViewNum)
        UserDefaults.standard.removeObject(forKey: keyToDelete)
        
    }
    return [[]]
}
//вызов и после maxView = maxViewNum - 1
