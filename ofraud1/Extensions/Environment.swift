//
//  Environment.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authenticationController =  AuthenticationController(httpClient: HTTPClient())
    
}

