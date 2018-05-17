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
    public func startCapture(with device: AVCaptureDevice, format: AVCaptureDevice.Format, fps: Int) -> Observable<Void> {
        return Observable<Void>.create { [weak pc = self.base] observer in
            guard let pc = pc else {
                observer.onCompleted()
                return Disposables.create()
            }

            pc.startCapture(with: device, format: format, fps: fps) { error in
                if NSNull.isEqual(error) {
                    observer.onError(error)
                    return
                }

                observer.onNext(())
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    public func stopCapture() -> Observable<Void> {
        return Observable<Void>.create { [weak pc = self.base] observer in
            guard let pc = pc else {
                observer.onCompleted()
                return Disposables.create()
            }

            pc.stopCapture() {
                observer.onNext(())
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}
