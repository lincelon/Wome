//
//  EnviromentValues+Extension.swift
//  Wome
//
//  Created by Maxim Soroka on 29.05.2021.
//

import SwiftUI
import Combine

extension EnvironmentValues {
  var orientationPublisher: AnyPublisher<UIDeviceOrientation, Never> {
      Publishers.deviceOrientation
  }
}
