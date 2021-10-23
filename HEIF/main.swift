#!/usr/bin/swift
// Copyright (c) by Alexander Borsuk, 2021
// See MIT license in LICENSE file.

import Foundation
import CoreImage

let kToolVersion = 0.4

// Options parsed from command line.
let kCompressionQualityOption = "-q="
var compressionQuality = 0.76

// Fills options and returns input image file.
// OR prints usage and exits if input file wasn't specified.
func ParseCommandLine() -> URL {
  var imagePath:String?
  for i in 1..<Int(CommandLine.argc) {
    let arg = CommandLine.arguments[i]
    if arg.hasPrefix(kCompressionQualityOption) {
      compressionQuality = Double(arg.suffix(arg.count - kCompressionQualityOption.count)) ?? compressionQuality
      if compressionQuality == 0.0 {
        print("Apple's compressor will use some internal default quality level, empirically it is 0.76-0.77")
      }
    } else {
      imagePath = arg
    }
  }
  if imagePath == nil {
    let kBinaryName = URL(fileURLWithPath:CommandLine.arguments[0]).lastPathComponent
    print("Converts image to HEIC format, version \(kToolVersion)")
    print("Usage: \(kBinaryName) [\(kCompressionQualityOption)quality] <image>")
    print("Default quality is \(compressionQuality) and it ranges from 0.1 (max compression) to 1.0 (lossless).")
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
