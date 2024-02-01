//
//  ViewController.swift
//  CombineWarmUp
//
//  Created by Azizbek Asadov on 01/02/24.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var timerLabel: UILabel!
    
    private var subscriptions: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startAction = UIAction { [weak self] _ in
            self?.startTimer()
        }
        startButton.addAction(startAction, for: .primaryActionTriggered)
        
        let stopAction = UIAction { [weak self] _ in
            self?.stopTimer()
        }
        stopButton.addAction(stopAction, for: .primaryActionTriggered)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewLayoutMarginsDidChange()
        
        [startButton, stopButton].forEach { $0?.layer.cornerRadius = 12.0 }
    }

    @objc
    private func startTimer() {
        startButton.isEnabled = false
        
        subscriptions = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .scan(0, { count, _ in
                count + 1
            })
            .sink(receiveCompletion: { _ in
                print("Finished count")
            }, receiveValue: { [weak self] in
                print("Current count: \($0)")
                self?.timerLabel.text = $0.formatted
            })
    }
    
    @objc
    private func stopTimer() {
        startButton.isEnabled = true
        timerLabel.text = "00:00:00"
        subscriptions?.cancel()
    }
}

extension Int {
    var formatted: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        
        let formattedString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return formattedString
    }
}
