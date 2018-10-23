import UIKit

class ViewController: UIViewController {
    
    
    var xCarousel: XCarousel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xCarousel = XCarousel.init(frame: CGRect(x: 0.0, y: 60.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.5))
        
        let data = [Banner(name: "slider 1", link: "https://www.google.com", image: "0"),
                    Banner(name: "slider 2", link: "https://www.google.com", image: "1"),
                    Banner(name: "slider 3", link: "https://www.google.com", image: "2"),
                    Banner(name: "slider 4", link: "https://www.google.com", image: "3"),
                    Banner(name: "slider 5", link: "https://www.google.com", image: "4")]
        xCarousel?.data = data
        xCarousel?.timeInterVal = 3
        view.addSubview(xCarousel!)
    }
}
