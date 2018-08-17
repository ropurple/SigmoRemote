 //
//  AppDelegate.swift
//  Sigmo
//
//  Created by macOS User on 07/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let database = try! setupDatabase(application)
        print(database)
        IQKeyboardManager.shared.enable = true // muestra teclado inteligente
        UIApplication.shared.setMinimumBackgroundFetchInterval(60)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        subirActividadesPendientes{ (success, estado) -> () in
            if success {
                if estado == 1 {
                    print("OK, estado:", estado)
                    completionHandler(.newData)
                }
                if estado == 2 {
                    print("actividades offline pendientes por subir //Estado:", estado)
                    completionHandler(.failed)
                }
                if estado == 3 {
                    print("No hay actividades Pendientes.// Estado:", estado)
                    completionHandler(.noData)
                }
                
                let log = Log(id_usuario: userID!, log_fecha: formatearFecha(fecha: Date()), log_tabla: "actividad", log_msje: "Realiza el proceso en background")
                
                if insertLog(log: log) {
                    print("Log: OK")
                }
            }
            else{
                print("ERROR", estado)
                completionHandler(.failed)
            }
        
        }

    }// --- END FUNCTION
    
 }// ----- END CLASS ------

