//
//  ShareableImage.swift
//  PublicSector
//
//  Created by Hamza Jadid on 30/06/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ShareableImage: Transferable, Equatable, Identifiable {
    let id = UUID()
    let image: UIImage

    static func == (lhs: ShareableImage, rhs: ShareableImage) -> Bool {
        lhs.id == rhs.id
    }

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            guard let data = item.image.pngData() else {
                throw CocoaError(.fileWriteUnknown)
            }
            return data
        }
    }
}
