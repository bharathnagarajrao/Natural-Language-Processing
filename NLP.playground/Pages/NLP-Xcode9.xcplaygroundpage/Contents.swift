//  Created by Bharath Nagaraj Rao on 8/25/18.
//  Copyright © Bharath Nagaraj Rao. All rights reserved.

import Foundation

welcome()

struct Source {
    //dominant Language Examples
    static let english    =   "The city of Mysuru is the cultural capital of Karnataka"
    static let kannada    =   "ಮೈಸೂರು ನಿಮ್ಮನ್ನು ಸ್ವಾಗತಿಸುತ್ತದೆ"
    static let devanagari =   "सत्यमेव जयते"
    static let guess      =   "Mysuru ನಿಮ್ಮನ್ನು ಸ್ವಾಗತಿಸುತ್ತದೆ"
    static let emoji      =   "🇫🇷 🏆 ⚽️ 🏃‍♂️"
    static let number     =   "25082018"
    static let gibberish  =   "ssssssssssss"
    //Lemma Examples
    static let lemmaExampleOne  = "Rajdhani runs between Bengaluru and Delhi daily except on Tuesdays"
    static let lemmaExampleTwo  = "PV Sindhu's hard work fetched her a medal in Olympics"
    //Name Type Example
    static let nameType = "Steve Jobs was born in Silicon valley, a place near San Francisco Bay Area in the northern part of the U.S. state of California. He co-founded Apple Inc along with Steve Wozniak."
    //Lexical Type Examples
    static let lexicalType = "Hey, I am extremely disappointed that you could not figure out such an easy assignment on your own."
}

//: dominant Language Detection

/// Method to determine dominant language in the given statement
/// - Parameter sourceText: Source string whose language needs to be determined
/// - Returns: Dominant language as String
func dominantLanguage(for sourceText: String) -> String {
    let dominantLanguageTagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
    dominantLanguageTagger.string = sourceText
    return dominantLanguageTagger.dominantLanguage.safeString
}
print("Source - \(Source.english)")
print("The dominant language is - \(dominantLanguage(for: Source.english))")


//: Tokenization

/// Tokenize the given statement based on options
/// Note: By default we tokenize the statement by words omitting punctuation & whitespace
/// - Parameters:
///   - sourceString: Source string
///   - sourceRange: Optional range which needs to be tokenized
///   - taggerUnit: Tagger unit as word, sentence, paragraph, etc
///   - taggerOptions: Tagger options to omit punctuation, white space, etc
/// - Returns: Array of tokenized strings
func tokens(for sourceString: String,
            sourceRange: NSRange? = nil,
            taggerUnit: NSLinguisticTaggerUnit = .word,
            taggerOptions: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace])
    -> [String]
{
    let tokenTagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
    tokenTagger.string = sourceString
    let range = sourceRange ?? NSRange(location: 0, length: sourceString.count)
    var tokens = [String]()
    tokenTagger.enumerateTags(in: range, unit: taggerUnit, scheme: .tokenType, options: taggerOptions) {
        tag, tokenRange, stop in
        guard let formattedString = sourceString as? NSString else { return }
        tokens.append(formattedString.substring(with: tokenRange))
    }
    return tokens
}
lineSeparators()
print("Source - \(Source.english)")
print("Tokenized strings - \(tokens(for: Source.english))")


//: Lemmatization

/// Lemmatize (ie, find the root word) the given statement based on options
/// Note: By default we lemmatize the statement by words omitting punctuation & whitespace
/// - Parameters:
///   - sourceString: Source string
///   - sourceRange: Optional range which needs to be lemmatized
///   - taggerUnit: Tagger unit as word, sentence, paragraph, etc
///   - taggerOptions: Tagger options to omit punctuation, white space, etc
/// - Returns: Array of lemmatized strings
func lemma(for sourceString: String,
           sourceRange: NSRange? = nil,
           taggerUnit: NSLinguisticTaggerUnit = .word,
           taggerOptions: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace])
    -> [String]
{
    let lemmaTagger = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)
    lemmaTagger.string = sourceString
    let range = sourceRange ?? NSRange(location: 0, length: sourceString.count)
    var tokens = [String]()
    lemmaTagger.enumerateTags(in: range, unit: taggerUnit, scheme: .lemma, options: taggerOptions) {
        tag, tokenRange, stop in
        if let lemmaString = tag?.rawValue {
            tokens.append(lemmaString)
        }
    }
    return tokens
}

lineSeparators()
print("Lemma Source - \(Source.lemmaExampleOne)")
print("Lemma - \(lemma(for: Source.lemmaExampleOne))")


//: Name Type

/// Identify person/organization name, place in a given statement
/// Note: By default identify names by words omitting punctuation & whitespace
/// - Parameters:
///   - sourceString: Source string
///   - sourceRange: Optional range
///   - taggerUnit: Tagger unit as word, sentence, paragraph, etc
///   - linguisticTags: Tags to identify person, place, organization name
///   - taggerOptions: Tagger options to omit punctuation, white space, etc
/// - Returns: Tuple specifying type & name (Ex: (PersonName, Bharath))
func nameType(for sourceString: String,
              sourceRange: NSRange? = nil,
              taggerUnit: NSLinguisticTaggerUnit = .word,
              linguisticTags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName],
              taggerOptions: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace])
    -> [(String, String)]
{
    let nameTypeTagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
    nameTypeTagger.string = sourceString
    let range = sourceRange ?? NSRange(location: 0, length: sourceString.count)
    var tokens = [(type: String, nameTag: String)]()
    nameTypeTagger.enumerateTags(in: range, unit: taggerUnit, scheme: .nameType, options: taggerOptions) {
        tag, tokenRange, stop in
        if let tag = tag, linguisticTags.contains(tag) {
            let nameType = (sourceString as NSString).substring(with: tokenRange)
            tokens.append((type: tag.rawValue, nameTag: nameType))
        }
    }
    return tokens
}

lineSeparators()
let nameTypes = nameType(for: Source.nameType)
print("Name Type Source - \(Source.nameType)")
for (type, name) in nameTypes {
    print("\(type) : \(name)")
}

//: Lexical Class

/// Identify parts of speech in a given statement
/// Note: By default we find parts of speech by words omitting punctuation & whitespace
/// - Parameters:
///   - sourceString: Source string
///   - sourceRange: Optional range
///   - taggerUnit: Tagger unit as word, sentence, paragraph, etc
///   - taggerOptions: Tagger options to omit punctuation, white space, etc
/// - Returns: Tuple specifying type & word (Ex: (Pronoun, you))
func lexicalClass(for sourceString: String,
                  sourceRange: NSRange? = nil,
                  taggerUnit: NSLinguisticTaggerUnit = .word,
                  taggerOptions: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace])
    -> [(String, String)]
{
    let lexicalTypeTagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
    lexicalTypeTagger.string = sourceString
    let range = sourceRange ?? NSRange(location: 0, length: sourceString.count)
    var tokens = [(type: String, word: String)]()
    lexicalTypeTagger.enumerateTags(in: range, unit: taggerUnit, scheme: .lexicalClass, options: taggerOptions) {
        tag, tokenRange, stop in
        if let unwrappedTag = tag {
            let word = (sourceString as NSString).substring(with: tokenRange)
            tokens.append((type: unwrappedTag.rawValue, word: word))
        }
    }
    return tokens
}

lineSeparators()
let lexicalTypes = lexicalClass(for: Source.lexicalType)
print("Lexical Type Source - \(Source.lexicalType)")
for (type, word) in lexicalTypes {
    print("\(type) : \(word)")
}

