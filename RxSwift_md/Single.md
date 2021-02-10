## Single

`Single`은 `Observable`의 한 형태이며, `Observable`은 **`onNext`**, **`onError`**, **`onCompleted`**, **`onDisposed`** 방출하는 반면 `Single`은 **`onSuccess`**, **`onError`** 두 가지의 이벤트만을 방출합니다. 

그리고 `Single`과 `Observable`의 가장 큰 차이는 `Observable`은 연속된 이벤트를 방출하지만 `Single`은 위의 메소드 중 하나만 단 한번만 호출하고 이 메소드가 호출하고 `Single`의 생명주기는 끝나고 구독이 종료되게 됩니다.

예로 다음의 경우를 보겠습니다.

```swift
Single<Int>.create { 
    single in
    single(.success(10))
    single(.success(20))
    return Disposables.create()
}.subscribe(onSuccess: {
    print($0)
}, onError: {
    print($0)
}).disposed(by: disposeBag)
/*
Print :
10
*/
```

10만이 출력되고 우리가 출력될 것이라고 기대했던 20은 출력이 되지 않습니다. 바로 `Single`의 특징인 메소드 중 단 하나만 호출하고 생명주기가 끝이 나기 때문에 일어나는 현상입니다.

그렇다면 `Observable`은 어떨까요?

```swift
Observable<Int>.create {
    observer in
    observer.onNext(10)
    observer.onNext(20)
    return Disposables.create()
}.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)
/*
Print:
10
20
*/
```

10, 20 모두가 출력됩니다. 어때요..? `Single`과 `Observable`의 차이가 와닿나요.

<br>

## Single 생성법

그렇다면 이 `Single`이라는 타입의 선언법과 사용하는 방법에 대해 간단히 알아보겠습니다. 우선 생성하는 방법은 `Single`은 역시 다양한 연산자들을 제공합니다. 더 자세한 연산자들은 홈페이지를 통해 알아주세요..!!

### Just

```swift
Single<Int>.just(1)
    .subscribe(onSuccess: {
        print($0)
    }, onError: {
        print($0)
    }).disposed(by: disposeBag)
```

<br>

### Create

```swift
Single<Int>.create {
    single in
    single(.success(10))
    return Disposables.create()
}.subscribe(onSuccess: {
  	print($0)
}, onError: {
  	print($0)
}).disposed(by: disposeBag)
```

일단은 생성을 위해서는 다음과 같은 연산자들이 지원이 되는 것 같네요... 더 찾아보는데 보이지가 않네요. 평소 알고계시던 from, of 같은 경우는 `Single`의 특성상 한 번의 이벤트를 방출하고 구독이 종료되기 때문에 지원하지 않는 것 같아요.

`Single`이라는 타입을 가장 사용하기 좋은 곳을 생각해보았을 때, 아무래도 Swift 5에서부터 `Result` 타입이 지원되는데, 역시 HTTP 통신을 통해 받아오는 값에 대해 성공과 실패를 판단하기 위해 `Single`을 사용해서 전달하는 것이 효율적이라는 생각이 듭니다..!!