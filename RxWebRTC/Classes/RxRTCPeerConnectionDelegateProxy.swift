//
//  RxRTCPeerConnectionDelegateProxy.swift
//  RxWebRTC
//
//  Created by Sergey Pimenov on 13/04/2018.
//

import Foundation
import RxSwift
import RxCocoa
import WebRTC

class RxRTCPeerConnectionDelegateProxy
    : DelegateProxy<RTCPeerConnection, RTCPeerConnectionDelegate>
    , DelegateProxyType
    , RTCPeerConnectionDelegate {

    fileprivate let signalingStateSignal = PublishSubject<RTCSignalingState>()
    fileprivate let iceConnectionStateSignal = PublishSubject<RTCIceConnectionState>()
    fileprivate let iceGatheringStateSignal = PublishSubject<RTCIceGatheringState>()
    fileprivate let iceCandidateAddedSignal = PublishSubject<RTCIceCandidate>()
    fileprivate let iceCandidatesRemovedSignal = PublishSubject<[RTCIceCandidate]>()
    fileprivate let shouldNegotiateSignal = PublishSubject<Void>()
    fileprivate let streamAddedSignal = PublishSubject<RTCMediaStream>()
    fileprivate let streamRemovedSignal = PublishSubject<RTCMediaStream>()
    fileprivate let dataChannelOpened = PublishSubject<RTCDataChannel>()

    /// Typed parent object.
    weak private(set) var peerConnection: RTCPeerConnection?

    /// - parameter peerConnection: Parent object for delegate proxy.
    init(peerConnection: ParentObject) {
        self.peerConnection = peerConnection
        super.init(parentObject: peerConnection, delegateProxy: RxRTCPeerConnectionDelegateProxy.self)
    }

    // Register known implementations
    static func registerKnownImplementations() {
        self.register { RxRTCPeerConnectionDelegateProxy(peerConnection: $0) }
    }

    /// For more information take a look at `DelegateProxyType`.
    class func currentDelegate(for object: ParentObject) -> RTCPeerConnectionDelegate? {
        return object.delegate
    }

    /// For more information take a look at `DelegateProxyType`.
    class func setCurrentDelegate(_ delegate: RTCPeerConnectionDelegate?, to object: ParentObject) {
        object.delegate = delegate
    }

    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        self.shouldNegotiateSignal.onNext(())
        self.forwardToDelegate()?.peerConnectionShouldNegotiate(peerConnection)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        self.streamAddedSignal.onNext(stream)
        self.forwardToDelegate()?.peerConnection(peerConnection, didAdd: stream)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        self.streamRemovedSignal.onNext(stream)
        self.forwardToDelegate()?.peerConnection(peerConnection, didRemove: stream)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        self.dataChannelOpened.onNext(dataChannel)
        self.forwardToDelegate()?.peerConnection(peerConnection, didOpen: dataChannel)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        self.iceCandidateAddedSignal.onNext(candidate)
        self.forwardToDelegate()?.peerConnection(peerConnection, didGenerate: candidate)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        self.iceCandidatesRemovedSignal.onNext(candidates)
        self.forwardToDelegate()?.peerConnection(peerConnection, didRemove: candidates)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        self.iceGatheringStateSignal.onNext(newState)
        self.forwardToDelegate()?.peerConnection(peerConnection, didChange: newState)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        self.iceConnectionStateSignal.onNext(newState)
        self.forwardToDelegate()?.peerConnection(peerConnection, didChange: newState)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        self.signalingStateSignal.onNext(stateChanged)
        self.forwardToDelegate()?.peerConnection(peerConnection, didChange: stateChanged)
    }

    deinit {
        self.signalingStateSignal.onCompleted()
        self.iceConnectionStateSignal.onCompleted()
        self.iceGatheringStateSignal.onCompleted()
        self.iceCandidateAddedSignal.onCompleted()
        self.iceCandidatesRemovedSignal.onCompleted()
        self.shouldNegotiateSignal.onCompleted()
        self.streamAddedSignal.onCompleted()
        self.streamRemovedSignal.onCompleted()
        self.dataChannelOpened.onCompleted()
    }
}


public extension Reactive where Base: RTCPeerConnection {
    public var signalingStateChanged: Observable<RTCSignalingState> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).signalingStateSignal.asObservable()
    }

    public var iceConnectionStateChanged: Observable<RTCIceConnectionState> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).iceConnectionStateSignal.asObservable()
    }

    public var iceGatheringStateChanged: Observable<RTCIceGatheringState> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).iceGatheringStateSignal.asObservable()
    }

    public var iceCandidateAdded: Observable<RTCIceCandidate> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).iceCandidateAddedSignal.asObservable()
    }

    public var iceCandidatesRemoved: Observable<[RTCIceCandidate]> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).iceCandidatesRemovedSignal.asObservable()
    }

    public var shouldNegotiate: Observable<Void> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).shouldNegotiateSignal.asObservable()
    }

    public var streamAdded: Observable<RTCMediaStream> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).streamAddedSignal.asObservable()
    }

    public var streamRemoved: Observable<RTCMediaStream> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).streamRemovedSignal.asObservable()
    }

    public var dataChannelOpened: Observable<RTCDataChannel> {
        return RxRTCPeerConnectionDelegateProxy.proxy(for: self.base).dataChannelOpened.asObservable()
    }
}
