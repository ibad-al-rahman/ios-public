//
//  ShareableImage.swift
//  PublicSector
//
//  Created by Hamza Jadid on 30/06/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ShareableImage: Transferable {
    let image: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            guard let data = item.image.pngData() else {
                throw CocoaError(.fileWriteUnknown)
            }
            return data
        }
    }
}
