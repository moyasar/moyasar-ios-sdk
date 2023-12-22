import Foundation

public enum ApiResult<T> {
    case success(T)
    case error(MoyasarError)
}

public typealias ApiResultHandler<T> = (_: ApiResult<T>) -> ()
