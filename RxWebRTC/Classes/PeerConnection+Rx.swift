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
    public func stats(
        for mediaStreamTrack: RTCMediaStreamTrack? = nil,
        statsOutputLevel: RTCStatsOutputLevel = .standard
    ) -> Single<[RTCLegacyStatsReport]> {
        return Single.create { observer in
            self.base.stats(for: mediaStreamTrack, statsOutputLevel: statsOutputLevel) { reports in
                observer(.success(reports))
            }

            return Disposables.create()
        }
    }

    public func set(remoteDescription: RTCSessionDescription) -> Single<Void> {
        return Single.create { observer in
            self.base.setRemoteDescription(remoteDescription) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }

                observer(.success(()))
            }

            return Disposables.create()
        }
    }

    public func set(localDescription: RTCSessionDescription) -> Single<Void> {
        return Single.create { observer in
            self.base.setLocalDescription(localDescription) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }

                observer(.success(()))
            }

            return Disposables.create()
        }
    }

    public func offer(forConstraints constraints: RTCMediaConstraints) -> Single<RTCSessionDescription> {
        return Single.create { observer in
            self.base.offer(for: constraints) { sd, error in
                if let error = error {
                    observer(.error(error))
                    return
                }

                observer(.success(sd!))
            }

            return Disposables.create()
        }
    }

    public func answer(forConstraints constraints: RTCMediaConstraints) -> Single<RTCSessionDescription> {
        return Single.create { observer in
            self.base.answer(for: constraints) { sd, error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                
                observer(.success(sd!))
            }

            return Disposables.create()
        }
    }
}
