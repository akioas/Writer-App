import SwiftUI


var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var currentLayer = 0
var pathVar = Path()
var drawMode = 1
var imageSize = CGSize(width: screenWidth+100, height: screenWidth+100)


var pathVarPreview = Array(repeating:Path(),count:loadNum(KeyForUserDefaults: keyMaxViewNum))
var currentNum = 0
var currentLayerPreview = 0
var rectWidth: Double = screenWidth
var rectHeight: Double = screenHeight

var selected: Int = 0









