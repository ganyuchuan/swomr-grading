import Foundation
import Vision
import ImageIO

guard CommandLine.arguments.count > 1 else {
    fputs("usage: ocr_vision <image> [custom-word ...]\n", stderr)
    exit(2)
}

let imageURL = URL(fileURLWithPath: CommandLine.arguments[1])
guard let source = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
      let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
    fputs("failed to load image\n", stderr)
    exit(1)
}

let request = VNRecognizeTextRequest()
request.recognitionLevel = .accurate
request.usesLanguageCorrection = true
request.recognitionLanguages = ["zh-Hans", "en-US"]
request.minimumTextHeight = 0.005

if CommandLine.arguments.count > 2 {
    request.customWords = Array(CommandLine.arguments.dropFirst(2))
}

let handler = VNImageRequestHandler(cgImage: image, options: [:])
try handler.perform([request])

let observations = (request.results ?? []).sorted {
    let y0 = 1 - $0.boundingBox.maxY
    let y1 = 1 - $1.boundingBox.maxY
    if abs(y0 - y1) > 0.01 { return y0 < y1 }
    return $0.boundingBox.minX < $1.boundingBox.minX
}

for observation in observations {
    let alternatives = observation.topCandidates(3)
        .map { $0.string }
        .joined(separator: " || ")
    guard !alternatives.isEmpty else { continue }
    let box = observation.boundingBox
    let x = Int(box.minX * 1000)
    let y = Int((1 - box.maxY) * 1000)
    let width = Int(box.width * 1000)
    let height = Int(box.height * 1000)
    print("[\(x),\(y),\(width),\(height)] \(alternatives)")
}
