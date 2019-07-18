import SwiftySCADKit
var main: OpenSCAD = OpenSCAD("")
defer {
    OPENSCAD_print(main)
}

main = OpenSCAD.hexahedron(bottom: (.init(1, 5, 0), .init(-1, 5, 0), .init(-1, -5, 0), .init(1, -5, 0)), top: (.init(0.05, 4.05, 5), .init(-0.05, 4.05, 5), .init(-0.05, -4.05, 5), .init(0.05, -4.05, 5)))
main.difference(from: OpenSCAD.cube(withSideLength: 10, centered: true))

main = OpenSCAD.rectangularPrism(height: 3, width: 6, depth: 0.15, centered: false)
let slope = OpenSCAD.hexahedron(bottom: (.init(-0.15, -0.15, 0), .init(-0.15, 0.30, 0), .init(6.15, 0.30, 0), .init(6.15, -0.15, 0)), top: (.init(0, 0, 1), .init(0, 0.15, 1), .init(6, 0.15, 1), .init(6, 0, 1)))
main.union(with: slope)

print("Input padding")
let padding: Double = Double(readLine() ?? "0.25") ?? 0.25

let cutoutHeight = 5.0 + (padding * 2) // so that extreme padding values still have the full cutout
var cutout = OpenSCAD.cylinder(height: cutoutHeight, topRadius: 2, bottomRadius: 2, centered: true)
cutout.rotate(by: 90, 0, 0)
cutout.translate(by: 2, cutoutHeight/2, 2)
cutout.scale(to: 3/4, 1, 1)
cutout.translate(by: 3-1.5, 0.075-(cutoutHeight/2), 3-2)
cutout.translate(by: 0, 0, 0.1) //so that the slope and cutout don't touch
main.union(with: cutout)
main.translate(by: 0.15, 0.15, 0)

var minuend = OpenSCAD.rectangularPrism(height: 3, width: 6.3 + (padding * 2), depth: 0.45 + (padding * 2), centered: false)
minuend.translate(by: -padding, -padding, 0)
main.difference(from: minuend)
main.translate(by: padding, padding, 0)

print("Input corner rounding (radius of the cylinder used to round)")
let cornerRoundingRadius: Double = Double(readLine() ?? "0.2") ?? 0.2

var verticalCornerRounder = OpenSCAD.cylinder(height: 3, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
verticalCornerRounder.translate(by: cornerRoundingRadius, cornerRoundingRadius, 0)
verticalCornerRounder.difference(from: .rectangularPrism(height: 3, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false))
verticalCornerRounder.union(with: verticalCornerRounder.mirrored(across: 1, 0, 0).translated(by: 6.3 + (padding * 2), 0, 0))
verticalCornerRounder.union(with: verticalCornerRounder.mirrored(across: 0, 1, 0).translated(by: 0, 0.45 + (padding * 2), 0))

var widthCornerRounder = OpenSCAD.cylinder(height: 6.3 + (padding * 2), topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
widthCornerRounder.translate(by: cornerRoundingRadius, cornerRoundingRadius, 0)
widthCornerRounder.difference(from: .rectangularPrism(height: 6.3 + (padding * 2), width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false))
widthCornerRounder.union(with: widthCornerRounder.mirrored(across: 1, 0, 0).translated(by: 3, 0, 0))
widthCornerRounder.union(with: widthCornerRounder.mirrored(across: 0, 1, 0).translated(by: 0, 0.45 + (padding * 2), 0))
widthCornerRounder.rotate(by: 0, 90, 0)
widthCornerRounder.translate(by: 0, 0, 3)

var depthCornerRounder = OpenSCAD.cylinder(height: 0.45 + (padding * 2), topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
depthCornerRounder.translate(by: cornerRoundingRadius, cornerRoundingRadius, 0)
depthCornerRounder.difference(from: .rectangularPrism(height: 0.45 + (padding * 2), width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false))
depthCornerRounder.union(with: depthCornerRounder.mirrored(across: 1, 0, 0).translated(by: 6.3 + (padding * 2), 0, 0))
depthCornerRounder.union(with: depthCornerRounder.mirrored(across: 0, 1, 0).translated(by: 0, 3, 0))
depthCornerRounder.rotate(by: -90, 0, 0)
depthCornerRounder.translate(by: 0, 0, 3)

var gripCornerRounder = OpenSCAD.cylinder(height: 0.45 + (padding * 2), topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
gripCornerRounder.translate(by: cornerRoundingRadius, cornerRoundingRadius, 0)
gripCornerRounder.difference(from: .rectangularPrism(height: 0.45 + (padding * 2), width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false))
gripCornerRounder.union(with: gripCornerRounder.mirrored(across: 1, 0, 0).translated(by: -3 + (0.25 * cornerRoundingRadius), 0, 0))
gripCornerRounder.rotate(by: -90, 0, 0)
gripCornerRounder.translate(by: padding + 4.65 - (0.125 * cornerRoundingRadius), 0, 3)

main = verticalCornerRounder.differenced(from: main)
main = widthCornerRounder.differenced(from: main)
main = depthCornerRounder.differenced(from: main)
main = gripCornerRounder.differenced(from: main)
