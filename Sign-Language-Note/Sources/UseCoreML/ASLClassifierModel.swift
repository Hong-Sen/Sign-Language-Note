//
//  ASLClassifier.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2023/02/04.
//

import Foundation

class ASLClassifierModel {
    var model = try? ASLHandClassifier(configuration: .init())
    var result: ASLHandClassifierOutput?
    
}
