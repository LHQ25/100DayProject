//
//  ImagePickerView.swift
//  ColourAtla
//
//  Created by 娄汉清 on 2022/7/11.
//

import Foundation
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
//    typealias UIViewControllerType = <#type#>
    
    
    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage)->Void
    
    @Environment(\.presentationMode) private var  presentationMode
    
    init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage)->Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        
        Coordinator(onDismiss: { self.presentationMode.wrappedValue.dismiss() },
                    onImagePicked: self.onImagePicked )
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        
    }
    
    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let onDismiss: ()->Void
        private let onImagePicked: (UIImage)->Void
        
        init(onDismiss: @escaping ()->Void, onImagePicked: @escaping (UIImage)->Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                onImagePicked(image)
            }
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onDismiss()
        }
    }
}
