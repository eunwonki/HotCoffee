import Foundation

// Codable: Json Codable, Decodable 하도록 만들어주기 위해.
// CaseIterable: enum에 정의한 DataType을 배열로 이용해 주기 위해.

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espressino
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
    
}

extension Order {
    
    // TODO: 다른 project들을 보며 URL의 위치는 어디가 적당한지, Model에 있는게 좋은지 또는 ViewModel 쪽에 있는게 좋은지.
    // TODO: API Request와 받을 Data Type을 Resource라고 정리해서 보내는데 왜 Resource라고 하는건지 다른 프로젝트에서 확인해 볼 것.
    // TODO: 여러 프로젝트들을 보며 View Model을 만들어주는 기준 알아보기.
    
    // url was changed
    // https://www.udemy.com/course/mastering-mvvm-for-ios/learn/lecture/14700342#questions/11408504
    static let apiUrl = URL(string: "https://warp-wiry-rugby.glitch.me/orders")!
    
    static var all: Resource<[Order]> =  {
        return Resource<[Order]>(url: apiUrl)
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        
        let order = try? Order(vm)
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order!")
        }
        
        var resource = Resource<Order?>(url: apiUrl)
        resource.httpMethod = .post
        resource.body = data
        
        return resource
    }
    
}

extension Order {
    
    // TODO: init에 대해 공부하기...
    init?(_ vm: AddCoffeeOrderViewModel) throws {
        guard let name = vm.name,
              let email = vm.email,
              let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
    
}
