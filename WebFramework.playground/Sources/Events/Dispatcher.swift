public protocol Event {}

public protocol ErasedListener {
    func matches(eventType: Event.Type) -> Bool
    func dispatchIfMatches(event: Event) -> Any?
}

public struct Listener<I: Event, O>: ErasedListener {
    let dispatch: I -> O
    
    public func matches(eventType: Event.Type) -> Bool {
        return matches(String(eventType))
    }
    
    func matches(eventType: String) -> Bool {
        return eventType == String(I.self)
    }
    
    public func dispatchIfMatches(event: Event) -> Any? {
        if matches(String(event.dynamicType)) {
            return dispatch(event as! I)
        }
        
        return nil
    }
}

public protocol Dispatcher {
    func listen<E: Event>(listener: E -> Void)
    func fire(event: Event) -> [Any]
    func queue<E: Event>(event: E)
    func flushQueueOf<E: Event>(eventType: E.Type)
    func flushQueue()
    func forgetListeners()
    func forgetListenersFor<E: Event>(event: E.Type)
    func emptyQueueOf<E: Event>(eventType: E.Type)
    func emptyQueue()
}

public class MyDispatcher: Dispatcher {
    var listeners = [ErasedListener]()
    var queuedEvents = [Event]()
    
    public init() {}
    
    public func listen<E: Event, O>(listener: E -> O) {
        let concreteListener = Listener(dispatch: listener)
        
        listeners.append(concreteListener as ErasedListener)
    }
    
    public func fire(event: Event) -> [Any] {
        var responses = [Any]()
        
        for listener in listeners {
            if let response = listener.dispatchIfMatches(event) where ((response as? Void) == nil) {
                responses.append(response)
            }
        }
        
        return responses
    }
    
    public func queue<E: Event>(event: E) {
        queuedEvents.append(event)
    }
    
    public func flushQueue() {
        for event in queuedEvents {
            fire(event)
        }
        emptyQueue()
    }
    
    public func emptyQueue() {
        queuedEvents = []
    }
    
    public func forgetListeners() {
        listeners = []
    }
    
    public func flushQueueOf<E: Event>(eventType: E.Type) {
        for event in queuedEvents where String(event.dynamicType) == String(eventType) {
            fire(event)
        }
        emptyQueueOf(eventType)
    }
    
    public func forgetListenersFor<E: Event>(eventType: E.Type) {
        listeners = listeners.filter { !$0.matches(eventType) }
    }
    
    public func emptyQueueOf<E: Event>(eventType: E.Type) {
        queuedEvents = queuedEvents.filter { String($0.dynamicType) != String(eventType) }
    }
}