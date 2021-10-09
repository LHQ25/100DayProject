//
//  ViewController.swift
//  Day1_QuickLookPreviews
//
//  Created by 亿存 on 2020/7/8.
//  Copyright © 2020 亿存. All rights reserved.
//

import UIKit

import QuickLook

/**
    以下是一些受支持的文件类型：
        Images
        Audio and video files
        PDFs
        HTML文件
        iWork和Microsoft Office文档
        ZIP文件
        使用USDZ文件格式的增强现实对象，仅限iOS和iPadOS
 */

class ViewController: UICollectionViewController {
    let files = File.loadFiles()
    ///添加默认的缩放过渡
    weak var tappedCell: FileCell?
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        files.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FileCell.reuseIdentifier,
            for: indexPath) as? FileCell
            else {
                return UICollectionViewCell()
        }
        cell.update(with: files[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //    collectionView.deselectItem(at: indexPath, animated: true)
        
        
        // 1
        let quickLookViewController = QLPreviewController()
        // 2
        quickLookViewController.dataSource = self
        
        tappedCell = collectionView.cellForItem(at: indexPath) as? FileCell
        quickLookViewController.delegate = self
        
        // 3
        quickLookViewController.currentPreviewItemIndex = indexPath.row
        // 4
        present(quickLookViewController, animated: true)
    }
}

// MARK: - QLPreviewControllerDataSource
extension ViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int ) -> QLPreviewItem {
        
        files[index]
    }
}

// MARK: - QLPreviewControllerDelegate
extension ViewController: QLPreviewControllerDelegate {
    
    ///过渡动画
    func previewController(_ controller: QLPreviewController, transitionViewFor item: QLPreviewItem) -> UIView? {
        
        tappedCell?.thumbnailImageView
    }
    
    //打开编辑
    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
        
      .updateContents
    }
    
    ///返回编辑后的文件地址  根据上面的编辑模式返回的地址是不同的   有可能是一个临时文件地址
     //    func previewController(_ controller: QLPreviewController, didSaveEditedCopyOf previewItem: QLPreviewItem, at modifiedContentsURL: URL){
//        
//    }
    
    ///编辑完成后  缩略图是不会变的  主动去重新获取  缩略图
    func previewController(_ controller: QLPreviewController, didUpdateContentsOf previewItem: QLPreviewItem) {
        
      guard let file = previewItem as? File else { return }
      DispatchQueue.main.async {
        self.tappedCell?.update(with: file)
      }
    }
}
