import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBAction func addCategoryTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Yeni Kategori", message: "Kategori adını girin", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Kategori Adı"
        }

        let addAction = UIAlertAction(title: "Ekle", style: .default) { _ in
            if let categoryName = alert.textFields?.first?.text, !categoryName.isEmpty {
                self.categories.append(categoryName)
                self.tableView.reloadData()
                self.saveCategories()
            }
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    // TableView outlet'imiz zaten bağlandı
    @IBOutlet weak var tableView: UITableView!

    // Kategorileri tutacak dizi
    var categories = [
        "Doğum Günü",
        "Yeni İş",
        "Yıldönümü",
        "Tebrik",
        "Özel Gün",
        "İyi Dilek",
        "Sevgililer Günü",
        "Anneler Günü",
        "Babalar Günü",
        "Bayram Kutlaması",
        "Geçmiş Olsun",
        "Başsağlığı",
        "Kandil Mesajı",
        "Öğretmenler Günü",
        "Yeni Yıl Kutlaması",
        "Ramazan Bayramı",
        "Kurban Bayramı",
        "Hoş Geldin Bebek",
        "Evlenme Tebriği",
        "Mezuniyet Kutlaması"
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories() // Kayıtlı kategorileri çekiyoruz, yeterli.
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        
        // Gölge efekti
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessages" {
            if let destinationVC = segue.destination as? MessageViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories[indexPath.row]
            }
        }
    }
    func saveCategories() {
        UserDefaults.standard.set(categories, forKey: "categories")
    }

    func loadCategories() {
        if let savedCategories = UserDefaults.standard.array(forKey: "categories") as? [String] {
            categories = savedCategories
        }
    }



}
