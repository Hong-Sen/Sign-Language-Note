//
//  AVCaptureFailureReason.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2023/03/10.
//

import Foundation

enum AVCaptureFailureReason: String {
    case deviceNotFound = "deviceNotFound"
    case couldNotCreateDeviceInput = "couldNotCreateDeviceInput"
    case couldNotAddInputToSession = "couldNotAddInputToSession"
    case couldNotAddOutputToSsession = "couldNotAddOutputToSsession"
    case couldNotCreatepreviewLayer = "couldNotCreatepreviewLayer"
    case failedVideoCaptureLockForConfiguration = "failedVideoCaptureLockForConfiguration"
}
