//
//  ExifTool.swift
//  Stripper
//
//  Created by Joe Diragi on 10/1/20.
//

import Foundation
import UIKit
import ImageIO

enum ExifError: Error {
    case invalidSource
    case invalidDestination
}

class ExifTool {
    static func stripper(data: NSData) throws {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            throw ExifError.invalidSource
        }
        guard let type = CGImageSourceGetType(source) else {
            throw ExifError.invalidSource
        }
        let count = CGImageSourceGetCount(source)
        let mutableData = NSMutableData(data: data as Data)
        guard let dest = CGImageDestinationCreateWithData(mutableData, type, count, nil) else {
            throw ExifError.invalidDestination
        }
        
        let stripped: CFDictionary = [String(kCGImagePropertyExifDictionary): kCFNull, String(kCGImagePropertyOrientation): kCFNull, String(kCGImagePropertyGPSDictionary): kCFNull] as CFDictionary
        
        for i in 0..<count {
            CGImageDestinationAddImageFromSource(dest, source, i, stripped)
        }
        
        guard CGImageDestinationFinalize(dest) else {
            throw ExifError.invalidDestination
        }
        
        UIImageWriteToSavedPhotosAlbum(UIImage(data:mutableData as Data,scale: 1.0)!, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished")
    }
}
