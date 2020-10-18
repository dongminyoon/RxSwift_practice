## Observable, Disposable

***RxSwift는 무엇인가?***

> 비동기 프로그래밍을 관찰 가능한 흐름으로 지원해주는 API입니다.
>
> 옵저버 패턴과 이터레이터 패턴 그리고 함수형 프로그래밍을 조합한 반응형 프로그램입니다.

먼저 ***RxSwif***t의 뜻을 보면 **Reactive eXtension+ Swift**의 합성어입니다.

위에서 사용되었던 핵심 단어들을 살펴보면 **관찰 가능한, 반응형**이라는 단어들이 있죠⁉️

하나씩 살펴볼게요.

<br>

**반응형**

반응을 한다고 뜻대로 이해하시면 될 것 같은데, 예를 들어 UIButton이 있으면 버튼을 눌렀을 때나 서버 통신을 한다면 서버 통신이 완료되었을 때 반응하는 행동을 한다는 것입니다.

**관찰 가능한**

Observer패턴을 아시나요? 바로 어떤 이벤트를 관찰하다 응답이 있을 시 반응을 해주는 것이죠. 그렇다면 반응을 하기 위해선 어떻게 해야할까요. 버튼이 눌리는지, 서버에 데이터를 받아왔는지 관찰을하면 되겠죠.

직접 RxSwift을 사용할 때 **Observable**이라는 레퍼런스 타입을 이용해서 값을 관찰하고 어떤 행위를 할 것입니다.

<br>

***RxSwift을 사용하는 이유?***

1. RxSwift을 사용하지 않은 경우는 여러 가지의 쓰레드를 넘나 들고 Completion 메소드를 작성하며 가독성도 좋지 않고 머리가 아픈 경우가 많지만 Rx을 사용하면 이러한 현상을 해결할 수 있다.
2. 코드가 깔끔해진다.
3. 비동기 처리가 모두 Observable로 할 수 있게 된다.

<br>

### Observable, Disposable

* **Observable**

  이게 가장 중요한 인스턴스인데 이것을 이용해서 관찰을 하고 그 결과 값을 가지고 처리한다. Observer가 Observable을 구독하는 형태입니다.

  즉, Observable이 배출하는 항목에 대해 Observer가 반응하는 방식입니다.

  여기서 Observable은 세 가지 이벤트에 반응하게 됩니다.

  * `next` :  Observable은 어떤 항목을 배출하는데 이것이 바로 next이다. 이 스트림을 관찰 및 구독해서 원하는 행동을 한다.
* `error` : Observable이 값을 배출하다 에러가 발생하면 error을 배출하고 종료한다.
  * `complete` : 성공적으로 next 스트림이 완료되었을 때, complete 이벤트가 발생한다.
  
  🔴 Error, Complete가 발생한 경우에 둘 다 Dispose가 불린다.
<br>
  
✔️ 간단한 예제
  
```swift
  func fromArray(_ arr: [Int]) -> Observable<Int> {
  return Observable<Int>.create { observe -> Disposable in
                                   for element in arr {
                                     observer.onNext(element)
                                   }
  
                                   observer.onCompleted()
  
                                   return Disposable.create()
    }
  }
  
  fromArray([1, 2, 5, 3, 4])
  	.subscribe { 
      event in
      switch event {
        case .next(let value): print(value)
        case .error(let error): print(error)
        case .completed: print("completed")
      }
  	}
  	.dispose()
  // 1
  // 2
  // 5
  // 3
  // 4
  // completed
  ```

<br>

* **Disposable**

  Disposable 변수를 이용해서 해당 작업을 사용 후 처분할 수 있는(?) 정도로 이해하시면 될 것 같습니다. 
  
  Observable의 subscribe을 사용하면 모두 disposable을 반환하는데 이를 이용해서 해제시켜줄 수 있습니다. 작업을 취소하는 것도 가능해집니다.
  
  `DisposeBag` : 이 레퍼런스를 이용해 disposable 변수들을 담아두었다 활용할 수도 있습니다. DisposeBag 인스턴스를 생성하고 이 인스턴스가 소멸될 때, Disposebag안의 변수들이 dispose됩니다.
  <br>
  
  ✔️ 간단한 예제
  
  ```swift
  let disposable = Observable.from([1, 2, 3, 5, 6])
              .subscribe(onNext: { element in
                  print(element)
                  sleep(1)
              }, onCompleted: {
                  print("completed")
              }, onDisposed: {
                  print("disposed")
              })
  
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    disposable.dispose()
  }
  
  // 1
  // 2
  // disposed
  
  var disposeBag = DisposeBag()
  
  button.rx.tap
  	.subscribe(onNext: {
    	print("Tap")
  	}, onCompleted: {
   	 print("completed")
  	}, onDisposed: {
   	 print("disposed")
  	})
  	.disposed(by: disposeBag)
  ```
  
  RxCocoa 요소의 경우에 DisposeBag에 담는 것이 아닌 바로 dispose을 실행하게 되면 Observer로부터 관찰을 받지 않겠다고 선언하는 것이기 때문에 주요 이벤트들이 동작하지 않고 바로 dispose()되었습니다.
  
  즉, UI 요소의 경우에는 DisposeBag에 담아두었다 UIViewController가 해제될 때, DisposeBag을 dispose 시키는 방식으로 사용하면 메모리 관리에 좋을 것 같습니다.
