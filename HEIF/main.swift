// Copyright (c) by Alexander Borsuk, 2018

import Foundation
import CoreImage

let kToolVersion = 0.1

// Options parsed from command line.
let kCompressionQualityOption = "-q="
var compressionQuality = 0.8

// Fills options and returns input image file.
// OR prints usage and exits if input file wasn't specified.
func ParseCommandLine() -> URL {
  var imagePath:String?
  for i in 1..<Int(CommandLine.argc) {
    let arg = CommandLine.arguments[i]
    if arg.hasPrefix(kCompressionQualityOption) {
      compressionQuality = Double(arg.suffix(arg.count - kCompressionQualityOption.count)) ?? compressionQuality
    } else {
      imagePath = arg
    }
  }
  if imagePath == nil {
    print("Converts image to HEIC format, version", kToolVersion)
    print("Usage: " + URL(fileURLWithPath:CommandLine.arguments[0]).lastPathComponent + " [" + kCompressionQualityOption + "quality] <image>")
    print("Default quality is 0.8 and it ranges from 0.0 (max compression) to 1.0 (lossless).")
    print("Please note: odd image dimensions will be truncated by codec to even ones.")
    exit(0)
  }
  return URL(fileURLWithPath:imagePath!)
}

let imageUrl = ParseCommandLine()
let image = CIImage(contentsOf: imageUrl)
let context = CIContext(options: nil)
let heicUrl = imageUrl.deletingPathExtension().appendingPathExtension("heic")
let options = NSDictionary(dictionary: [kCGImageDestinationLossyCompressionQuality:compressionQuality])

try! context.writeHEIFRepresentation(of:image!,
                        to:heicUrl,
                        format: CIFormat.ARGB8,
                        colorSpace: image!.colorSpace!,
                        options:options as! [CIImageRepresentationOption : Any])
