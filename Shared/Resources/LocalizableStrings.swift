// swiftformat:disable all
// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localized {

  internal enum Distance {
    internal enum Title {
      /// 5K
      internal static let fiveK = Localized.tr("Localizable", "distance.title.five_k")
      /// Half Marathon
      internal static let halfMarathon = Localized.tr("Localizable", "distance.title.half_marathon")
      /// Marathon
      internal static let marathon = Localized.tr("Localizable", "distance.title.marathon")
      /// 10K
      internal static let tenK = Localized.tr("Localizable", "distance.title.ten_k")
    }
  }

  internal enum Row {
    /// Calculate
    internal static let calculate = Localized.tr("Localizable", "row.calculate")
    internal enum Distance {
      /// Choose Event
      internal static let choose = Localized.tr("Localizable", "row.distance.choose")
      /// or
      internal static let or = Localized.tr("Localizable", "row.distance.or")
    }
  }

  internal enum RowType {
    /// Distance
    internal static let distance = Localized.tr("Localizable", "row_type.distance")
    /// Pace
    internal static let pace = Localized.tr("Localizable", "row_type.pace")
    /// Time
    internal static let time = Localized.tr("Localizable", "row_type.time")
  }

  internal enum RunningPaceView {
    /// Race Pace Calculator
    internal static let title = Localized.tr("Localizable", "running_pace_view.title")
  }

  internal enum TimeUnits {
    /// hr
    internal static let hour = Localized.tr("Localizable", "time_units.hour")
    /// min
    internal static let minute = Localized.tr("Localizable", "time_units.minute")
    /// sec
    internal static let second = Localized.tr("Localizable", "time_units.second")
  }

  internal enum Units {
    internal enum Kilometers {
      /// km
      internal static let shortened = Localized.tr("Localizable", "units.kilometers.shortened")
      /// Kilometers
      internal static let title = Localized.tr("Localizable", "units.kilometers.title")
    }
    internal enum Miles {
      /// mi
      internal static let shortened = Localized.tr("Localizable", "units.miles.shortened")
      /// Miles
      internal static let title = Localized.tr("Localizable", "units.miles.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localized {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
public final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}

