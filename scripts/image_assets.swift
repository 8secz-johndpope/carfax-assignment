#!/usr/bin/swift

import Foundation

extension String {
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
}

func cleanImagesetString(_ imageset: String) -> String {
    let cleaned = imageset.replacingOccurrences(of: "-", with: "_")
    return cleaned
}

func buildUIImageExtensionFile(from imagesets: [String]) -> String {

    let imageVariables: [String] = imagesets
        .reduce([]) { results, name in
            var imageVar = results
            let name = name.deletingPathExtension
            let cleaned = cleanImagesetString(name)
            imageVar.append("")
            imageVar.append("    static var \(cleaned): UIImage {")
            imageVar.append("        return UIImage(iconNamed: \"\(name)\")")
            imageVar.append("    }")
            return imageVar
        }

    var lines: [String] = []
    lines.append("///")
    lines.append("/// This file is created at build time from scripts/image_assets.swift")
    lines.append("/// Do not modify directly.")
    lines.append("///")
    lines.append("")
    lines.append("import UIKit")
    lines.append("")
    lines.append("private class Container {}")
    lines.append("")
    lines.append("public extension UIImage {")
    lines.append("")
    lines.append("    private convenience init(iconNamed: String) {")
    lines.append("        self.init(named: iconNamed, in: Bundle(for: Container.self), compatibleWith: nil)!")
    lines.append("    }")
    lines.append(contentsOf: imageVariables)
    lines.append("}\n")
    return lines.joined(separator: "\n")
}

func main() throws {

    assert(CommandLine.arguments.count > 2, "Add xcassets path and output file")

    let xassetsPath = CommandLine.arguments[1]
    let outputPath = CommandLine.arguments[2]

    let files = try FileManager.default.contentsOfDirectory(atPath: xassetsPath)

    let imagesets = files.filter { $0.contains("imageset") }
        .sorted()

    let contents = buildUIImageExtensionFile(from: imagesets)

    try contents.write(toFile: outputPath, atomically: true, encoding: .utf8)
    print("Generating: \(outputPath.lastPathComponent) from \(xassetsPath.lastPathComponent)")
}

do {
    try main()
} catch let e {
    fatalError(e.localizedDescription)
}
