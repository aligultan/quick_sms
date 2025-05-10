import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // TableView outlet'imiz zaten bağlandı
    @IBOutlet weak var tableView: UITableView!

    // Kategorileri tutacak dizi
    let categories = ["Doğum Günü", "Yeni İş", "Yıldönümü", "Tebrik", "Özel Gün", "İyi Dilek"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView'ın delegate ve dataSource bağlantısı
        tableView.delegate = self
        tableView.dataSource = self
    }

    // TableView satır sayısını belirleyen fonksiyon
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    // TableView hücrelerini oluşturan fonksiyon
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessages" {
            if let destinationVC = segue.destination as? MessageViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories[indexPath.row]
            }
        }
    }

}

