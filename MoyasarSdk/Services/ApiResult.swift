import Foundation

enum ApiResult<T> {
    case success(T)
    case error(Error)
}

typealias ApiResultHandler<T> = (_: ApiResult<T>) -> ()
