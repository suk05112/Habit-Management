import Foundation
import RealmSwift

extension StatisticsModel {
    func toRealmEntity() -> Statistics {
        let statistics = Statistics()
        statistics.year = self.year
        statistics.dayArray = self.days
        statistics.weekArray = self.week
        statistics.monthArray = self.month
        statistics.total = self.total
        statistics.classification = self.classification
        return statistics
    }
}

extension Statistics {
    func toDomainModel() -> StatisticsModel {
        return StatisticsModel(
            year: self.year,
            days: self.dayArray,
            week: self.weekArray,
            month: self.monthArray,
            total: self.total,
            classification: self.classification
        )
    }
}
