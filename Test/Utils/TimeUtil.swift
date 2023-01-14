//
//  TimeUtil.swift
//  Test
//
//  Created by 이상준 on 2023/01/13.
//

import Foundation

struct TimeUtil {
    static func formatTime(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertDate = dateFormatter.date(from: time)
        
        let formatter = DateFormatter()
        //한국 시간으로 표시
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        //형태 변환
        formatter.dateFormat = "a h시"
        return formatter.string(from: convertDate!)
    }
}
