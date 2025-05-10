import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var selectedCategory: String?

    // Kategoriye göre gösterilecek hazır mesajlar
    let messageTemplates: [String: [String]] = [
        "Doğum Günü": ["Nice mutlu yıllara! 🎉", "Yeni yaşın sağlık ve mutluluk getirsin!", "Doğum günün kutlu olsun! 🎂"],
        "Yeni İş": ["Yeni işinde başarılar dilerim!", "Başarı dolu bir kariyer dilerim!", "Yeni işin hayırlı olsun! 👔"],
        "Yıldönümü": ["Mutluluğunuz daim olsun!", "Nice yıllara birlikte!", "Yıldönümünüz kutlu olsun! ❤️"],
        "Tebrik": ["Tebrik ederim, harikasın! 🎉", "Başarını kutluyorum!", "Bravo, çok güzel haber! 👏"],
        "Özel Gün": ["Bugünün senin için özel olmasını dilerim!", "Harika bir gün geçir!", "Özel günlerin hep mutlu geçsin!"],
        "İyi Dilek": ["Her şey gönlünce olsun!", "Bol şans! 🍀", "İyi günler dilerim! ☀️"]
    ]

    var messagesToShow: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        if let category = selectedCategory {
            messagesToShow = messageTemplates[category] ?? []
            self.title = category
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        cell.textLabel?.text = messagesToShow[indexPath.row]
        return cell
    }
}

