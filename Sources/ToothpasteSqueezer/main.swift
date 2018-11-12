import SwiftySCADKit

var main = OpenSCAD.rectangularPrism(height: 30, width: 70, depth: 12.5, centered: true)
var hole = OpenSCAD.rectangularPrism(height: 40, width: 60, depth: 1.5, centered: true)


let verticalCornerRounder = OpenSCAD.cylinder(height: 31, topRadius: 2.5, bottomRadius: 2.5, centered: true).differenced(from: OpenSCAD.rectangularPrism(height: 30, width: 5, depth: 5, centered: true)).unioned(with: OpenSCAD.rectangularPrism(height: 70, width: 5, depth: 5, centered: false).translated(by: 2.5, 0, -35), OpenSCAD.rectangularPrism(height: 70, width: 5, depth: 5, centered: false).translated(by: 0, 2.5, -35)).intersectioned(with: OpenSCAD.rectangularPrism(height: 30, width: 3, depth: 3, centered: false).translated(by: 0, 0, -15)).translated(by: 32.5, 6.25-2.5, 0)
var verticalCornerRounders = verticalCornerRounder.unioned(with: verticalCornerRounder.mirrored(across: 1, 0, 0))
verticalCornerRounders.union(with: verticalCornerRounders.mirrored(across: 0, 1, 0))

let depthCornerRounder = OpenSCAD.cylinder(height: 13, topRadius: 2.5, bottomRadius: 2.5, centered: true).differenced(from: OpenSCAD.rectangularPrism(height: 12.5, width: 5, depth: 5, centered: true)).unioned(with: OpenSCAD.rectangularPrism(height: 70, width: 5, depth: 5, centered: false).translated(by: 2.5, 0, -35), OpenSCAD.rectangularPrism(height: 70, width: 5, depth: 5, centered: false).translated(by: 0, 2.5, -35)).intersectioned(with: OpenSCAD.rectangularPrism(height: 12.5, width: 3, depth: 3, centered: false).translated(by: 0, 0, -6.25)).rotated(by: 90, 0, 0).translated(by: 32.5, 0, 12.5)
var depthCornerRounders = depthCornerRounder.unioned(with: depthCornerRounder.mirrored(across: 1, 0, 0))
depthCornerRounders.union(with: depthCornerRounders.mirrored(across: 0, 0, 1))

let widthCornerRounder = OpenSCAD.cylinder(height: 71, topRadius: 2.5, bottomRadius: 2.5, centered: true).differenced(from: OpenSCAD.rectangularPrism(height: 70, width: 5, depth: 5, centered: true)).unioned(with: OpenSCAD.rectangularPrism(height: 70, width: 5, depth: 5, centered: false).translated(by: 2.5, 0, -35), OpenSCAD.rectangularPrism(height: 70, width: 5, depth: 5, centered: false).translated(by: 0, 2.5, -35)).intersectioned(with: OpenSCAD.rectangularPrism(height: 70, width: 3, depth: 3, centered: false).translated(by: 0, 0, -35)).rotated(by: 0, -90, 0).translated(by: 0, 6.25-2.5, 12.5)
var widthCornerRounders = widthCornerRounder.unioned(with: widthCornerRounder.mirrored(across: 0, 1, 0))
widthCornerRounders.union(with: widthCornerRounders.mirrored(across: 0, 0, 1))


let slopingHole = OpenSCAD.hexahedron(bottom: (OpenSCAD.Point(32.5, 3.25, -15), OpenSCAD.Point(32.5, -3.25, -15), OpenSCAD.Point(-32.5, -3.25, -15), OpenSCAD.Point(-32.5, 3.25, -15)), top: (OpenSCAD.Point(30, 0.75, -5), OpenSCAD.Point(30, -0.75, -5), OpenSCAD.Point(-30, -0.75, -5), OpenSCAD.Point(-30, 0.75, -5)))


let grippingHole = OpenSCAD.cylinder(height: 15, topRadius: 10, bottomRadius: 10, centered: true).rotated(by: 90, 0, 0).translated(by: 0, 0, 12.5).resized(to: 20, 15, 25)

print(OpenSCAD.difference(main, hole, verticalCornerRounders, depthCornerRounders, widthCornerRounders, slopingHole, grippingHole).SCADValue)
