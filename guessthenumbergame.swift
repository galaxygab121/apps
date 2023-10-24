import UIKit

class GuessTheNumberViewController: UIViewController {
    @IBOutlet var rangeLabel: UILabel!
    @IBOutlet var guessTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!

    var lowerBound = 1
    var upperBound = 100
    var numberOfTries = 0
    var secretNumber = 0
    var highScores: [String: Int] = [:]

    enum Difficulty {
        case easy, medium, hard
    }

    var currentDifficulty: Difficulty = .medium

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Guess The Number"
        updateRangeLabel()
        loadHighScores()
    }

    @IBAction func selectDifficulty(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentDifficulty = .easy
            lowerBound = 1
            upperBound = 50
        case 1:
            currentDifficulty = .medium
            lowerBound = 1
            upperBound = 100
        case 2:
            currentDifficulty = .hard
            lowerBound = 1
            upperBound = 200
        default:
            break
        }
        startNewGame()
        updateRangeLabel()
    }

    @IBAction func makeGuess(_ sender: Any) {
        numberOfTries += 1

        guard let guessText = guessTextField.text, let guess = Int(guessText) else {
            resultLabel.text = "Please enter a valid number."
            return
        }

        if guess == secretNumber {
            resultLabel.text = "Congratulations! You guessed it in \(numberOfTries) tries."
            updateHighScore()
            startNewGame()
        } else if guess < secretNumber {
            resultLabel.text = "Try a higher number."
        } else {
            resultLabel.text = "Try a lower number."
        }

        guessTextField.text = ""
    }

    func startNewGame() {
        numberOfTries = 0
        secretNumber = Int.random(in: lowerBound...upperBound)
        resultLabel.text = "Guess the number between \(lowerBound) and \(upperBound)."
    }

    func updateRangeLabel() {
        rangeLabel.text = "Guess a number between \(lowerBound) and \(upperBound)."
    }

    func loadHighScores() {
        if let savedHighScores = UserDefaults.standard.dictionary(forKey: "highScores") as? [String: Int] {
            highScores = savedHighScores
        }
        updateHighScoreLabel()
    }

    func updateHighScore() {
        if highScores[currentDifficultyDescription] == nil || numberOfTries < highScores[currentDifficultyDescription]! {
            highScores[currentDifficultyDescription] = numberOfTries
            saveHighScores()
            updateHighScoreLabel()
        }
    }

    func saveHighScores() {
        UserDefaults.standard.set(highScores, forKey: "highScores")
    }

    func updateHighScoreLabel() {
        if let highScore = highScores[currentDifficultyDescription] {
            highScoreLabel.text = "High Score: \(highScore) tries"
        } else {
            highScoreLabel.text = "High Score: N/A"
        }
    }

    var currentDifficultyDescription: String {
        switch currentDifficulty {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
}
