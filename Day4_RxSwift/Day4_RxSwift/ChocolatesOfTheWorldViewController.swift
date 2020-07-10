
import UIKit
import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
    @IBOutlet private var cartButton: UIBarButtonItem!
    @IBOutlet private var tableView: UITableView!
//    let europeanChocolates = Chocolate.ofEurope
    let europeanChocolates = Observable.just(Chocolate.ofEurope)
    
    private let disposeBag = DisposeBag()
}

//MARK: View Lifecycle
extension ChocolatesOfTheWorldViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chocolate!!!"
        
//        tableView.dataSource = self
//        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartButton()
        
        setupCartObserver()
        setupCellConfiguration()
        setupCellTapHandling()
    }
}

//MARK: - Rx Setup
private extension ChocolatesOfTheWorldViewController {
    
    func setupCartObserver() {
        //1 观察ShoppingCart.sharedCart.chocolates 中 值的变化
        ShoppingCart.sharedCart.chocolates.asObservable()
            .subscribe(onNext: { //2
                [unowned self] chocolates in
                self.cartButton.title = "\(chocolates.count) \u{1f36b}"
            })
            .disposed(by: disposeBag) //3
    }
    
    func setupCellConfiguration() {
        //1
        europeanChocolates
            .bind(to: tableView
                .rx //2
                .items(cellIdentifier: ChocolateCell.Identifier,
                       cellType: ChocolateCell.self)) { //3
                        row, chocolate, cell in
                        cell.configureWithChocolate(chocolate: chocolate) //4
        }
            .disposed(by: disposeBag) //5
    }
    
    func setupCellTapHandling() {
      tableView
        .rx
        .modelSelected(Chocolate.self) //1
        .subscribe(onNext: { [unowned self] chocolate in // 2
          let newValue =  ShoppingCart.sharedCart.chocolates.value + [chocolate]
          ShoppingCart.sharedCart.chocolates.accept(newValue) //3
            
          if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
          } //4
        })
        .disposed(by: disposeBag) //5
    }
}

//MARK: - Imperative methods
private extension ChocolatesOfTheWorldViewController {
    func updateCartButton() {
        cartButton.title = "\(ShoppingCart.sharedCart.chocolates.value.count) 🍫"
    }
}

//// MARK: - Table view data source
//extension ChocolatesOfTheWorldViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return europeanChocolates.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChocolateCell.Identifier, for: indexPath) as? ChocolateCell else {
//            //Something went wrong with the identifier.
//            return UITableViewCell()
//        }
//
//        let chocolate = europeanChocolates[indexPath.row]
//        cell.configureWithChocolate(chocolate: chocolate)
//
//        return cell
//    }
//}
//
//// MARK: - Table view delegate
//extension ChocolatesOfTheWorldViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let chocolate = europeanChocolates[indexPath.row]
//        let newValue =  ShoppingCart.sharedCart.chocolates.value + [chocolate]
//        //重新赋值
//        ShoppingCart.sharedCart.chocolates.accept(newValue)
////        updateCartButton()
//    }
//}

// MARK: - SegueHandler
extension ChocolatesOfTheWorldViewController: SegueHandler {
    enum SegueIdentifier: String {
        case goToCart
    }
}
