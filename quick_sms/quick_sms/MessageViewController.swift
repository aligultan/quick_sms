import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var selectedCategory: String?
    var messagesToShow: [String] = []

    // Sabit mesaj şablonları
    let messageTemplates: [String: [String]] = [
        "Doğum Günü": ["Nice mutlu yıllara! 🎉", "Yeni yaşın sağlık ve mutluluk getirsin!", "Doğum günün kutlu olsun! 🎂"],
        "Yeni İş": ["Yeni işinde başarılar dilerim!", "Başarı dolu bir kariyer dilerim!", "Yeni işin hayırlı olsun! 👔"],
        "Yıldönümü": ["Mutluluğunuz daim olsun!", "Nice yıllara birlikte!", "Yıldönümünüz kutlu olsun! ❤️"],
        "Tebrik": ["Tebrik ederim, harikasın! 🎉", "Başarını kutluyorum!", "Bravo, çok güzel haber! 👏"],
        "Özel Gün": ["Bugünün senin için özel olmasını dilerim!", "Harika bir gün geçir!", "Özel günlerin hep mutlu geçsin!"],
        "İyi Dilek": ["Her şey gönlünce olsun!", "Bol şans! 🍀", "İyi günler dilerim! ☀️"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        if let category = selectedCategory {
            self.title = category
            loadMessages()

            // Eğer hiç kayıtlı mesaj yoksa, varsayılanları yükle
            if messagesToShow.isEmpty {
                messagesToShow = messageTemplates[category] ?? []
            }
        }
    }

    @IBAction func addMessageTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Yeni Mesaj", message: "Mesaj içeriğini girin", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Mesaj..."
        }

        let addAction = UIAlertAction(title: "Ekle", style: .default) { _ in
            if let message = alert.textFields?.first?.text, !message.isEmpty {
                self.messagesToShow.append(message)
                self.tableView.reloadData()
                self.saveMessages()  // Kaydediyoruz
            }
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    // TableView Fonksiyonları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        cell.textLabel?.text = messagesToShow[indexPath.row]
        return cell
    }

    // Kayıt Fonksiyonları
    func saveMessages() {
        if let category = selectedCategory {
            UserDefaults.standard.set(messagesToShow, forKey: "messages_\(category)")
        }
    }

    func loadMessages() {
        if let category = selectedCategory,
           let savedMessages = UserDefaults.standard.array(forKey: "messages_\(category)") as? [String] {
            messagesToShow = savedMessages
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Mesajı listeden kaldır
            messagesToShow.remove(at: indexPath.row)
            // Güncel listeyi kaydet
            saveMessages()
            // TableView'dan satırı sil
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Mesajı Güncelle", message: "Yeni içeriği girin", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.messagesToShow[indexPath.row]
        }

        let updateAction = UIAlertAction(title: "Güncelle", style: .default) { _ in
            if let updatedMessage = alert.textFields?.first?.text, !updatedMessage.isEmpty {
                self.messagesToShow[indexPath.row] = updatedMessage
                self.tableView.reloadData()
                self.saveMessages() // Değişikliği kaydet
            }
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

        alert.addAction(updateAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }


}

