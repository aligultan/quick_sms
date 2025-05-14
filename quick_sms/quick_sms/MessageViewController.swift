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
                self.saveMessages()
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

    // Mesajı silmek için kaydırma işlemi
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            messagesToShow.remove(at: indexPath.row)
            saveMessages()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // Mesajı tıklayınca paylaş veya güncelle seçeneği sun
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMessage = messagesToShow[indexPath.row]
        
        let alert = UIAlertController(title: "Mesajı Paylaş", message: "Bir uygulama seçin:", preferredStyle: .actionSheet)

        // WhatsApp ile Paylaş
        let whatsappAction = UIAlertAction(title: "📱 WhatsApp", style: .default) { _ in
            let urlString = "whatsapp://send?text=\(selectedMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                self.showAlert(title: "Hata", message: "WhatsApp yüklü değil.")
            }
        }

        // iMessage ile Paylaş
        let iMessageAction = UIAlertAction(title: "💬 iMessage", style: .default) { _ in
            let urlString = "sms:&body=\(selectedMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                self.showAlert(title: "Hata", message: "iMessage desteklenmiyor.")
            }
        }

        // Standart Paylaşım
        let shareAction = UIAlertAction(title: "📤 Diğer Uygulamalar", style: .default) { _ in
            let activityVC = UIActivityViewController(activityItems: [selectedMessage], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

        alert.addAction(whatsappAction)
        alert.addAction(iMessageAction)
        alert.addAction(shareAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

