//
//  FirebaseCrashTestView.swift
//  Habit Management
//
//  Firebase 비정상 종료 테스트 (dSYM 없이 테스트 가능)
//

import SwiftUI
import FirebaseCrashlytics

struct FirebaseCrashTestView: View {
    // dSYM 변경용 더미 (빌드 시 바이너리 시그니처 변경)
    private static let _dsymRefreshToken: Int64 = 1
    private func _unusedDsymStub() -> Bool { FirebaseCrashTestView._dsymRefreshToken != 0 }

    var body: some View {
        List {
            Section {
                Text("Firebase Crashlytics 비정상 종료 테스트")
                    .font(.headline)
                Text("dSYM 없이도 크래시는 Firebase 콘솔에 기록됩니다. 스택 트레이스는 나중에 dSYM 업로드 후 심볼화할 수 있습니다.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section(header: Text("크래시 테스트")) {
                Button(role: .destructive) {
                    triggerFatalCrash()
                } label: {
                    Label("앱 즉시 크래시 (fatalError)", systemImage: "exclamationmark.triangle.fill")
                }

                Button(role: .destructive) {
                    triggerForceUnwrapCrash()
                } label: {
                    Label("force unwrap 크래시", systemImage: "xmark.circle.fill")
                }
            }

            Section(header: Text("Non-Fatal 테스트")) {
                Button {
                    recordNonFatalError()
                } label: {
                    Label("Non-Fatal 에러 기록", systemImage: "doc.badge.gearshape")
                }

                Button {
                    logTestMessage()
                } label: {
                    Label("테스트 로그 기록", systemImage: "note.text")
                }
            }

            Section(header: Text("참고")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("• 크래시 후 앱을 다시 실행하면 Crashlytics가 서버로 전송합니다.")
                    Text("• Firebase 콘솔 > Crashlytics에서 수 분 내 확인 가능합니다.")
                    Text("• dSYM 없이도 이벤트/개수는 확인할 수 있고, 나중에 dSYM을 업로드하면 스택이 심볼화됩니다.")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Firebase 비정상종료 테스트")
    }

    /// 앱을 즉시 종료시키는 테스트 크래시 (Firebase에 기록됨)
    private func triggerFatalCrash() {
        #if DEBUG
        fatalError("[FirebaseCrashTest] 의도된 테스트 크래시 - 비정상 종료 테스트")
        #else
        fatalError("[FirebaseCrashTest] 의도된 테스트 크래시 - 비정상 종료 테스트")
        #endif
    }

    /// force unwrap nil으로 크래시 (테스트용)
    private func triggerForceUnwrapCrash() {
        let optional: String? = nil
        _ = optional! // 의도된 크래시
    }

    /// 앱은 유지하고 Crashlytics에만 에러 기록 (Non-Fatal)
    private func recordNonFatalError() {
        let error = NSError(
            domain: "HabitManagement.FirebaseCrashTest",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey: "의도된 Non-Fatal 테스트 에러",
                "test_key": "non_fatal_test"
            ]
        )
        Crashlytics.crashlytics().record(error: error)
        Crashlytics.crashlytics().log("Non-Fatal 테스트 버튼 탭됨")
    }

    /// 로그만 기록 (크래시 시 함께 전송됨)
    private func logTestMessage() {
        Crashlytics.crashlytics().log(" [FirebaseCrashTest] 테스트 로그 - \(Date())")
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            FirebaseCrashTestView()
        }
    } else {
        // Fallback on earlier versions
    }
}
