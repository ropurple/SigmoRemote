//
//  ConfigResponse.swift
//  Sigmo
//
//  Created by Sebastian Guzman on 06-12-17.
//  Copyright © 2017 Skybiz. All rights reserved.
//

import Foundation
import GRDB

public class ConfigResponse : Codable {
    public var con_nombre: String? = nil
    public var con_url: String? = nil
    public var con_imei: String? = nil
    public var State: Int = 0
    public var Message: String = ""
    public var version: String? = nil
    
}

extension ConfigResponse : TableMapping, Persistable, RowConvertible {
    public static let databaseTableName = "config"
}

/*extension ConfigResponse : RowConvertible {
    public init(row: Row) {
        con_nombre = row["con_nombre"]
        con_url = row["con_url"]
        con_ftp_ip = row["con_ftp_ip"]
        con_ftp_port = row["con_ftp_port"]
        con_ftp_user = row["con_ftp_user"]
        con_ftp_pass = row["con_ftp_pass"]
        con_ftp_path = row["con_ftp_path"]
        State = row["State"]
        Message = row["Message"]
    }
}*/
