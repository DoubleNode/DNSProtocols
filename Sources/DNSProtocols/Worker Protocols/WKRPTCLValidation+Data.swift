//
//  WKRPTCLValidation+Data.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

public struct WKRPTCLValidationData {
    public enum Regex
    {
        public static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        public static let phone = "^[0-9]{10}$"
        public static let state = "[A-Z][A-Z]"
        public static let postalCode = "[0-9]{5}"
    }
    public enum Config {
        public enum Address {
            public struct City {
                public var fieldName: String
                public var minimumLength: Int32?
                public var maximumLength: Int32?
                public var regex: String?
                public var required: Bool
                public init(fieldName: String = "City",
                            minimumLength: Int32? = 2,
                            maximumLength: Int32? = 250,
                            regex: String? = nil,
                            required: Bool = true) {
                    self.fieldName = fieldName
                    self.minimumLength = minimumLength
                    self.maximumLength = maximumLength
                    self.regex = regex
                    self.required = required
                }
            }
            public struct PostalCode {
                public var fieldName: String
                public var minimumLength: Int32?
                public var maximumLength: Int32?
                public var regex: String?
                public var required: Bool
                public init(fieldName: String = "Postal Code",
                            minimumLength: Int32? = 5,
                            maximumLength: Int32? = 5,
                            regex: String? = WKRPTCLValidationData.Regex.postalCode,
                            required: Bool = true) {
                    self.fieldName = fieldName
                    self.minimumLength = minimumLength
                    self.maximumLength = maximumLength
                    self.regex = regex
                    self.required = required
                }
            }
            public struct State {
                public var fieldName: String
                public var minimumLength: Int32?
                public var maximumLength: Int32?
                public var regex: String?
                public var required: Bool
                public init(fieldName: String = "State",
                            minimumLength: Int32? = 2,
                            maximumLength: Int32? = 2,
                            regex: String? = WKRPTCLValidationData.Regex.state,
                            required: Bool = true) {
                    self.fieldName = fieldName
                    self.minimumLength = minimumLength
                    self.maximumLength = maximumLength
                    self.regex = regex
                    self.required = required
                }
            }
            public struct Street {
                public var fieldName: String
                public var minimumLength: Int32?
                public var maximumLength: Int32?
                public var regex: String?
                public var required: Bool
                public init(fieldName: String = "Street Address",
                            minimumLength: Int32? = 2,
                            maximumLength: Int32? = 250,
                            regex: String? = nil,
                            required: Bool = true) {
                    self.fieldName = fieldName
                    self.minimumLength = minimumLength
                    self.maximumLength = maximumLength
                    self.regex = regex
                    self.required = required
                }
            }
            public struct Street2 {
                public var fieldName: String
                public var minimumLength: Int32?
                public var maximumLength: Int32?
                public var regex: String?
                public var required: Bool
                public init(fieldName: String = "Apartment/Suite/Building (Optional)",
                            minimumLength: Int32? = 0,
                            maximumLength: Int32? = 250,
                            regex: String? = nil,
                            required: Bool = false) {
                    self.fieldName = fieldName
                    self.minimumLength = minimumLength
                    self.maximumLength = maximumLength
                    self.regex = regex
                    self.required = required
                }
            }
        }
        public struct Birthdate {
            public var fieldName: String
            public var minimumAge: Int32?
            public var maximumAge: Int32?
            public var required: Bool
            public init(fieldName: String = "Birthdate",
                        minimumAge: Int32? = nil,
                        maximumAge: Int32? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimumAge = minimumAge
                self.maximumAge = maximumAge
                self.required = required
            }
        }
        public struct CalendarDate {
            public var fieldName: String
            public var minimum: Date?
            public var maximum: Date?
            public var required: Bool
            public init(fieldName: String = "Date",
                        minimum: Date? = nil,
                        maximum: Date? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimum = minimum
                self.maximum = maximum
                self.required = required
            }
        }
        public struct Email {
            public var fieldName: String
            public var regex: String?
            public var required: Bool
            public init(fieldName: String = "Email",
                        regex: String? = WKRPTCLValidationData.Regex.email,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.regex = regex
                self.required = required
            }
        }
        public struct Handle {
            public var fieldName: String
            public var minimumLength: Int32?
            public var maximumLength: Int32?
            public var regex: String?
            public var required: Bool = true
            public init(fieldName: String = "Handle",
                        minimumLength: Int32? = 6,
                        maximumLength: Int32? = 80,
                        regex: String? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimumLength = minimumLength
                self.maximumLength = maximumLength
                self.regex = regex
                self.required = required
            }
        }
        public struct Name {
            public var fieldName: String
            public var minimumLength: Int32?
            public var maximumLength: Int32?
            public var regex: String?
            public var required: Bool
            public init(fieldName: String = "Name",
                        minimumLength: Int32? = 2,
                        maximumLength: Int32? = 250,
                        regex: String? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimumLength = minimumLength
                self.maximumLength = maximumLength
                self.regex = regex
                self.required = required
            }
        }
        public struct Number {
            public var fieldName: String
            public var minimum: Int64?
            public var maximum: Int64?
            public var required: Bool
            public init(fieldName: String = "Number",
                        minimum: Int64? = nil,
                        maximum: Int64? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimum = minimum
                self.maximum = maximum
                self.required = required
            }
        }
        public struct Password {
            public var fieldName: String
            public var minimumLength: Int32?
            public var maximumLength: Int32?
            public var required: Bool
            public var strength: WKRPTCLPassStrength.Level
            public init(fieldName: String = "Password",
                        minimumLength: Int32? = nil,
                        maximumLength: Int32? = nil,
                        required: Bool = true,
                        strength: WKRPTCLPassStrength.Level = .strong) {
                self.fieldName = fieldName
                self.minimumLength = minimumLength
                self.maximumLength = maximumLength
                self.required = required
                self.strength = strength
            }
        }
        public struct Percentage {
            public var fieldName: String
            public var minimum: Float?
            public var maximum: Float?
            public var required: Bool
            public init(fieldName: String = "Percentage",
                        minimum: Float? = nil,
                        maximum: Float? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimum = minimum
                self.maximum = maximum
                self.required = required
            }
        }
        public struct Phone {
            public var fieldName: String
            public var minimumLength: Int32?
            public var maximumLength: Int32?
            public var regex: String?
            public var required: Bool
            public init(fieldName: String = "Phone",
                        minimumLength: Int32? = 10,
                        maximumLength: Int32? = 10,
                        regex: String? = WKRPTCLValidationData.Regex.phone,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimumLength = minimumLength
                self.maximumLength = maximumLength
                self.regex = regex
                self.required = required
            }
        }
        public struct Search {
            public var fieldName: String
            public var minimumLength: Int32?
            public var maximumLength: Int32?
            public var regex: String?
            public var required: Bool
            public init(fieldName: String = "Search",
                        minimumLength: Int32? = nil,
                        maximumLength: Int32? = nil,
                        regex: String? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimumLength = minimumLength
                self.maximumLength = maximumLength
                self.regex = regex
                self.required = required
            }
        }
        public struct State {
            public var fieldName: String
            public var minimumLength: Int32?
            public var maximumLength: Int32?
            public var regex: String?
            public var required: Bool
            public init(fieldName: String = "State",
                        minimumLength: Int32? = 3,
                        maximumLength: Int32? = 3,
                        regex: String? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimumLength = minimumLength
                self.maximumLength = maximumLength
                self.regex = regex
                self.required = required
            }
        }
        public struct UnsignedNumber {
            public var fieldName: String
            public var minimum: UInt64?
            public var maximum: UInt64?
            public var required: Bool
            public init(fieldName: String = "Unsigned Number",
                        minimum: UInt64? = nil,
                        maximum: UInt64? = nil,
                        required: Bool = true) {
                self.fieldName = fieldName
                self.minimum = minimum
                self.maximum = maximum
                self.required = required
            }
        }
    }
}
