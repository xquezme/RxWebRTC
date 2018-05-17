//
//  PeerConnection+Rx.swift
//  RxWebRTC
//
//  Created by Sergey Pimenov on 13/04/2018.
//

import Foundation
import WebRTC
import RxSwift
import RxCocoa

public extension Reactive where Base: RTCPeerConnection {
    public func stats(for mediaStreamTrack: RTCMediaStreamTrack? = nil, statsOutputLevel: RTCStatsOutputLevel = .standard) -> Observable<[RTCLegacyStatsReport]> {
        return Observable<[RTCLegacyStatsReport]>.create { [weak pc = self.base] observer in
            guard let pc = pc else {
                observer.onCompleted()
                return Disposables.create()
            }

            pc.stats(for: mediaStreamTrack, statsOutputLevel: statsOutputLevel) { reports in
                observer.onNext(reports)
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    public func set(remoteDescription: RTCSessionDescription) -> Observable<Void> {
        return Observable<Void>.create { [weak pc = self.base] observer in
            guard let pc = pc else {
                observer.onCompleted()
                return Disposables.create()
            }

            pc.setRemoteDescription(remoteDescription) { error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                observer.onNext(())
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    public func set(localDescription: RTCSessionDescription) -> Observable<Void> {
        return Observable<Void>.create { [weak pc = self.base] observer in
            guard let pc = pc else {
                observer.onCompleted()
                return Disposables.create()
            }

            pc.setLocalDescription(localDescription) { error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                observer.onNext(())
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    public func offer(forConstraints constraints: RTCMediaConstraints) -> Observable<RTCSessionDescription> {
        return Observable<RTCSessionDescription>.create { [weak pc = self.base] observer in
            guard let pc = pc else {
                observer.onCompleted()
                return Disposables.create()
            }

            pc.offer(for: constraints) { sd, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                if let sd = sd {
                    observer.onNext(sd)
                }

                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    public func answer(forConstraints constraints: RTCMediaConstraints) -> Observable<RTCSessionDescription> {
        return Observable<RTCSessionDescription>.create { [weak pc = self.base] observer in
            guard let pc = pc else {
                observer.onCompleted()
                return Disposables.create()
            }

            pc.answer(for: constraints) { sd, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                if let sd = sd {
                    observer.onNext(sd)
                }

                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}
