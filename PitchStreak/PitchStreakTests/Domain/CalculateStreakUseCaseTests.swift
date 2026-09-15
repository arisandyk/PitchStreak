import Testing
import Foundation
import Core

struct CalculateStreakUseCaseTests {
    private let sut = CalculateStreakUseCaseImpl()
    private let calendar = Calendar.current
    
    @Test func noSessions_returnsZeroStreak() {
        let result = sut.execute(sessions: [])
        #expect(result.currentStreak == 0)
        #expect(result.longestStreak == 0)
    }
    
    @Test func practiceToday_returnsStreakOfOne() {
        let result = sut.execute(sessions: [makeSession(daysAgo: 0)])
        #expect(result.currentStreak == 1)
    }
    
    @Test func threeConsecutiveDaysEndingToday_returnsStreakOfThree() {
        let sessions = [makeSession(daysAgo: 0), makeSession(daysAgo: 1), makeSession(daysAgo: 2)]
        let result = sut.execute(sessions: sessions)
        #expect(result.currentStreak == 3)
    }
    
    @Test func missedYesterdayAndToday_returnsZeroCurrentStreak() {
        let result = sut.execute(sessions: [makeSession(daysAgo: 5)])
        #expect(result.currentStreak == 0)
    }
    
    @Test func longestStreak_isTrackedEvenAfterGap() {
        let sessions = [
            makeSession(daysAgo: 0),
            makeSession(daysAgo: 10),
            makeSession(daysAgo: 11),
            makeSession(daysAgo: 12),
            makeSession(daysAgo: 13)
        ]
        let result = sut.execute(sessions: sessions)
        #expect(result.longestStreak == 4)
    }
    
    private func makeSession(daysAgo: Int) -> PracticeSession {
        let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
        return PracticeSession(id: UUID(), date: date, durationSeconds: 300, practiceType: .vocalWarmUp, song: nil, notes: nil)
    }
}
