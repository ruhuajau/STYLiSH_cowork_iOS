import UIKit

class TinderButton: UIButton {
    
    private let border = CAShapeLayer()
    
    var borderColor: CGColor?
    
    init(borderColor: CGColor) {
        super.init(frame: .zero)
        self.borderColor = borderColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.lineWidth = 2.0 // Increase the line width for an inward border effect
        border.fillColor = nil
        border.strokeColor = borderColor
        let borderWidth = border.lineWidth / 2.0
        border.path = UIBezierPath(roundedRect: CGRect(x: borderWidth,
                                                       y: borderWidth,
                                                       width: self.bounds.width - 2 * borderWidth,
                                                       height: self.bounds.height - 2 * borderWidth),
                                   cornerRadius: (self.bounds.width - 2 * borderWidth) / 2).cgPath
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
