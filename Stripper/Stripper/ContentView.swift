//
//  ContentView.swift
//  Stripper
//
//  Created by Joe Diragi on 10/1/20.
//

import SwiftUI

struct ContentView: View {
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            if image != nil {
                Button("Save Image") {
                    do {
                       try ExifTool.stripper(data: (image?.pngData()!)! as NSData)
                    } catch {
                        print("Couldn't strip")
                    }
                }
            } else {
                Button("Pick Image") {
                    self.showImagePicker.toggle()
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.image = image
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
