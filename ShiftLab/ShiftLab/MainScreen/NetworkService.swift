import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(decodedProducts))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
