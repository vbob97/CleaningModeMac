//
//  AppDelegate.swift
//  CleaningModeMacDFDSGHJKLJKJGHFDSasdfghjklhjgfd
//
//  Created by Vincenzo Bombace on 29/08/22.
//

import Cocoa
import Carbon
import Foundation

var dontForwardTap = false
func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType,event: CGEvent, refcon: UnsafeMutableRawPointer?)-> Unmanaged<CGEvent>?{
    if (dontForwardTap) {
        return nil;
    }
    return Unmanaged.passRetained(event)
}


//@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var  statusItem: NSStatusItem!
 
    func applicationDidFinishLaunching(_ aNotification: Notification) {
                
        statusItem=NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
        if let button = statusItem.button {
                    button.image = NSImage(systemSymbolName: "hand.raised", accessibilityDescription: "")
                }
        setupMenus()
        tapKeyboard()
    }
    func setupMenus() {
        
         let menu = NSMenu()

         let one = NSMenuItem(title: "Disable", action: #selector(didTapDisable) , keyEquivalent: "")
         menu.addItem(one)

         let two = NSMenuItem(title: "enable", action: #selector(didTapEnable) , keyEquivalent: "")
         menu.addItem(two)

         menu.addItem(NSMenuItem.separator())
         menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

         statusItem.menu = menu
     }

        @objc func didTapDisable() {
            print("Tastiera disabilita")
            dontForwardTap = true;
            changeStatusBarButton(dontForwardTap:dontForwardTap);
            
        }

        @objc func didTapEnable() {
            print("Tastiera abilitata")
            dontForwardTap = false;
            changeStatusBarButton(dontForwardTap:dontForwardTap);
        }
    
    private func changeStatusBarButton(dontForwardTap: Bool) {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: dontForwardTap==true ? "hand.raised.slash": "hand.raised" , accessibilityDescription: "")
        }
    }
    private func tapKeyboard() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
        guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                              place: .headInsertEventTap,
                                              options: .defaultTap,
                                              eventsOfInterest: CGEventMask(eventMask),
                                              callback: myCGEventCallback,
                                              userInfo: nil) else {
                                                print("failed to create event tap")
                                                exit(1)
        }

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }


}


