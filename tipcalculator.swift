import UIKit

class TipCalculatorViewController: UIViewController {
    @IBOutlet var billAmountTextField: UITextField!
    @IBOutlet var tipPercentageSegmentedControl: UISegmentedControl!
    @IBOutlet var splitSlider: UISlider!
    @IBOutlet var splitLabel: UILabel!
    @IBOutlet var tipAmountLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel
    @IBOutlet var perPersonLabel: UILabel

    var billHistory: [BillHistory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tip Calculator"

        // Load bill history
        if let historyData = UserDefaults.standard.data(forKey: "billHistory"),
            let savedBillHistory = try? JSONDecoder().decode([BillHistory].self, from: historyData) {
            billHistory = savedBillHistory
        }
    }

    @IBAction func calculateTip(_ sender: Any) {
        guard let billAmountText = billAmountTextField.text, !billAmountText.isEmpty,
              let billAmount = Double(billAmountText) else {
            return
        }

        let tipPercentages = [0.15, 0.18, 0.20]
        let selectedTipPercentage = tipPercentages[tipPercentageSegmentedControl.selectedSegmentIndex]

        let tip = billAmount * selectedTipPercentage
        let total = billAmount + tip

        let numberOfPeople = Int(splitSlider.value)
        let perPersonAmount = total / Double(numberOfPeople)

        tipAmountLabel.text = String(format: "$%.2f", tip)
        totalAmountLabel.text = String(format: "$%.2f", total)
        perPersonLabel.text = String(format: "$%.2f per person", perPersonAmount)

        // Save the bill to history
        let historyEntry = BillHistory(billAmount: billAmount, tipPercentage: tipPercentageSegmentedControl.selectedSegmentIndex, totalAmount: total)
        billHistory.append(historyEntry)
        saveBillHistory()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let numberOfPeople = Int(sender.value)
        splitLabel.text = "Split: \(numberOfPeople) people"
    }

    func saveBillHistory() {
        if let encodedData = try? JSONEncoder().encode(billHistory) {
            UserDefaults.standard.set(encodedData, forKey: "billHistory")
        }
    }
}

struct BillHistory: Codable {
    let billAmount: Double
    let tipPercentage: Int
    let totalAmount: Double
}
