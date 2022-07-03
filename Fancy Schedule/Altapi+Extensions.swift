//
//  Altapi+Extensions.swift
//  Fancy Schedule
//
//  Created by Krystian Postek on 03/07/2022.
//

import Foundation
import Altapi

extension AltapiEntry {
    var beginDate: Date {
        Date(detectFromString: begin)!
    }
    
    var endDate: Date {
        Date(detectFromString: end)!
    }
}
