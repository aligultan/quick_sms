import UIKit
import MessageUI


class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var selectedCategory: String?
    var messagesToShow: [String] = []

    // Sabit mesaj şablonları
    let messageTemplates: [String: [String]] = [
        "Doğum Günü": [
            "Nice mutlu yıllara! 🎉",
            "Yeni yaşın sağlık ve mutluluk getirsin!",
            "Doğum günün kutlu olsun! 🎂",
            "Hayatının bu özel gününde sana sağlık, mutluluk ve başarı diliyorum. İyi ki doğdun!",
            "Yeni yaşında mutluluğun tavan yapsın, tüm dileklerin gerçek olsun!",
            "Doğum günün kutlu olsun! Hayat sana her daim güzellikler getirsin!"
        ],
        "Yeni İş": [
            "Yeni işinde başarılar dilerim! 👔",
            "Kariyerinde yeni bir sayfa, başarıların daim olsun!",
            "Yeni işin hayırlı ve uğurlu olsun!",
            "Başarı dolu bir kariyer seni bekliyor, tebrikler!",
            "Yeni işinde mutluluk ve huzur dilerim!"
        ],
        "Yıldönümü": [
            "Nice mutlu yıllara birlikte! ❤️",
            "Sevginiz her daim taze kalsın, yıldönümünüz kutlu olsun!",
            "Hayat boyu el ele, gönül gönüle nice yıllara!",
            "Sevginiz ömür boyu sürsün!",
            "Birlikteliğinizin bu özel gününde, nice güzel yıllar dilerim!"
        ],
        "Tebrik": [
            "Tebrikler! Harika bir başarı! 🎉",
            "Başarını kutluyorum, daha nice başarılara! 👏",
            "Emeklerinin karşılığını aldın, tebrik ederim!",
            "Her zaman bu başarılarla gururlan!",
            "Başarılarının devamını dilerim!"
        ],
        "Özel Gün": [
            "Bugünün senin için özel olmasını dilerim!",
            "Harika bir gün geçir!",
            "Özel günlerin hep mutlulukla geçsin!",
            "Bu özel günün sana neşe ve huzur getirsin!",
            "Güzel anılarla dolu bir gün geçirmeni dilerim!"
        ],
        "İyi Dilek": [
            "Her şey gönlünce olsun! 🍀",
            "Bol şans ve mutluluk seninle olsun!",
            "İyi günler dilerim! ☀️",
            "Umarım hayatın hep güzel sürprizlerle dolu olur!",
            "Gönlünden geçen tüm dilekler gerçek olsun!"
        ],
        "Sevgililer Günü": [
            "Seni seviyorum! ❤️",
            "Birlikte nice güzel yıllara! 💖",
            "Sevgililer günün kutlu olsun! 🌹",
            "Sen benim en değerli hediyemsin!",
            "Kalbimdeki en özel yer senin!"
        ],
        "Anneler Günü": [
            "Anneler günün kutlu olsun! 👩‍👧‍👦",
            "Canım annem, seni çok seviyorum!",
            "Dünyanın en güzel annesine sevgiler!",
            "Fedakarlığın için teşekkürler canım annem!",
            "İyi ki varsın, iyi ki benim annemsin!"
        ],
        "Babalar Günü": [
            "Babalar günün kutlu olsun! 👨‍👧",
            "İyi ki varsın babacığım! 🎉",
            "Senin gibi bir baba olduğu için çok şanslıyım!",
            "Babam, her zaman en büyük kahramanım!",
            "Sana minnettarım babacığım!"
        ],
        "Bayram Kutlaması": [
            "Bayramınız kutlu olsun, sağlık ve huzur dilerim!",
            "Sevdiklerinizle birlikte mutlu bayramlar!",
            "Bayramın mutluluk ve barış getirmesini dilerim!",
            "Bayram sevinci gönlünüzden hiç eksik olmasın!",
            "Hayırlı bayramlar, nice mutlu günlere!"
        ],
        "Geçmiş Olsun": [
            "Geçmiş olsun, acil şifalar dilerim! 🙏",
            "Bir an önce sağlığına kavuşmanı dilerim!",
            "Her şey yoluna girecek, güçlü kal!",
            "Umarım en kısa sürede sağlığın yerine gelir!",
            "Kendine iyi bak, seni iyi görmek istiyoruz!"
        ],
        "Başsağlığı": [
            "Başınız sağ olsun. 🙏",
            "Allah rahmet eylesin, mekanı cennet olsun.",
            "Bu zor günlerde dualarım sizinle.",
            "Acınızı paylaşıyorum, Allah sabır versin.",
            "Kaybınız için çok üzgünüm, başınız sağ olsun."
        ],
        "Kandil Mesajı": [
            "Kandiliniz mübarek olsun. 🌙",
            "Dualarınız kabul olsun, hayırlı kandiller!",
            "Bu mübarek gecede tüm dilekleriniz gerçek olsun.",
            "Kandil geceniz hayırlara vesile olsun.",
            "Allah huzur ve mutluluğu üzerinizden eksik etmesin!"
        ],
        "Öğretmenler Günü": [
            "Öğretmenler gününüz kutlu olsun! 👩‍🏫",
            "Bize kattığınız her şey için teşekkürler!",
            "İyi ki varsınız değerli öğretmenim! 🌟",
            "Yolumuzu aydınlattığınız için teşekkür ederiz!",
            "Emekleriniz için minnettarız!"
        ],
        "Yeni Yıl Kutlaması": [
            "Mutlu Yıllar! 🎉",
            "Yeni yılın sağlık, mutluluk ve başarı getirsin! 🎆",
            "Yeni yılda tüm dileklerin gerçekleşsin!",
            "Sevdiklerinle huzurlu ve neşeli bir yıl dilerim!",
            "Yeni yılda hayallerin gerçek olsun!"
        ],
        "Ramazan Bayramı": [
            "Ramazan Bayramınız mübarek olsun!",
            "Bayramınız sağlık ve huzur dolu geçsin!",
            "Sevdiklerinizle birlikte mutlu bayramlar dilerim!",
            "Bayramın bereketi ve sevinci hep sizinle olsun!",
            "Hayırlı Ramazan Bayramları!"
        ],
        "Kurban Bayramı": [
            "Kurban Bayramınız mübarek olsun!",
            "Bayramda sevdiklerinizle huzurlu anlar dilerim!",
            "Kurban Bayramı'nın getirdiği bereket üzerinizde olsun!",
            "Bayramınız kutlu olsun, nice bayramlara!",
            "Bayram sevinciniz daim olsun!"
        ],
        "Hoş Geldin Bebek": [
            "Aramıza hoş geldin minik melek! 👶",
            "Allah analı babalı büyütsün!",
            "Dünyaya hoş geldin küçük mucize!",
            "Bebeğinizin sağlıklı ve mutlu bir ömrü olsun!",
            "Hayatınıza neşe katan minik için tebrikler!"
        ],
        "Evlenme Tebriği": [
            "Mutluluğunuz daim olsun! 💍",
            "Bir ömür boyu mutluluklar! 🎉",
            "Yuvanız sevgiyle dolsun!",
            "Allah mesut etsin, mutluluğunuz daim olsun!",
            "Birlikte nice güzel günler dilerim!"
        ],
        "Mezuniyet Kutlaması": [
            "Mezuniyetini tebrik ederim! 🎓",
            "Başarıların daim olsun!",
            "Yeni hayatında başarı ve mutluluk dilerim!",
            "Bugün bir yol bitti, yeni yollar seni bekliyor!",
            "Hayallerinin peşinden git, gurur duyuyorum!"
        ]
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
        // 📞 SMS ile Gönder ve Rehber Aç
        let smsAction = UIAlertAction(title: "📲 SMS ile Gönder", style: .default) { _ in
            self.sendSMS(message: message)
        }


        // Diğer Uygulamalarla Paylaş
        let shareAction = UIAlertAction(title: "📤 Diğer Uygulamalarla Paylaş", style: .default) { _ in
            let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }

        alert.addAction(updateAction)
        alert.addAction(whatsappAction)
        alert.addAction(smsAction)
        alert.addAction(shareAction)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }


    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func sendSMS(message: String) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = message
            messageVC.messageComposeDelegate = self
            
            // Kullanıcı burada rehberden kişi seçecek, numara vermene gerek yok.
            self.present(messageVC, animated: true, completion: nil)
        } else {
            self.showAlert(title: "Hata", message: "Bu cihaz SMS gönderemiyor veya SIM kart takılı değil.")
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }




}

