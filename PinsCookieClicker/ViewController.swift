//
//  ViewController.swift
//  PinsCookieClicker
//
//  Created by Yegor on 22.09.2024.
//

import UIKit

class ViewController: UIViewController {

    private let cookieView: UIImageView = {
        let image = UIImage(resource: .cookie)
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let counterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var count: Int = 0 {
        didSet {
            UserDefaults.standard.setValue(count, forKey: "counter")
            counterLabel.text = count.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let stackView = UIStackView(arrangedSubviews: [cookieView, counterLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            cookieView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            cookieView.heightAnchor.constraint(equalTo: cookieView.widthAnchor)
        ])

        cookieView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cookieTapped(gestureRecognizer:))))

        count = UserDefaults.standard.integer(forKey: "counter")
    }

    @objc private func cookieTapped(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: view)
        addFloater(at: location)
        count += 1
        cookieView.layer.add(pulsateAnimation(), forKey: nil)
    }

    func pulsateAnimation() -> CABasicAnimation {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.autoreverses = true
        pulse.repeatCount = 1
        return pulse
    }

    func addFloater(at point: CGPoint) {
        let label = UILabel()
        label.text = "+1"
        label.font = .boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.sizeToFit()
        label.center = point
        view.addSubview(label)

        UIView.animate(withDuration: 1.4, animations: {
            label.alpha = 0.0
        }, completion: { _ in
            label.removeFromSuperview()
        })
    }
}

