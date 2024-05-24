import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

class AppInfoViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    struct Input {
        let appInfoIndexPath: Observable<IndexPath>
    }
    
    struct Output {
        let openURL: Signal<URL>
    }

    init() {}

    func transform(input: Input) -> Output {
        let openURL = PublishRelay<URL>()

        input.appInfoIndexPath
            .map { AppInfoType.allCases[$0.item] }
            .subscribe(
                with: self,
                onNext: { owner, infoType in
                switch infoType.interactionType {
                case let .withURL(url):
                    guard let url = URL(string: url) else { return }
                    openURL.accept(url)
                    break
                case let .withNavigate(step):
                    owner.steps.accept(step)
                    break
                }
            })
            .disposed(by: disposeBag)

        return Output(openURL: openURL.asSignal())
    }
}
