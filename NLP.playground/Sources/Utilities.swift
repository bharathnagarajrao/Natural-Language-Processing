//  Created by Bharath Nagaraj Rao on 8/25/18.
//  Copyright © Bharath Nagaraj Rao. All rights reserved.


import Foundation
import NaturalLanguage // Comment this line if you are on Xcode Version < 10.0

struct Message {
    static let welcome = """

#########################################################
#                                                       #
#   Welcome to Swift Bengaluru Meetup - Aug 2018        #
#                                                       #
#########################################################


"""
    static let lineSeparators = "\n\n"
}

public func welcome() {
    print(Message.welcome)
}

public func lineSeparators() {
    print(Message.lineSeparators)
}


extension Optional where Wrapped == String {
    public var safeString: String {
        if let originalString = self {
            return originalString
        }
        return "unknown"
    }
}

// Comment this snippet if you are on Xcode Version < 10.0
extension Optional where Wrapped == NLLanguage {
    public var safeLanguage: String {
        if let actualString = self?.rawValue {
            return actualString
        }
        return "unknown"
    }
}
