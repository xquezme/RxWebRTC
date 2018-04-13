//
//  CameraVideoCapturer+Rx.swift
//  Nimble
//
//  Created by Sergey Pimenov on 13/04/2018.
//

import Foundation
import WebRTC
import RxSwift
import AVFoundation

public extension Reactive where Base: RTCCameraVideoCapturer {
    public func startCapture(with device: AVCaptureDevice, format: AVCaptureDevice.Format, fps: Int) -> Single<Void> {
        return Single.create { observer in
            self.base.startCapture(with: device, format: format, fps: fps) { error in
                if NSNull.isEqual(error) {
                    observer(.error(error))
                }

                observer(.success(()))
            }

            return Disposables.create()
        }
    }

    public func stopCapture() -> Single<Void> {
        return Single.create { observer in
            self.base.stopCapture() {
                observer(.success(()))
            }

            return Disposables.create()
        }
    }
}
