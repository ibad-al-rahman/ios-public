//
//  Date+TimeComparison.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import Foundation

extension Date {
    func ltTime(_ rhs: Date) -> Bool {
        let lhs = self
        let lhsComponents = Calendar.current.dateComponents(
            [.hour, .minute], from: lhs
        )
        let rhsComponents = Calendar.current.dateComponents(
            [.hour, .minute], from: rhs
        )

        guard let lhsHour = lhsComponents.hour,
              let lhsMinute = lhsComponents.minute,
              let rhsHour = rhsComponents.hour,
              let rhsMinute = rhsComponents.minute
        else { return false }

        return if lhsHour < rhsHour {
            true
        } else if lhsHour == rhsHour && lhsMinute < rhsMinute {
            true
        } else if lhsHour == rhsHour && lhsMinute == rhsMinute {
            true
        } else {
            false
        }
    }
}
