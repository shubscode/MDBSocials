//
//  LyftHelper.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 3/13/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import Foundation
import LyftSDK
import CoreLocation

class LyftHelper {

    static func getRideEstimate(pickup: CLLocationCoordinate2D, dropoff: CLLocationCoordinate2D, withBlock: @escaping ((Cost)) -> ()){
        print("Getting lyft estimate")
        LyftAPI.costEstimates(from: pickup, to: dropoff, rideKind: .Standard) { result in
            result.value?.forEach { costEstimate in
                print("Finished")
                withBlock(costEstimate)
            }
        }
    }
}

