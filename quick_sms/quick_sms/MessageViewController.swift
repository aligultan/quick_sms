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
        "İyi Dilek": ["Her şey gönlünce olsun!", "Bol şans! 🍀", "İyi günler dilerim! ☀️"],
        "Sevgililer Günü": ["Seni seviyorum! ❤️", "Birlikte nice güzel yıllara! 💖", "Sevgililer günün kutlu olsun! 🌹"],
        "Anneler Günü": ["Anneler günün kutlu olsun! 👩‍👧‍👦", "En güzel günler senin olsun anne! 🌸", "Her zaman yanındayım canım annem! ❤️"],
        "Babalar Günü": ["Babalar günün kutlu olsun! 👨‍👧", "İyi ki varsın baba! 🎉", "Sağlık ve mutluluk dolu bir yıl dilerim baba!"],
        "Geçmiş Olsun": ["Geçmiş olsun, acil şifalar dilerim! 🙏", "Umarım en kısa sürede iyileşirsin! 🌿", "Her şey yoluna girecek! 😊"],
        "Başsağlığı": ["Başınız sağ olsun. 🙏", "Allah sabır versin.", "Acınızı paylaşıyorum."],
        "Kandil Mesajı": ["Kandiliniz mübarek olsun. 🌙", "Hayırlı kandiller dilerim.", "Dualarınız kabul olsun."],
        "Öğretmenler Günü": ["Öğretmenler gününüz kutlu olsun! 👩‍🏫", "Bize kattıklarınız için teşekkürler!", "İyi ki varsınız hocam! 🌟"],
        "Yeni Yıl Kutlaması": ["Mutlu Yıllar! 🎉", "Yeni yılın sağlık ve başarı getirsin! 🎆", "Harika bir yıl seni bekliyor! 🎊"],
        "Hoş Geldin Bebek": ["Aramıza hoş geldin minik! 👶", "Yeni ailenizle mutluluklar dilerim!", "Dünyaya hoş geldin küçük melek!"],
        "Evlenme Tebriği": ["Mutluluğunuz daim olsun! 💍", "Bir ömür boyu mutluluklar! 🎉", "Harika bir çift oldunuz! ❤️"],
        "Mezuniyet Kutlaması": ["Mezuniyetini tebrik ederim! 🎓", "Başarılarının devamını dilerim! 🌟", "Hayatın boyunca başarılar! 🎉"]
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

        // İlk önce Alert'i sunuyoruz.
        self.present(alert, animated: true) {
            // Daha sonra TextField'ı aktif hale getiriyoruz.
            if let textField = alert.textFields?.first {
                textField.becomeFirstResponder()
            }
        }
    }




    // TableView Fonksiyonları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        let message = messagesToShow[indexPath.row]
        
        // Maksimum 30 karakter göster, fazlası için üç nokta koy.
        if message.count > 30 {
            let index = message.index(message.startIndex, offsetBy: 30)
            let shortMessage = message[..<index] + "..."
            cell.textLabel?.text = String(shortMessage)
        } else {
            cell.textLabel?.text = message
        }
        
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

        // Önce Tam Mesajı Göster
        let detailAlert = UIAlertController(title: "Mesaj Detayı", message: selectedMessage, preferredStyle: .alert)
        detailAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))

        // Seçenekler Butonu
        detailAlert.addAction(UIAlertAction(title: "Seçenekler", style: .default) { _ in
            self.showOptions(for: selectedMessage, at: indexPath)
        })

        self.present(detailAlert, animated: true, completion: nil)
    }

    func showOptions(for message: String, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Seçenekler", message: "Bir işlem seçin:", preferredStyle: .actionSheet)

        // Güncelle
        let updateAction = UIAlertAction(title: "✏️ Mesajı Güncelle", style: .default) { _ in
            let updateAlert = UIAlertController(title: "Mesajı Güncelle", message: "Yeni içeriği girin", preferredStyle: .alert)
            updateAlert.addTextField { textField in
                textField.text = message
            }
            let saveAction = UIAlertAction(title: "Kaydet", style: .default) { _ in
                if let updatedMessage = updateAlert.textFields?.first?.text, !updatedMessage.isEmpty {
                    self.messagesToShow[indexPath.row] = updatedMessage
                    self.tableView.reloadData()
                    self.saveMessages()
                }
            }
            updateAlert.addAction(saveAction)
            updateAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
            self.present(updateAlert, animated: true, completion: nil)
        }

        // WhatsApp ile Paylaş
        let whatsappAction = UIAlertAction(title: "📱 WhatsApp ile Paylaş", style: .default) { _ in
            let urlString = "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                self.showAlert(title: "Hata", message: "WhatsApp yüklü değil.")
            }
        }

        // Diğer Uygulamalarla Paylaş
        let shareAction = UIAlertAction(title: "📤 Diğer Uygulamalarla Paylaş", style: .default) { _ in
            let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }

        alert.addAction(updateAction)
        alert.addAction(whatsappAction)
        alert.addAction(shareAction)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }


    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

