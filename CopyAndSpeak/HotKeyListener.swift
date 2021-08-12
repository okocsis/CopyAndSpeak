//
//  HotkeyListener.swift
//  CopyAndSpeak
//
//  Created by Oliver Kocsis on 12/08/2021.
//

import Foundation
import MASShortcut

protocol UserActionDelegate : AnyObject {
  func toggleSpeak()
  func togglePause()
  
  func nextSentence()
  func rewindSentence()
  
  func nextParagraph()
  func rewindParagraph()
}

private let cmd_j =
  MASShortcut(
    keyCode: 38,
    modifierFlags: .command
  )
private let cmd_k =
  MASShortcut(
    keyCode: 40,
    modifierFlags: .command
  )
private let alt_cmd_j =
  MASShortcut(
    keyCode: 38,
    modifierFlags: [.option, .command]
  )
private let alt_cmd_k =
  MASShortcut(
    keyCode: 40,
    modifierFlags: [.option, .command]
  )
private let ctrl_alt_cmd_j =
  MASShortcut(
    keyCode: 38,
    modifierFlags: [.control, .option, .command]
  )
private let ctrl_alt_cmd_k =
  MASShortcut(
    keyCode: 40,
    modifierFlags: [.control, .option, .command]
  )

class HotKeyListener {
  
  weak var delegate: UserActionDelegate?
  func register() {
    let monitor = MASShortcutMonitor.shared()!
    
    monitor.register(cmd_j) {
      self.delegate?.toggleSpeak()
    }
    monitor.register(cmd_k) {
      self.delegate?.togglePause()
    }
    monitor.register(alt_cmd_j) {
      self.delegate?.nextSentence()
    }
    monitor.register(alt_cmd_k) {
      self.delegate?.rewindSentence()
    }
    monitor.register(ctrl_alt_cmd_j) {
      self.delegate?.nextParagraph()
    }
    monitor.register(ctrl_alt_cmd_k) {
      self.delegate?.rewindParagraph()
    }
  }
}
