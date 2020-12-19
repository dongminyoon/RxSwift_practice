//
//  ViewController.swift
//  RxSwift_2step
//
//  Created by 윤동민 on 2020/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    // MARK: - UI
    var circleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        view.backgroundColor = .green
        return view
    }()
    
    // MARK: - Data
    var viewModel: ViewModel = ViewModel()
    
    // MARK: - Init
    private func initView() {
        circleView.center = self.view.center
        self.view.addSubview(circleView)
    }
    
    private func setGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveCircle(_:)))
        circleView.addGestureRecognizer(gesture)
    }
    
    private func bind() {
        circleView.rx.observe(CGPoint.self, "center")
            .bind(to: viewModel.input.circlePoint)
            .disposed(by: disposeBag)
        
        viewModel.output.backgroundColor
            .subscribe(onNext: { [weak self] color in
                self?.circleView.backgroundColor = color
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    @objc
    func moveCircle(_ recognizer: UIPanGestureRecognizer) {
        let transition = recognizer.translation(in: self.view)
        let resultX = circleView.center.x + transition.x
        let resultY = circleView.center.y + transition.y
        
        circleView.center = CGPoint(x: resultX, y: resultY)
        recognizer.setTranslation(.zero, in: self.view)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
        setGesture()
        bind()
    }
}

