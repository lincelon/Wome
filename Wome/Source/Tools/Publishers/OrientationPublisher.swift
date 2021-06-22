//
//  OrientationPublisher.swift
//  Wome
//
//  Created by Maxim Soroka on 29.05.2021.
//

import Combine
import UIKit

extension Publishers {
    static var deviceOrientation = {
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
         .receive(on: DispatchQueue.main)
         .compactMap { ($0.object as? UIDevice)?.orientation }
         .filter { $0.rawValue != 0 }
         .eraseToAnyPublisher()
     }()
}

