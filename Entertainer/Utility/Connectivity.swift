//
//  Connectivity.swift
//  Entertainer
//
//  Created by Nikhil Bansal on 04/03/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//
import Foundation
import Alamofire
class Connectivity {

    class var isNotConnectedToInternet:Bool {
        return !NetworkReachabilityManager()!.isReachable
    }
}
