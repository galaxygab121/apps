import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sentenceTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel

    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup after loading the view, if needed.
    }

    @IBAction func generatePassword(_ sender: UIButton) {
        if let sentence = sentenceTextField.text, !sentence.isEmpty {
            let password = generatePassword(from: sentence)
            passwordLabel.text = password
        }
    }

    func generatePassword(from sentence: String) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        var password = ""

        for _ in 0..<12 { // Generate a 12-character password
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            password.append(randomCharacter)
        }

        return password
    }
}
