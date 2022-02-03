

import Foundation
import SwiftUI

class CGPointsTransformer: ValueTransformer{
    
    override func transformedValue(_ value: Any?) -> Any?{
        
        guard let points = value as? [[CGPoint]] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: points, requiringSecureCoding: false)
            return data
        }
        catch
        {
            return nil
        }
        
    }
    
    
    override func reverseTransformedValue(_ value: Any?) -> Any?{
        
        guard let data = value as? Data else { return nil }
        
        do {
            let points = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            return points
        }
        catch
        {
            return nil
        }
        
    }
    
}
