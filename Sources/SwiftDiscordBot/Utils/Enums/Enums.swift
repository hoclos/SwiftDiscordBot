//
// Created on 2022/4/1.
//

import Foundation

/// 分流
enum ServiceDiversion: String, CaseIterable {
    case 阿勒沙
    case 梅迪亞_1
    case 梅迪亞_2
    case 梅迪亞_3
    case 卡爾佩恩_1
    case 卡爾佩恩_2
    case 卡爾佩恩_3
    case 卡瑪希爾比亞_1
    case 卡瑪希爾比亞_2
    case 卡瑪希爾比亞_3
    case 巴雷諾斯_1
    case 巴雷諾斯_2
    case 巴雷諾斯_3
    case 璐璐飛_1
    case 璐璐飛_2
    case 璐璐飛_3
    case 璐璐飛_4
    case 璐璐飛_5
    case 瓦倫西亞_1
    case 瓦倫西亞_2
    case 瓦倫西亞_3
    case 賽林迪亞_1
    case 賽林迪亞_2
    case 賽林迪亞_3
    case 艾裴莉雅_1
    case 艾裴莉雅_2
    case 艾裴莉雅_3
    /// 名稱
    var name: String {
        return rawValue.replacingOccurrences(of: "_", with: "-")
    }
    /// 是否為赫敦分流
    var isHutton: Bool {
        switch self {
        case .阿勒沙:
            fallthrough
        case .梅迪亞_2, .梅迪亞_3:
            fallthrough
        case .卡爾佩恩_2:
            fallthrough
        case .卡瑪希爾比亞_2, .卡瑪希爾比亞_3:
            fallthrough
        case .巴雷諾斯_2, .巴雷諾斯_3:
            fallthrough
        case .瓦倫西亞_2:
            fallthrough
        case .賽林迪亞_2, .賽林迪亞_3:
            return true
        default:
            return false
        }
    }
    /// 是否為 PVP 分流
    var isPvp: Bool {
        switch self {
        case .阿勒沙:
            return true
        default:
            return false
        }
    }
}

/// 世界王
enum Boss: String, Codable {
    case 克價卡
    case 庫屯
    case 卡嵐達
    case 羅裴勒
    case 奧平
    case 貝爾
    case 卡莫斯
    case 肯恩特_木拉卡
}