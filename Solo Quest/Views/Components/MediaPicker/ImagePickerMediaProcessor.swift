//
//  ImagePickerMediaProcessor.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import AVFoundation
import UIKit

enum ImagePickerMediaProcessor {
    static func cropToRequiredAspectRatio(_ image: UIImage) -> UIImage {
        let width = image.size.width
        let height = image.size.height
        let isPortrait = height > width
        
        let targetRatio: CGFloat = isPortrait ? 9.0/16.0 : 16.0/9.0
        let currentRatio = width / height
        
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        if currentRatio > targetRatio {
            newHeight = height
            newWidth = newHeight * targetRatio
        } else {
            newWidth = width
            newHeight = newWidth / targetRatio
        }
        
        let x = (width - newWidth) / 2.0
        let y = (height - newHeight) / 2.0
        let cropRect = CGRect(x: x, y: y, width: newWidth, height: newHeight)
        
        let renderer = UIGraphicsImageRenderer(size: cropRect.size)
        return renderer.image { _ in
            image.draw(at: CGPoint(x: -x, y: -y))
        }
    }
    
    static func processVideo(url: URL, completion: @escaping (URL?) -> Void) {
        Task {
            let asset = AVAsset(url: url)
            
            do {
                let tracks = try await asset.loadTracks(withMediaType: .video)
                guard let track = tracks.first else {
                    completion(url)
                    return
                }
                
                let naturalSize = try await track.load(.naturalSize)
                let preferredTransform = try await track.load(.preferredTransform)
                let duration = try await asset.load(.duration)
                
                let size = naturalSize.applying(preferredTransform)
                let width = abs(size.width)
                let height = abs(size.height)
                let isPortrait = height > width
                
                let targetRatio: CGFloat = isPortrait ? 9.0/16.0 : 16.0/9.0
                let currentRatio = width / height
                
                var renderWidth: CGFloat
                var renderHeight: CGFloat
                
                if abs(currentRatio - targetRatio) < 0.01 {
                    completion(url)
                    return
                }
                
                if currentRatio > targetRatio {
                    renderHeight = height
                    renderWidth = renderHeight * targetRatio
                } else {
                    renderWidth = width
                    renderHeight = renderWidth / targetRatio
                }
                
                renderWidth = floor(renderWidth / 2) * 2
                renderHeight = floor(renderHeight / 2) * 2
                
                let composition = AVMutableComposition()
                guard let compositionTrack = composition.addMutableTrack(
                    withMediaType: .video,
                    preferredTrackID: kCMPersistentTrackID_Invalid
                ) else {
                    completion(url)
                    return
                }
                
                try compositionTrack.insertTimeRange(
                    CMTimeRange(start: .zero, duration: duration),
                    of: track,
                    at: .zero
                )
                
                let videoComposition = AVMutableVideoComposition()
                videoComposition.renderSize = CGSize(width: renderWidth, height: renderHeight)
                videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
                
                let instruction = AVMutableVideoCompositionInstruction()
                instruction.timeRange = CMTimeRange(start: .zero, duration: duration)
                
                let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrack)
                
                let xOffset = (width - renderWidth) / 2
                let yOffset = (height - renderHeight) / 2
                let transform = preferredTransform.concatenating(CGAffineTransform(translationX: -xOffset, y: -yOffset))
                layerInstruction.setTransform(transform, at: .zero)
                
                instruction.layerInstructions = [layerInstruction]
                videoComposition.instructions = [instruction]
                
                guard let exportSession = AVAssetExportSession(
                    asset: composition,
                    presetName: AVAssetExportPresetHighestQuality
                ) else {
                    completion(url)
                    return
                }
                
                let outputURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString + ".mov")
                exportSession.outputURL = outputURL
                exportSession.outputFileType = .mov
                exportSession.videoComposition = videoComposition
                
                await exportSession.export()
                
                if exportSession.status == .completed {
                    completion(outputURL)
                } else {
                    print("Video crop failed: \(String(describing: exportSession.error))")
                    completion(url)
                }
            } catch {
                print("Error processing video: \(error)")
                completion(url)
            }
        }
    }
}
