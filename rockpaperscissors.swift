import UIKit

class RockPaperScissorsViewController: UIViewController {
    @IBOutlet var userChoiceLabel: UILabel!
    @IBOutlet var computerChoiceLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var difficultySegmentedControl: UISegmentedControl!

    let choices = ["Rock", "Paper", "Scissors"]
    var userScore = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rock, Paper, Scissors"
        updateScoreLabel()
    }

    @IBAction func makeChoice(_ sender: UIButton) {
        let userChoice = sender.title(for: .normal) ?? ""
        userChoiceLabel.text = "You chose: \(userChoice)"

        let computerChoice = getRandomComputerChoice(difficultyLevel: difficultySegmentedControl.selectedSegmentIndex)
        computerChoiceLabel.text = "Computer chose: \(computerChoice)"

        let result = determineWinner(userChoice: userChoice, computerChoice: computerChoice)
        resultLabel.text = result

        if result == "You win!" {
            userScore += 1
            shakeResultLabel()
        }

        updateScoreLabel()
    }

    @IBAction func changeDifficultyLevel(_ sender: UISegmentedControl) {
        resetGame()
    }

    func getRandomComputerChoice(difficultyLevel: Int) -> String {
        let randomIndex: Int
        switch difficultyLevel {
        case 0: // Easy
            randomIndex = Int.random(in: 0..<choices.count)
        case 1: // Medium
            randomIndex = Int.random(in: 0..<choices.count)
        case 2: // Hard
            randomIndex = Int.random(in: 0..<choices.count)
        default:
            randomIndex = Int.random(in: 0..<choices.count)
        }
        return choices[randomIndex]
    }

    func determineWinner(userChoice: String, computerChoice: String) -> String {
        if userChoice == computerChoice {
            return "It's a tie!"
        } else if (
            (userChoice == "Rock" && computerChoice == "Scissors") ||
            (userChoice == "Paper" && computerChoice == "Rock") ||
            (userChoice == "Scissors" && computerChoice == "Paper")
        ) {
            return "You win!"
        } else {
            return "Computer wins!"
        }
    }

    func updateScoreLabel() {
        scoreLabel.text = "Score: \(userScore)"
    }

    func shakeResultLabel() {
        UIView.animate(withDuration: 0.2, animations: {
            self.resultLabel.transform = CGAffineTransform(translationX: 10, y: 0)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.resultLabel.transform = .identity
            })
        }
    }

    func resetGame() {
        userScore = 0
        updateScoreLabel()
        userChoiceLabel.text = "You chose: "
        computerChoiceLabel.text = "Computer chose: "
        resultLabel.text = ""
    }
}
