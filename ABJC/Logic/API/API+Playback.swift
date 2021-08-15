//
//  API+Playback.swift
//  ABJC
//
//  Created by Noah Kamara on 03.04.21.
//

import Foundation
import AVFoundation

extension API {
    public static func playerItem(
        _ jellyfin: Jellyfin,
        _ item: Playable,
        _ mediaSourceId: String
    ) -> AVURLAsset? {
        Self.logger.info("[PLAYBACK] playerItem")
        Self.logger.debug("[PLAYBACK] playerItem - item=\(item.id), itemId=\(item.id), mediaSourceId=\(mediaSourceId)")
        let path = "/videos/\(item.id)/master.m3u8"
        let params = [
            "DeviceId": jellyfin.client.deviceId,
            "MediaSourceId": mediaSourceId,
            "VideoCodec": "h264,h265,avc,hevc",
            "AudioStreamIndex": "1",
            "AudioCodec": "aac,mp3,ac3,eac3",
            "VideoBitrate": "139360000",
            "AudioBitrate": "640000",
            "TranscodingMaxAudioChannels": "6",
            "RequireAvc": "false",
            "SegmentContainer": "ts",
            "MinSegments": "2",
            "BreakOnNonKeyFrames": "true",
            "h264-profile": "high,main,baseline,constrainedbaseline",
            "h264-level": "51",
            "h264-deinterlace": "true",
            "TranscodeReasons": "VideoCodecNotSupported,AudioCodecNotSupported"
        ]
        
        // Make URL
        var urlComponents = URLComponents()
        urlComponents.scheme = jellyfin.server.https ? "https" : "http"
        urlComponents.host = jellyfin.server.host
        urlComponents.port = jellyfin.server.port
        
        urlComponents.path = jellyfin.server.path ?? "" + path
        
        // URL Query Parameters
        urlComponents.queryItems = params.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
        
        guard let url = urlComponents.url else {
            Self.logger.info("[PLAYBACK] playerItem - failure 'could not generate URL'")
            return nil
        }
        
        // Make Request
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        let version = "1.0.0"
        let authorization = [
            "Emby Client=ABJC",
            "Device=ATV",
            "DeviceId=\(jellyfin.client.deviceId)",
            "Version=\(version)"
        ]
        
        let options = [
            "AVURLAssetHTTPHeaderFieldsKey": [
                "Content-type": "application/json",
                "X-Emby-Authorization": authorization.joined(separator: ", "),
                "X-Emby-Token": jellyfin.user.accessToken
            ]
        ]
        let item = AVURLAsset(url: url, options: options)
        return item
    }
    
    
    public static func reportPlaystate(
        _ jellyfin: Jellyfin,
        _ event: APIModels.PlaystateReport.Event,
        _ itemId: String,
        _ mediaSourceId: String,
        _ state: Playstate
    ) {
        Self.logger.info("[PLAYBACK] reportPlaystate")
        Self.logger.debug("[PLAYBACK] reportPlaystate - event=\(event.rawValue), itemId=\(itemId), mediaSourceId=\(mediaSourceId)")
        var path = ""
        
        switch event {
            case .started: path = "/Sessions/Playing"
            case .stopped: path = "/Sessions/Playing/Stopped"
            case .progress: path = "/Sessions/Playing"
        }
        
        let report = APIModels.PlaystateReport(itemId, mediaSourceId, state)
        Self.logger.info("Sending PlaystateReport \(event.rawValue)")
        
        do {
            let data = try JSONEncoder().encode(report)
            API.request(jellyfin, path, .post, [:], data) { result in
                switch result {
                    case .success(_ ):
                        Self.logger.info("[PLAYBACK] reportPlaystate - success")
                    case .failure(let error):
                        Self.logger.error("[PLAYBACK] reportPlaystate - failure '\(error.localizedDescription)'")
                }
            }
        } catch {
            Self.logger.error("[PLAYBACK] reportPlaystate - failure 'Could not encode'")
            return
        }
        
    }
}
