//
//  SyncResponse.swift
//  Sigmo
//
//  Created by Sebastian Guzman on 06-12-17.
//  Copyright © 2017 Skybiz. All rights reserved.
//

import Foundation

public class SyncResponse<T:Codable> : Codable {
    public var Total: Int? = 0
    public var Page: Int? = 0
    public var Pages: Int? = 0
    public var State: Int? = 0
    public var Message: String? = ""
    public var fec_app: String? = ""
    public var Delete: String? = ""
    public var Data: Array<T> = Array<T>()
}
