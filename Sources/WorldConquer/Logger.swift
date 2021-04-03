import Foundation
import Logging

var appLogger: Logger?

func logInfo(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    appLogger?.info(Logger.Message(stringLiteral: message), file: file, function: function, line: line)
}

func logWarning(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    appLogger?.warning(Logger.Message(stringLiteral: message), file: file, function: function, line: line)
}

func logError(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    appLogger?.error(Logger.Message(stringLiteral: message), file: file, function: function, line: line)
}

func logCritical(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) {
    appLogger?.critical(Logger.Message(stringLiteral: message), file: file, function: function, line: line)
}
