//
//  AppDelegate.swift
//  CopyAndSpeak
//
//  Created by Oliver Kocsis on 12/08/2021.
//

import Cocoa
import AVKit




@main
class AppDelegate: NSObject, NSApplicationDelegate {

  private var synthetiser: AVSpeechSynthesizer!
  private var hotKeyListener: HotKeyListener!
  private var isPaused: Bool = false
  
  private var onPaused: ((_ paused: Bool, _ utterance: AVSpeechUtterance?) -> ())?
  private var onContinued: ((_ continued: Bool, _ utterance: AVSpeechUtterance?) -> ())?


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    synthetiser = AVSpeechSynthesizer()
    synthetiser.delegate = self
    hotKeyListener = HotKeyListener()
    hotKeyListener.register()
    hotKeyListener.delegate = self
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
extension AppDelegate : UserActionDelegate {
  func toggleSpeak() {
    if synthetiser.isSpeaking {
      synthetiser.stopSpeaking(at: .immediate)
    }
    
    let pasteboard = NSPasteboard.general
    let stringItems =
      pasteboard.pasteboardItems?.compactMap({ item in
         return item.string(forType: .string)
      })
    let text = stringItems?.first ?? ""
    let utterance = AVSpeechUtterance(string: text)
    utterance.prefersAssistiveTechnologySettings = true
    isPaused = false
    synthetiser.speak(utterance)
  }
  
  func togglePause() {

    if isPaused == true {
      continueSpeaking { succ, utt in
        if succ {
          self.isPaused = false
        }
      }
      
    } else if isPaused == false {
      pauseSpeaking(at: .immediate) { succ, utt in
        if succ {
          self.isPaused = true
        }
      }
    }
  }
  
  func nextSentence() {
    
  }
  
  func rewindSentence() {
    
  }
  
  func nextParagraph() {
    
  }
  
  func rewindParagraph() {
    
  }
}

extension AppDelegate : AVSpeechSynthesizerDelegate {
  func pauseSpeaking(
    at boundary: AVSpeechBoundary,
    completion: @escaping (_ paused: Bool, _ utterance: AVSpeechUtterance?) -> ()
  ) {
    let succ = synthetiser.pauseSpeaking(at: boundary)
    print("paused \(succ)")
    onPaused = completion
  }
  
  func continueSpeaking(
    completion: @escaping (_ continued: Bool, _ utterance: AVSpeechUtterance?) -> ()
  ) {
    let succ = synthetiser.continueSpeaking()
    print("continued \(succ)")
    onContinued = completion
  }
  
  func speechSynthesizer(
    _ synthesizer: AVSpeechSynthesizer,
    didPause utterance: AVSpeechUtterance
  ) {
    onPaused?(true, utterance)
  }

  func speechSynthesizer(
    _ synthesizer: AVSpeechSynthesizer,
    didContinue utterance: AVSpeechUtterance
  ) {
    onContinued?(true, utterance)
  }
}

