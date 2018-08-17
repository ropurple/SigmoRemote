//
//  Config.swift
//  Sigmo
//
//  Created by Sebastian Guzman on 06-12-17.
//  Copyright © 2017 Skybiz. All rights reserved.
//

import Foundation
import UIKit
    
public class Config {
    public static var config: ConfigResponse {
        do {
            let data = UserDefaults.standard.data(forKey: "Config")
            return try JSONDecoder().decode(ConfigResponse.self, from: data!)
        } catch let error {
            self.error(State: 0, Message: error.localizedDescription)
            return self.config
        }
    }
    
    public static var equ_imei : String {
        guard let equ_imei = UIDevice.current.identifierForVendor?.uuidString else { return "" }
        return equ_imei
    }
    
    private static func error(State: Int, Message: String) {
        let config = ConfigResponse()
        config.State = State
        config.Message = Message
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(config)
            UserDefaults.standard.set(jsonData, forKey: "Config")
        }catch{
        }
    }
    
    public static func Get(equ_imei:String, ver_nombre:String, success: @escaping (Bool, String)->()){
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        let app_config_url = URL(string: "http://www.copec.cl/sigmo/?action=app_config")
        var request = URLRequest(url: app_config_url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "equ_imei="+equ_imei+"&id_tipoequipo=2&ver_nombre="+ver_nombre
        request.httpBody = postString.data(using: .utf8)
       let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                if(!launchedBefore){
                    self.error(State: 0, Message: error!.localizedDescription)
                }
                success(false, error!.localizedDescription)
                return
            }
            guard let data = data else { return success(false, "updateConfig Data Error") }
            do {
                let response = try JSONDecoder().decode(ConfigResponse.self, from: data)
                if(response.State == 1){
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                }
                
                //dump(data)
                
                UserDefaults.standard.set(data, forKey: "Config")
                success(true, "")
                return
            } catch let jsonError {
                if(!launchedBefore){
                    self.error(State: 0, Message: jsonError.localizedDescription)
                }
                success(false, jsonError.localizedDescription)
                return
            }
        }
        task.resume()
        return
    }
}
