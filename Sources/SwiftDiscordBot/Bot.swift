//
//  Created on 2022/2/21.
//

import Foundation
import Sword
import RxSwift
import RxCocoa

class Bot: Sword {
    /// 狀態
    enum Status: String {
        /// 在線
        case online
        /// 閒置
        case idle
        /// 請勿打擾
        case dnd
        /// 隱形
        case invisible
    }
    /// 指令
    enum Command: String, CaseIterable {
        case 幫助
        case 序號
        case 分流列表
        case 分流
        case 赫敦
        case 骰子
        case 退坑
        case 世界王
        case 世界王檢查
        case 運勢
        case AP
        case DP
        case 測試
        /// 描述
        var description: String {
            switch self {
            case .幫助:
                return "顯示所有指令"
            case .序號:
                return "快速建立序號；範例: \(App.prefixString)序號 截止日期,序號,物品#1:數量,物品#2:數量"
            case .分流列表:
                return "顯示所有分流"
            case .分流:
                return "隨機挑選分流 (包含赫敦分流)"
            case .赫敦:
                return "隨機挑選赫敦分流"
            case .骰子:
                return "隨機挑選 1-28 的秒數"
            case .退坑:
                return "同指令「骰子」"
            case .世界王:
                return "查詢時間最近的世界王；查詢明天的世界王，範例： \(App.prefixString)世界王 明天"
            case .世界王檢查:
                return "由觸發機器人觸發的檢查指令"
            case .運勢:
                return "由機器人不負責任的鐵口直斷；再次使用時間 15 分鐘"
            case .AP:
                return "面板攻擊力門檻加成獎勵；範例: \(App.prefixString)AP 249"
            case .DP:
                return "面板防禦力門檻加成獎勵；範例: \(App.prefixString)DP 301"
            case .測試:
                return "試錯階段指令"
            }
        }
        /// 是否顯示
        var isPresent: Bool {
            switch self {
            case .幫助, .測試, .世界王檢查:
                return false
            default:
                return true
            }
        }
        /// 是否為測試
        var isTest: Bool {
            switch self {
            case .測試:
                return true
            default:
                return false
            }
        }
    }
    
    // 選項指令
    enum 世界王指令選項: String, CaseIterable {
        /// 今天全部
        case 今天
        /// 明天全部
        case 明天
        /// 空值
        case empty
        /// 起始秒數
        var second: Int? {
            switch self {
            case .今天:
                return 0
            case .明天:
                return 86400
            case .empty:
                return nil
            }
        }
    }
    
    init(token: String) {
        super.init(token: token)
        
        viewModel = BotViewModel(self)
        
        guard let viewModel = self.viewModel else { return }
        
        bind()
        bind(viewModel)
        
        App.log("is online and playing \(App.playing).")
    }
    
    private var viewModel: BotViewModelPrototype?
    
    private let disposeBag = DisposeBag()
}

// 主體
extension Bot {
    /// 更變調整
    func status(to status: Status, playItem: String?) {
        guard let item = playItem else {
            editStatus(to: status.rawValue)
            return
        }
        
        editStatus(to: status.rawValue,
                   playing: item)
    }
}

private extension Bot {
    func bind() {
        on(.guildAvailable) { [weak self] in
            guard let self = self,
                  let guild = $0 as? Guild else { return }
            
            App.log("Guild Available: \(guild.name)")
            
            if guild.members[self.user!.id]?.nick != App.nickname {
                guild.setNickname(to: App.nickname) { error in
                    if let error = error {
                        App.log("failed to change nickname in guild: \(guild.name), error: \(error)")
                    }
                }
            }
        }
    }
    
    func bind(_ viewModel: BotViewModelPrototype) {
        on(.messageCreate) {
            guard let message = $0 as? Message else { return }
            
            viewModel
                .sets
                .newMessage(message, prefixString: App.prefixString)
        }
        
        viewModel
            .gets
            .sendMessage
            .subscribe(onNext: {
                $0.channel.send($0.messageString)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .gets
            .removeMessage
            .subscribe(onNext: {
                guard let messageId = $0.messageId else { return }
                
                $0.channel.deleteMessage(messageId)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .sets
            .bossSchedule()
    }
}
