
import UIKit
import QuickLook

class File: NSObject {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var name: String {
        url.deletingPathExtension().lastPathComponent
    }
}

// MARK: - Helper extension
extension File {
    static func loadFiles() -> [File] {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        
        let urls: [URL]
        do {
            //documents 目录下  所有文件的地址
            urls = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        } catch {
            fatalError("Couldn't load files from documents directory")
        }
        
        return urls.map { File(url: $0) }
    }
    
    static func copyResourcesToDocumentsIfNeeded() {
        guard UserDefaults.standard.bool(forKey: "didCopyResources") else {
            let files = [
                Bundle.main.url(forResource: "Cover Charm", withExtension: "docx"),
                Bundle.main.url(forResource: "Light Charm", withExtension: "pdf"),
                Bundle.main.url(forResource: "Parapluie Spell", withExtension: "txt"),
                Bundle.main.url(forResource: "Water Spell", withExtension: "html"),
                Bundle.main.url(forResource: "Dark Magic", withExtension: "zip")
            ]
            files.forEach {
                guard let url = $0 else { return }
                do {
                    let newURL = FileManager.default
                        .urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent)
                    try FileManager.default.copyItem(at: url, to: newURL)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            UserDefaults.standard.set(true, forKey: "didCopyResources")
            return
        }
    }
}

extension File: QLPreviewItem {
    
    var previewItemURL: URL? {
        url
    }
}

// MARK: - QuickLookThumbnailing 缩略图
extension File {
    
    func generateThumbnail(completion: @escaping (UIImage) -> Void) {
        // 1 尺寸 和 缩放
        let size = CGSize(width: 128, height: 102)
        let scale = UIScreen.main.scale
        // 2  缩略图请求
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: size,
            scale: scale,
            representationTypes: .all)
        
        // 3
        let generator = QLThumbnailGenerator.shared
        ///第一版   生成文件图标或高质量的缩略图
//        generator.generateBestRepresentation(for: request) { thumbnail, error in
//            if let thumbnail = thumbnail {
//                completion(thumbnail.uiImage)
//            } else if let error = error {
//                // Handle error
//                print(error)
//            }
//        }
        ///第二版   此方法快速生成文件图标或低质量的缩略图，然后调用updateHandler。 一旦有更高质量的缩略图可用，框架将再次调用updateHandler。 如果此缩略图在下一个缩略图之前可用，则它可能会完全跳过第一个调用。
        generator.generateRepresentations(for: request) { thumbnail, _, error in
            if let thumbnail = thumbnail {
                completion(thumbnail.uiImage)
            } else if let error = error {
                // Handle error
                print(error)
            }
        }
    }
    
    
}
