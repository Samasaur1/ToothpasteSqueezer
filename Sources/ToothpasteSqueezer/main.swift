import SwiftySCADKit

var args: [Double] = []
for argument in CommandLine.arguments.dropFirst() {
    if let d = Double(argument) {
        args.append(d)
    }
}

print("Input gap")
let gapDepth: Double = args.first != nil ? args.removeFirst() : Double(readLine() ?? "0.15") ?? 0.15
print("Input slope horizontal distance (distance from hole projection to slope)")
let slopeHorizontalDistance: Double = args.first != nil ? args.removeFirst() : Double(readLine() ?? "0.15") ?? 0.15
print("Input toothpaste width (Including \"wiggle room\", i.e. don't just measure it, add some space)")
let toothpasteWidth: Double = args.first != nil ? args.removeFirst() : Double(readLine() ?? "6.0") ?? 6.0//Including "wiggle room", i.e. don't just measure it, add some space.
print("Input padding")
let padding: Double = args.first != nil ? args.removeFirst() : Double(readLine() ?? "0.25") ?? 0.25
print("Input corner rounding (radius of the cylinder used to round)")
let cornerRoundingRadius: Double = args.first != nil ? args.removeFirst() : Double(readLine() ?? "0.2") ?? 0.2

let cutoutHeight = 1 + gapDepth + (padding * 2) + (slopeHorizontalDistance * 2) // so that extreme padding values still have the full cutout
let dimensions = (height: 3.0, width: toothpasteWidth + (slopeHorizontalDistance * 2) + (padding * 2), depth: (slopeHorizontalDistance * 2) + gapDepth + (padding * 2))

struct ToothpasteSqueezer: OpenSCAD {
    var body: some OpenSCAD {
        Difference(from: {
            Translate(by: padding, padding, 0) {
                Difference(from: {
                    Translate(by: -padding, -padding, 0) {
                        RectangularPrism(height: dimensions.height, width: dimensions.width, depth: dimensions.depth, centered: false)
                    }
                }) {
                    inside
                }
            }
        }) {
            Union {
                VerticalCornerRounder()
                WidthCornerRounder()
                DepthCornerRounder()
                GripCornerRounder()
            }
        }
    }

    var inside: some OpenSCAD {
        Translate(by: slopeHorizontalDistance, slopeHorizontalDistance, 0) {
            Union {
                Union {
                    RectangularPrism(height: 3, width: toothpasteWidth, depth: gapDepth, centered: false)
                    Hexahedron(bottom: (.init(-slopeHorizontalDistance, -slopeHorizontalDistance, 0), .init(-slopeHorizontalDistance, gapDepth + slopeHorizontalDistance, 0), .init(toothpasteWidth + slopeHorizontalDistance, gapDepth + slopeHorizontalDistance, 0), .init(toothpasteWidth + slopeHorizontalDistance, -slopeHorizontalDistance, 0)), top: (.init(0, 0, 1), .init(0, gapDepth, 1), .init(toothpasteWidth, gapDepth, 1), .init(toothpasteWidth, 0, 1)))
                }
                cutout
            }
        }
    }

    var cutout: some OpenSCAD {
        Translate(by: 0, 0, 0.1) { //so that the slope and cutout don't touch
            Translate(by: (toothpasteWidth/2)-1.5, (gapDepth / 2)-(cutoutHeight/2), 3-2) {
                Scale(by: 3/4, 1, 1) {
                    Translate(by: 2, cutoutHeight/2, 2) {
                        Rotate(by: 90, 0, 0) {
                            Cylinder(height: cutoutHeight, topRadius: 2, bottomRadius: 2, centered: true)
                        }
                    }
                }
            }
        }
        //functionally identical to this:
//        Cylinder(height: cutoutHeight, topRadius: 2, bottomRadius: 2, centered: true).rotated(by: 90, 0, 0).translated(by: 2, cutoutHeight/2, 2).scaled(by: 3/4, 1, 1).translated(by: (toothpasteWidth/2)-1.5, (gapDepth / 2)-(cutoutHeight/2), 3-2).translated(by: 0, 0, 0.1)
    }
}

struct VerticalCornerRounder: OpenSCAD {
    var body: some OpenSCAD {
        Union {
            dualVerticalCornerRounder
            Translate(by: 0, dimensions.depth, 0) {
                Mirror(across: 0, 1, 0) {
                    dualVerticalCornerRounder
                }
            }
        }
    }

    var dualVerticalCornerRounder: some OpenSCAD {
        Union {
            singleVerticalCornerRounder
            Translate(by: dimensions.width, 0, 0) {
                Mirror(across: 1, 0, 0) {
                    singleVerticalCornerRounder
                }
            }
        }
    }

    var singleVerticalCornerRounder: some OpenSCAD {
        Difference(from: {
            RectangularPrism(height: dimensions.height, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false)
        }) {
            Translate(by: cornerRoundingRadius, cornerRoundingRadius, 0) {
                Cylinder(height: dimensions.height, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
            }
        }
    }
}
struct WidthCornerRounder: OpenSCAD {
    var body: some OpenSCAD {
        Translate(by: 0, 0, dimensions.height) {
            Rotate(by: 0, 90, 0) {
                Union {
                    dualWidthCornerRounder
                    Translate(by: 0, dimensions.depth, 0) {
                        Mirror(across: 0, 1, 0) {
                            dualWidthCornerRounder
                        }
                    }
                }
            }
        }
    }

    var dualWidthCornerRounder: some OpenSCAD {
        Union {
            singleWidthCornerRounder
            Translate(by: dimensions.height, 0, 0) {
                Mirror(across: 1, 0, 0) {
                    singleWidthCornerRounder
                }
            }
        }
    }

    var singleWidthCornerRounder: some OpenSCAD {
        Difference(from: {
            RectangularPrism(height: dimensions.width, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false)
        }) {
            Translate(by: cornerRoundingRadius, cornerRoundingRadius, 0) {
                Cylinder(height: dimensions.width, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
            }
        }
    }
}
struct DepthCornerRounder: OpenSCAD {
    var body: some OpenSCAD {
        Translate(by: 0, 0, dimensions.height) {
            Rotate(by: -90, 0, 0) {
                Union {
                    dualDepthCornerRounder
                    Translate(by: 0, dimensions.height, 0) {
                        Mirror(across: 0, 1, 0) {
                            dualDepthCornerRounder
                        }
                    }
                }
            }
        }
    }

    var dualDepthCornerRounder: some OpenSCAD {
        Union {
            singleDepthCornerRounder
            Translate(by: dimensions.width, 0, 0) {
                Mirror(across: 1, 0, 0) {
                    singleDepthCornerRounder
                }
            }
        }
    }

    var singleDepthCornerRounder: some OpenSCAD {
        Difference(from: {
            RectangularPrism(height: dimensions.depth, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false)
        }) {
            Translate(by: cornerRoundingRadius, cornerRoundingRadius, 0) {
                Cylinder(height: dimensions.depth, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
            }
        }
    }
}
struct GripCornerRounder: OpenSCAD {
    var body: some OpenSCAD {
        Translate(by: padding + (toothpasteWidth / 2) + slopeHorizontalDistance + 1.5 - (0.125 * cornerRoundingRadius), 0, dimensions.height) {
            Rotate(by: -90, 0, 0) {
                Union {
                    singleGripCornerRounder
                    Translate(by: -3 + (0.25 * cornerRoundingRadius), 0, 0) {
                        Mirror(across: 1, 0, 0) {
                            singleGripCornerRounder
                        }
                    }
                }
            }
        }
    }

    var singleGripCornerRounder: some OpenSCAD {
        Difference(from: {
            RectangularPrism(height: dimensions.depth, width: cornerRoundingRadius, depth: cornerRoundingRadius, centered: false)
        }) {
            Translate(by: cornerRoundingRadius, cornerRoundingRadius, 0) {
                Cylinder(height: dimensions.depth, topRadius: cornerRoundingRadius, bottomRadius: cornerRoundingRadius, centered: false)
            }
        }
    }
}

//OPENSCAD_print(ToothpasteSqueezer())
print(parse(scad: ToothpasteSqueezer()))
