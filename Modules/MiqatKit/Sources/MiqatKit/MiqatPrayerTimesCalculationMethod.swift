//
//  MiqatPrayerTimesCalculationMethod.swift
//  MiqatKit
//
//  Created by Hamza Jadid on 27/03/2026.
//

import Miqat

public enum MiqatPrayerTimesCalculationMethod: Equatable {
    case astronomical(Miqat.Method)
    case precomputed(Miqat.Provider)
}
