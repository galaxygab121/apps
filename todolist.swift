import UIKit
import CoreData

class TodoItem: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var isDone: Bool
}

class TodoListViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<TodoItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To-Do List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        setupCoreData()
        performFetch()
    }

    func setupCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }

        managedObjectContext = appDelegate.persistentContainer.viewContext
    }

    func performFetch() {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    // ... Rest of the code remains the same as the previous version.

    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter task"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let taskTitle = alertController.textFields?.first?.text, !taskTitle.isEmpty {
                let newItem = TodoItem(context: self.managedObjectContext)
                newItem.title = taskTitle
                newItem.isDone = false

                do {
                    try self.managedObjectContext.save()
                } catch {
                    print("Error saving new item: \(error)")
                }

                self.performFetch()
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    // Handle task completion
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        item.isDone.toggle()

        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving item: \(error)")
        }

        tableView.reloadData()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = TodoListViewController(style: .plain)
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
