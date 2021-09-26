import Foundation

public enum ApiResult<T> {
    case success(T)
    case error(Error)
}

public typealias ApiResultHandler<T> = (_: ApiResult<T>) -> ()
