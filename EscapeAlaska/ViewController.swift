//
//  ViewController.swift
//  EscapeAlaska
//
//  Created by Lukas Yi on 6/29/25.
//

import UIKit

struct Question {
    init (_ ques: String, _ opt1: String,_ opt2: String){
        question = ques
        option1 = opt1
        option2 = opt2
    }
    var question: String
    var option1: String
    var option2: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var option1: UIStackView!
    var index = 0
    var lastChoice: Int? = nil
    var endingIndex: Int? = nil
    
    let question = [
        Question("You are stuck in the Alaskan wilderness and need to escape to civilization. Which do you do?","Walk towards the nearest river","Walk through the forest" ),
        Question("You come across a fork in the path. Which do you take?","Follow the path that looks less traveled","Follow the path that looks more traveled"),
        Question("The river is swollen and dangerous. You must find another way to escape.","Try to wade across the river","Search for another path"),
        Question("There is a cabin in the distance", "Go to the cabin", "Keep walking"),
        Question("There is a figure in the woods up ahead.","Approach the figure","Run"),
        Question("You find a map of the area.","Follow the map towards civilization","Trust your instincts and keep walking"),
        Question("You are soaked and need shelter.","Find a tree to build a shelter","Search for a nearby cave")
        ]
    let backgroundImages = [
        "start",
        "fork",
        "river",
        "cabin",
        "figure",
        "map",
        "shelter"
    ]

    let nextIndex = [
        [2, 1],
        [4, 3],
        [6, 5]
    ]
    
    let winQuestionIndex = 4
    let winChoiceIndex = 0
    
    let endingMessages = [
        [],
        [],
        [],
        [
            "Nobody was there and you froze to death waiting.",
            "You starved to death searching for escape."
        ],
        [
            "The figure was a hermit who guided you towards civilization.",
            "You tripped on a rock and hit your head, killing you."
        ],
        [
            "The map guided you to a cliff and you fell off.",
            "Your instincts guided you to a territorial moose that trampled you."
        ],
        [
            "The tree was dead and a large branch fell and hit you on the head.",
            "The cave had a hungry brown bear that mauled you."
        ]
    ]
    
    @IBAction func choice(_ sender: UIButton) {
        let choice = (sender == option1.arrangedSubviews[0]) ? 0 : 1
        lastChoice = choice

        if index == winQuestionIndex && choice == winChoiceIndex {
            index = -1
            updateUI()
            showResetButton()
            return
        }

        if index < nextIndex.count {
            index = nextIndex[index][choice]
            updateUI()
        } else {
            endingIndex = index  // ✅ Save the real question before failure
            index = question.count
            updateUI()
            showResetButton()
        }
    }
    
    @objc func resetGame() {
        index = 0
        endingIndex = nil
        updateUI()
        if let button = option1.arrangedSubviews[0] as? UIButton {
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addTarget(self, action: #selector(choice(_:)), for: .touchUpInside)
        }
        if option1.arrangedSubviews.count >= 2 {
            option1.arrangedSubviews[1].isHidden = false
        }
    }
    func showResetButton() {
        if option1.arrangedSubviews.count >= 2 {
            if let button = option1.arrangedSubviews[0] as? UIButton {
                button.setTitle("Reset", for: .normal)
                button.removeTarget(nil, action: nil, for: .allEvents)
                button.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
            }
            option1.arrangedSubviews[1].isHidden = true
        }
    }
    
    func updateUI() {
        if index >= 0 && index < question.count {
            message.text = question[index].question
            background.image = UIImage(named: backgroundImages[index])
            if option1.arrangedSubviews.count >= 2 {
                if let button1 = option1.arrangedSubviews[0] as? UIButton {
                    button1.setTitle(question[index].option1, for: .normal)
                }
                if let button2 = option1.arrangedSubviews[1] as? UIButton {
                    button2.setTitle(question[index].option2, for: .normal)
                }
            }
            option1.isHidden = false
        } else if index == -1 {
            message.text = "The figure was a hermit who guided you towards civilization. 🎉 You found help and escaped! You survived Alaska!"
            background.image = UIImage(named: "start")
        } else {
            if let questionIndex = endingIndex,
               let choice = lastChoice,
               questionIndex >= 0,
               questionIndex < endingMessages.count,
               choice < endingMessages[questionIndex].count {
                message.text = "❌ \(endingMessages[questionIndex][choice])"
            } else {
                message.text = "❌ You got lost in the Alaskan wilderness. Try again."
            }

            background.image = UIImage(named: "start")

            if option1.arrangedSubviews.count >= 2 {
                option1.arrangedSubviews[1].isHidden = true
            }
        }
        if index < 0 || index >= question.count {
            if option1.arrangedSubviews.count >= 2 {
                option1.arrangedSubviews[1].isHidden = true
            }
        }
    }
}


