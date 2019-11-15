//
//  OrderViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/21/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

enum CartState {
    case expended
    case collapsed
}

protocol OrderViewControllerDelegate: class {
    func changeOrderAmount(dish: DishModel, amount: Int)
}

final class OrderViewController: UIViewController {
    
    
    @IBOutlet weak var dishTableView: UITableView!
    
    weak var delegate: TableViewController?
    
    // Order View
    let dishCellID = "dishCellID"
    let dishHeaderCellID = "dishHeaderCellID"
    
    let dishCellHeight: CGFloat = 100.0
    let dishHeaderCellHeight: CGFloat = 50.0
    
    var table: TableModel?
    var dishCategories = [DishCategoryModel]()
    var dishesByCategory = [[DishModel]]()
    
    // Cart View
    var cartVisible = false
    
    var nextState: CartState {
        return cartVisible ? .collapsed : .expended
    }
    
    var cartViewController: CartViewController!
    var visualEffectView: UIVisualEffectView!
    
    var startCartHeight: CGFloat = 0
    var endCartHeight: CGFloat = 0
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            if !self.dishesByCategory.isEmpty && !self.dishCategories.isEmpty{
                print("OrderViewController: Data was fetched")
                self.setupCart()
                self.setupView()
                self.hideActivityIndicatorView()
                timer.invalidate()
            }
        }
    }
    
    deinit {
        logger()
    }
 
    func fetchData() {
        self.showActivityIndicatorView()
        DishCategoryModel.fetchAllDishCategory { [weak self] data, err -> Void in
            guard let strongSelf = self else { return }
            if err != nil {
                print("OrderViewController: Error getting Dish Category data: \(err!.localizedDescription)")
            } else if data != nil {
                strongSelf.dishCategories = data!
                
                strongSelf.dishCategories.reversed().forEach { dishCategory in
                    DishModel.fetchDishes(byCategoryID: dishCategory.id) { data, err in
                        if err != nil {
                            print("OrderViewController: Error getting Dish data: \(err!.localizedDescription)")
                        } else if data != nil {
                            strongSelf.dishesByCategory.append(data!)
                        }
//                        if dishCategory == strongSelf.dishCategories.last {
//                            print("OrderViewController: Data was fetched")
//                            strongSelf.setupCart()
//                            strongSelf.setupView()
//                            strongSelf.hideActivityIndicatorView()
//                        }
                    }
                }
            }
        }
        if table?.bill == nil {
            table?.bill = BillModel()
        }
    }
    
    func setupView() {
        
        dishTableView.dataSource = self
        dishTableView.delegate = self
        
        if let tableNumber = table?.number {
            navigationItem.title = "Bàn \(tableNumber)"
        }
        
        self.dishTableView.reloadData()
        
        dishTableView.register(UINib(nibName: "DishViewCell", bundle: nil), forCellReuseIdentifier: dishCellID)
        dishTableView.register(UINib(nibName: "DishHeaderViewCell", bundle: nil), forCellReuseIdentifier: dishHeaderCellID)
        dishTableView.register(UITableViewCell.self, forCellReuseIdentifier: "space")
    }
    
    func setupCart() {
        endCartHeight = self.view.frame.height * 0.8
        
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        if !cartVisible {
            visualEffectView.isHidden = true
        }
        
        cartViewController = CartViewController(nibName: "CartViewController", bundle: nil)
        cartViewController.delegate = self
        
        self.addChild(cartViewController)
        self.view.addSubview(cartViewController.view)
        
        cartViewController.view.frame.size.width = self.view.frame.width
        cartViewController.view.frame.size.height = endCartHeight
    
        startCartHeight = cartViewController.handleArea.frame.height +
            App.shared.rootNagivationController.view.safeAreaInsets.bottom
        
        cartViewController.view.frame.origin.x = 0
        cartViewController.view.frame.origin.y = self.view.frame.height - startCartHeight
        cartViewController.view.clipsToBounds = true

        cartViewController.view.isHidden = true
        cartViewController.cartTableView.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCartTap))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCartPan))
        
        cartViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cartViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handleCartTap(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.8)
        default:
            return
        }
    }
    
    @objc func handleCartPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.5)
        case .changed:
            let translation = recognizer.translation(in: self.cartViewController.handleArea)
            var fractionComplete = translation.y / endCartHeight
            fractionComplete = cartVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CartState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expended:
                    self.cartViewController.view.frame.origin.y = self.view.frame.height - self.endCartHeight
//                    self.visualEffectView.effect = UIBlurEffect(style: .light)
                    self.visualEffectView.isHidden = false
                    self.cartViewController.cartTableView.isHidden = false
                case .collapsed:
                    self.cartViewController.view.frame.origin.y = self.view.frame.height - self.startCartHeight
                    self.visualEffectView.effect = nil
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cartVisible = !self.cartVisible
                self.runningAnimations.removeAll()
                if !self.cartVisible {
                    self.visualEffectView.isHidden = true
                    self.cartViewController.cartTableView.isHidden = true
                }
            }
            
            frameAnimator.startAnimation()
            
            runningAnimations.append(frameAnimator)
            
//            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
//                switch state {
//                case .expended:
//                    self.cartViewController.view.layer.cornerRadius = 12
//                case .collapsed:
//                    self.cartViewController.view.layer.cornerRadius = 0
//                }
//            }
//
//            cornerRadiusAnimator.startAnimation()
//
//            runningAnimations.append(cornerRadiusAnimator)
        }
    }
        
    func startInteractiveTransition(state: CartState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            delegate?.fetchData()
//            delegate?.tableCollectionView.reloadData()
        }
    }
}

extension OrderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dishCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == tableView.numberOfSections - 1 && cartViewController?.view.isHidden == false {
                   return  dishesByCategory[section].count + 1
               }
        return dishesByCategory[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = dishTableView.dequeueReusableCell(withIdentifier: dishHeaderCellID) as! DishHeaderViewCell
        headerCell.dishCategory = dishCategories[section]
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == tableView.numberOfSections - 1 && indexPath.item == dishesByCategory[indexPath.section].count && cartViewController?.view.isHidden == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "space", for: indexPath)
            return cell
        }

        let cell = dishTableView.dequeueReusableCell(withIdentifier: dishCellID, for: indexPath) as! DishViewCell
        cell.dish = dishesByCategory[indexPath.section][indexPath.item]
        if let _ = table?.bill?.order_list {
            for order in table!.bill!.order_list! {
                if order.dish == cell.dish {
                    cell.amount = order.amount
                    cell.delegate = self
                    return cell
                }
            }
        }
        cell.amount = 0
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dishCategories[indexPath.section] == dishCategories.last && indexPath.item == dishesByCategory[indexPath.section].count && cartViewController?.view.isHidden == false {
            return cartViewController.handleArea.frame.height
        }
        return dishCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dishHeaderCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OrderViewController: OrderViewControllerDelegate {
    func changeOrderAmount(dish: DishModel, amount: Int) {
        table?.bill?.updateOrder(withDish: dish, amount: amount)
        cartViewController.bill = table?.bill
        if let _ = table?.bill?.order_list {
            if table!.bill!.order_list!.isEmpty {
                cartViewController.view.isHidden = true
            } else {
                cartViewController.view.isHidden = false
            }
        }
        dishTableView.reloadData()
       }
}

extension OrderViewController: UITableViewDelegate {
    
}
