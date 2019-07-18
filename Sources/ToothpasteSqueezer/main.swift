import SwiftySCADKit
var main: OpenSCAD = OpenSCAD("")
defer {
    OPENSCAD_print(main)
}

print("Input gap")
let gapDepth: Double = Double(readLine() ?? "0.15") ?? 0.15

print("Input slope horizontal distance (distance from hole projection to slope)")
let slopeHorizontalDistance: Double = Double(readLine() ?? "0.15") ?? 0.15

print("Input toothpaste width (Including \"wiggle room\", i.e. don't just measure it, add some space)")
let toothpasteWidth: Double = Double(readLine() ?? "6.0") ?? 6.0//Including "wiggle room", i.e. don't just measure it, add some space.

main = OpenSCAD.rectangularPrism(height: 3, width: toothpasteWidth, depth: gapDepth, centered: false)
let slope = OpenSCAD.hexahedron(bottom: (.init(-slopeHorizontalDistance, -slopeHorizontalDistance, 0), .init(-slopeHorizontalDistance, gapDepth + slopeHorizontalDistance, 0), .init(toothpasteWidth + slopeHorizontalDistance, gapDepth + slopeHorizontalDistance, 0), .init(toothpasteWidth + slopeHorizontalDistance, -slopeHorizontalDistance, 0)), top: (.init(0, 0, 1), .init(0, gapDepth, 1), .init(toothpasteWidth, gapDepth, 1), .init(toothpasteWidth, 0, 1)))
main.union(with: slope)

print("Input padding")
let padding: Double = Double(readLine() ?? "0.25") ?? 0.25

let cutoutHeight = 5.0 + (padding * 2) // so that extreme padding values still have the full cutout
var cutout = OpenSCAD.cylinder(height: cutoutHeight, topRadius: 2, bottomRadius: 2, centered: true)
cutout.rotate(by: 90, 0, 0)
cutout.translate(by: 2, cutoutHeight/2, 2)
cutout.scale(to: 3/4, 1, 1)
cutout.translate(by: (toothpasteWidth/2)-1.5, (gapDepth / 2)-(cutoutHeight/2), 3-2)
cutout.translate(by: 0, 0, 0.1) //so that the slope and cutout don't touch
main.union(with: cutout)
main.translate(by: slopeHorizontalDistance, slopeHorizontalDistance, 0)

let dimensions = (height: 3.0, width: toothpasteWidth + (slopeHorizontalDistance * 2) + (padding * 2), depth: (slopeHorizontalDistance * 2) + gapDepth + (padding * 2))
var minuend = OpenSCAD.rectangularPrism(height: dimensions.height, width: dimensions.width, depth: dimensions.depth, centered: false)
minuend.translate(by: -padding, -padding, 0)
main.difference(from: minuend)
main.translate(by: padding, padding, 0)

print("Input corner rounding (radius of the cylinder used to round)")
let cornerRoundingRadius: Double = Double(readLine() ?? "0.2") ?? 0.2

var verticalCornerRounder = OpenSCAD.cylinder(height: dimensions.height, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
verticalCornerRounder.translate(by: cornerRoundingRadius, cornerRoundingRadius, 0)
verticalCornerRounder.difference(from: .rectangularPrism(height: dimensions.height, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false))
verticalCornerRounder.union(with: verticalCornerRounder.mirrored(across: 1, 0, 0).translated(by: dimensions.width, 0, 0))
verticalCornerRounder.union(with: verticalCornerRounder.mirrored(across: 0, 1, 0).translated(by: 0, dimensions.depth, 0))

var widthCornerRounder = OpenSCAD.cylinder(height: dimensions.width, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
widthCornerRounder.translate(by: cornerRoundingRadius, cornerRoundingRadius, 0)
widthCornerRounder.difference(from: .rectangularPrism(height: dimensions.width, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false))
widthCornerRounder.union(with: widthCornerRounder.mirrored(across: 1, 0, 0).translated(by: dimensions.height, 0, 0))
widthCornerRounder.union(with: widthCornerRounder.mirrored(across: 0, 1, 0).translated(by: 0, dimensions.depth, 0))
widthCornerRounder.rotate(by: 0, 90, 0)
widthCornerRounder.translate(by: 0, 0, dimensions.height)

var depthCornerRounder = OpenSCAD.cylinder(height: dimensions.depth, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
depthCornerRounder.translate(by: cornerRoundingRadius, cornerRoundingRadius, 0)
depthCornerRounder.difference(from: .rectangularPrism(height: dimensions.depth, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false))
depthCornerRounder.union(with: depthCornerRounder.mirrored(across: 1, 0, 0).translated(by: dimensions.width, 0, 0))
depthCornerRounder.union(with: depthCornerRounder.mirrored(across: 0, 1, 0).translated(by: 0, dimensions.height, 0))
depthCornerRounder.rotate(by: -90, 0, 0)
depthCornerRounder.translate(by: 0, 0, dimensions.height)

var gripCornerRounder = OpenSCAD.cylinder(height: dimensions.depth, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
gripCornerRounder.translate(by: cornerRoundingRadius, cornerRoundingRadius, 0)
gripCornerRounder.difference(from: .rectangularPrism(height: dimensions.depth, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false))
gripCornerRounder.union(with: gripCornerRounder.mirrored(across: 1, 0, 0).translated(by: -3 + (0.25 * cornerRoundingRadius), 0, 0))
gripCornerRounder.rotate(by: -90, 0, 0)
gripCornerRounder.translate(by: padding + (toothpasteWidth / 2) + slopeHorizontalDistance + 1.5 - (0.125 * cornerRoundingRadius), 0, dimensions.height)

main = verticalCornerRounder.differenced(from: main)
main = widthCornerRounder.differenced(from: main)
main = depthCornerRounder.differenced(from: main)
main = gripCornerRounder.differenced(from: main)
