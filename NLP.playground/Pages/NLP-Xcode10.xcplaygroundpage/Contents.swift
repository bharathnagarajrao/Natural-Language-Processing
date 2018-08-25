//  Created by Bharath Nagaraj Rao on 8/25/18.
//  Copyright © Bharath Nagaraj Rao. All rights reserved.

import Foundation
import NaturalLanguage

welcome()

struct Source {
    //Dominent Language Examples
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

//: Dominant Language Detection

/// Method to determine dominant language in the given statement
/// - Parameter sourceText: Source string whose language needs to be determined
/// - Returns: Dominant language as String
func dominantLanguage(for sourceText: String) -> NLLanguage? {
    let naturalLanguageRecognizer = NLLanguageRecognizer()
    naturalLanguageRecognizer.processString(sourceText)
    return naturalLanguageRecognizer.dominantLanguage
}

let language = dominantLanguage(for: Source.english)
print("Source - \(Source.english)")
print("The dominant language is - \(language.safeLanguage)")


//: Tokenization

/// Tokenize the given statement based on options
/// Note: By default we tokenize the statement by words
/// - Parameters:
///   - sourceString: Source string
///   - tokenUnit: Token unit as word, sentence, paragraph, etc
/// - Returns: Tuple specifying tokenized string & attributes (Ex: (🏆, emoji))
func tokens(for sourceString: String,
            tokenUnit: NLTokenUnit = .word)
    -> [(String, NLTokenizer.Attributes)]
{
    let tokenizer = NLTokenizer(unit: tokenUnit)
    tokenizer.string = sourceString
    var tokens = [(type: String, attributes: NLTokenizer.Attributes)]()
    tokenizer.enumerateTokens(in: sourceString.startIndex ..< sourceString.endIndex) { (tokenRange, tokenAttributes) -> Bool in
        tokens.append((type: (String(sourceString[tokenRange])), attributes: tokenAttributes))
        return true
    }
    return tokens
}

lineSeparators()
let tokenTypes = tokens(for: Source.emoji)
print("Source - \(Source.emoji)")
for (type, attributes) in tokenTypes {
    print("\(type) : \(attributes.contains(.emoji))")
}

//: Lemmatization

/// Lemmatize (ie, find the root word) the given statement based on options
/// Note: By default we lemmatize the statement by words omitting punctuation & whitespace
/// - Parameters:
///   - sourceString: Source string
///   - taggerUnit: Tagger unit as word, sentence, paragraph, etc
///   - taggerOptions: Tagger options to omit punctuation, white space, etc
/// - Returns: Array of lemmatized strings
func lemma(for sourceString: String,
           taggerUnit: NLTokenUnit = .word,
           taggerOptions: NLTagger.Options = [.omitPunctuation, .omitWhitespace])
    -> [String]
{
    let lemmaTagger = NLTagger(tagSchemes: [.lemma])
    lemmaTagger.string = sourceString
    var tokens = [String]()
    lemmaTagger.enumerateTags(in: sourceString.startIndex ..< sourceString.endIndex, unit: taggerUnit, scheme: .lemma, options: taggerOptions) {
        (tag, tokenRange) -> Bool in
        if let lemmaTag = tag {
            tokens.append(lemmaTag.rawValue)
        }
        return true
    }
    return tokens
}

lineSeparators()
print("Lemma Source - \(Source.lemmaExampleTwo)")
print("Lemma - \(lemma(for: Source.lemmaExampleTwo))")

//: Name Type

/// Identify person/organization name, place in a given statement
/// Note: By default identify names by words omitting punctuation & whitespace
/// - Parameters:
///   - sourceString: Source string
///   - taggerUnit: Tagger unit as word, sentence, paragraph, etc
///   - linguisticTags: Tags to identify person, place, organization name
///   - taggerOptions: Tagger options to omit punctuation, white space, etc
/// - Returns: Tuple specifying type & name (Ex: (PersonName, Bharath))
func nameType(for sourceString: String,
              taggerUnit: NLTokenUnit = .word,
              linguisticTags: [NLTag] = [.personalName, .placeName, .organizationName],
              taggerOptions: NLTagger.Options = [.omitPunctuation, .omitWhitespace])
    -> [(String, String)]
{
    let nameTypeTagger = NLTagger(tagSchemes: [.nameType])
    nameTypeTagger.string = sourceString
    var tokens = [(type: String, nameTag: String)]()
    nameTypeTagger.enumerateTags(in: sourceString.startIndex ..< sourceString.endIndex, unit: taggerUnit, scheme: .nameType, options: taggerOptions) {
        (tag, tokenRange) -> Bool in
        if let tag = tag, linguisticTags.contains(tag) {
            let nameType = String(sourceString[tokenRange])
            tokens.append((type: tag.rawValue, nameTag: nameType))
        }
        return true
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
///   - taggerUnit: Tagger unit as word, sentence, paragraph, etc
///   - taggerOptions: Tagger options to omit punctuation, white space, etc
/// - Returns: Tuple specifying type & word (Ex: (Pronoun, you))
func lexicalClass(for sourceString: String,
                  taggerUnit: NLTokenUnit = .word,
                  taggerOptions: NLTagger.Options = [.omitPunctuation, .omitWhitespace])
    -> [(String, String)]
{
    let lexicalTypeTagger = NLTagger(tagSchemes: [.lexicalClass])
    lexicalTypeTagger.string = sourceString
    var tokens = [(type: String, word: String)]()
    lexicalTypeTagger.enumerateTags(in: sourceString.startIndex ..< sourceString.endIndex, unit: taggerUnit, scheme: .lexicalClass, options: taggerOptions) {
        (tag, tokenRange) -> Bool in
        if let unwrappedTag = tag {
            let word = String(sourceString[tokenRange])
            tokens.append((type: unwrappedTag.rawValue, word: word))
        }
        return true
    }
    return tokens
}

lineSeparators()
let lexicalTypes = lexicalClass(for: Source.lexicalType)
print("Lexical Type Source - \(Source.lexicalType)")
for (type, word) in lexicalTypes {
    print("\(type) : \(word)")
}

