//
//  SplashViewController.swift
//  quick_sms
//
//  Created by Trakya11 on 17.05.2025.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!  // Arka plan resmi
    @IBOutlet weak var startButton: UIButton!  // "Başla" butonu
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        // Görsel ayarlamaları yapabilirsiniz
        backgroundImageView.image = UIImage(named: "welcome")  // PNG dosya adını buraya yazın
        
        // Buton görselliğini özelleştirebilirsiniz
        startButton.layer.cornerRadius = 10  // Yuvarlatılmış köşeler
        startButton.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)  // Mavi arka plan
        startButton.setTitleColor(.white, for: .normal)  // Beyaz yazı
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        // Ana ekrana (kategori ekranına) geçiş yapalım
           if let viewController = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController {
               // Sahneyi push etmek yerine present ettiğimiz için, back tuşu otomatik gelmeyecek
               // O yüzden navigation controller'ı push etmek yerine present ediyoruz
               viewController.modalPresentationStyle = .fullScreen
               
               // Navigation Controller'ın ilk view controller'ına (root) erişelim
               if let rootViewController = viewController.viewControllers.first {
                   // Geri tuşunu ekleyelim
                   let backButton = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(dismissViewController))
                   rootViewController.navigationItem.leftBarButtonItem = backButton
               }
               
               present(viewController, animated: true, completion: nil)
           }
       }

       // Geri tuşuna basıldığında çağrılacak fonksiyon
       @objc func dismissViewController() {
           dismiss(animated: true, completion: nil)
       }}
