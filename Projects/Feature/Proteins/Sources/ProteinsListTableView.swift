

import UIKit

class ProteinsListTableView: UITableView {
    // 커스텀 초기화 메서드
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // 여기에 테이블 뷰를 설정하는 코드 추가
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableFooterView = UIView() // 빈 셀 하단의 구분선을 숨김
        
        // 기타 커스텀 설정...
        self.backgroundColor = .white
        self.separatorStyle = .singleLine
    }
}
