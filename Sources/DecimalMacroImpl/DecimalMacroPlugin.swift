import SwiftCompilerPlugin
import SwiftSyntaxMacros

/// A compiler plugin containing the `decimal` macro.
@main
struct DecimalMacroPlugin: CompilerPlugin {

  /// The macros provided by this plugin.
  let providingMacros: [Macro.Type] = [DecimalMacro.self]

}
