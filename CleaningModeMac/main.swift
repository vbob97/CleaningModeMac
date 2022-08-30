//
//  main.swift
//  CleaningModeMac
//
//  Created by Vincenzo Bombace on 29/08/22.
//

import Cocoa
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
