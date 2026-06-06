use oxc_allocator::Allocator;
use oxc_formatter::{
    ArrowParentheses, AttributePosition, BracketSameLine, BracketSpacing,
    EmbeddedLanguageFormatting, Expand, JsFormatOptions, OperatorPosition, QuoteProperties,
    QuoteStyle, Semicolons, TrailingCommas,
};
use oxc_formatter_core::{IndentStyle, IndentWidth, LineEnding, LineWidth};
use oxc_span::SourceType;
use rustler::NifMap;

#[rustler::nif]
fn format(source: String, options: FormatterOptions) -> Result<String, String> {
    let allocator = Allocator::default();
    let source_type = SourceType::default();
    let options = options.try_into()?;
    let formatted = oxc_formatter::format(&allocator, &source, source_type, options, None)
        .map_err(|error| error.to_string())?;
    let printed = formatted
        .print()
        .map_err(|error| format!("failed to print formatted code: {error}"))?;

    Ok(printed.into_code())
}

#[derive(Debug, Default, NifMap)]
struct FormatterOptions {
    indent_style: Option<String>,
    indent_width: Option<u8>,
    line_ending: Option<String>,
    line_width: Option<u16>,
    quote_style: Option<String>,
    jsx_quote_style: Option<String>,
    quote_properties: Option<String>,
    trailing_commas: Option<String>,
    semicolons: Option<String>,
    arrow_parentheses: Option<String>,
    bracket_spacing: Option<bool>,
    bracket_same_line: Option<bool>,
    attribute_position: Option<String>,
    expand: Option<String>,
    experimental_operator_position: Option<String>,
    experimental_ternaries: Option<bool>,
    html_whitespace_sensitivity_ignore: Option<bool>,
    embedded_language_formatting: Option<String>,
}

impl TryFrom<FormatterOptions> for JsFormatOptions {
    type Error = String;

    fn try_from(options: FormatterOptions) -> Result<Self, Self::Error> {
        let mut format_options = JsFormatOptions::default();

        if let Some(value) = options.indent_style {
            format_options.indent_style = match value.as_str() {
                "space" => IndentStyle::Space,
                "tab" => IndentStyle::Tab,
                value => return Err(invalid_option("indent_style", value, "space or tab")),
            };
        }

        if let Some(value) = options.indent_width {
            format_options.indent_width = IndentWidth::try_from(value)
                .map_err(|error| format!("invalid indent_width: {error}"))?;
        }

        if let Some(value) = options.line_ending {
            format_options.line_ending = match value.as_str() {
                "lf" => LineEnding::Lf,
                "crlf" => LineEnding::Crlf,
                "cr" => LineEnding::Cr,
                value => return Err(invalid_option("line_ending", value, "lf, crlf, or cr")),
            };
        }

        if let Some(value) = options.line_width {
            format_options.line_width = LineWidth::try_from(value)
                .map_err(|error| format!("invalid line_width: {error}"))?;
        }

        if let Some(value) = options.quote_style {
            format_options.quote_style = quote_style("quote_style", value)?;
        }

        if let Some(value) = options.jsx_quote_style {
            format_options.jsx_quote_style = quote_style("jsx_quote_style", value)?;
        }

        if let Some(value) = options.quote_properties {
            format_options.quote_properties = match value.as_str() {
                "as_needed" => QuoteProperties::AsNeeded,
                "preserve" => QuoteProperties::Preserve,
                "consistent" => QuoteProperties::Consistent,
                value => {
                    return Err(invalid_option(
                        "quote_properties",
                        value,
                        "as_needed, preserve, or consistent",
                    ))
                }
            };
        }

        if let Some(value) = options.trailing_commas {
            format_options.trailing_commas = match value.as_str() {
                "all" => TrailingCommas::All,
                "es5" => TrailingCommas::Es5,
                "none" => TrailingCommas::None,
                value => {
                    return Err(invalid_option(
                        "trailing_commas",
                        value,
                        "all, es5, or none",
                    ))
                }
            };
        }

        if let Some(value) = options.semicolons {
            format_options.semicolons = match value.as_str() {
                "always" => Semicolons::Always,
                "as_needed" => Semicolons::AsNeeded,
                value => return Err(invalid_option("semicolons", value, "always or as_needed")),
            };
        }

        if let Some(value) = options.arrow_parentheses {
            format_options.arrow_parentheses = match value.as_str() {
                "always" => ArrowParentheses::Always,
                "as_needed" => ArrowParentheses::AsNeeded,
                value => {
                    return Err(invalid_option(
                        "arrow_parentheses",
                        value,
                        "always or as_needed",
                    ))
                }
            };
        }

        if let Some(value) = options.bracket_spacing {
            format_options.bracket_spacing = BracketSpacing::from(value);
        }

        if let Some(value) = options.bracket_same_line {
            format_options.bracket_same_line = BracketSameLine::from(value);
        }

        if let Some(value) = options.attribute_position {
            format_options.attribute_position = match value.as_str() {
                "auto" => AttributePosition::Auto,
                "multiline" => AttributePosition::Multiline,
                value => {
                    return Err(invalid_option(
                        "attribute_position",
                        value,
                        "auto or multiline",
                    ))
                }
            };
        }

        if let Some(value) = options.expand {
            format_options.expand = match value.as_str() {
                "auto" => Expand::Auto,
                "never" => Expand::Never,
                value => return Err(invalid_option("expand", value, "auto or never")),
            };
        }

        if let Some(value) = options.experimental_operator_position {
            format_options.experimental_operator_position = match value.as_str() {
                "start" => OperatorPosition::Start,
                "end" => OperatorPosition::End,
                value => {
                    return Err(invalid_option(
                        "experimental_operator_position",
                        value,
                        "start or end",
                    ))
                }
            };
        }

        if let Some(value) = options.experimental_ternaries {
            format_options.experimental_ternaries = value;
        }

        if let Some(value) = options.html_whitespace_sensitivity_ignore {
            format_options.html_whitespace_sensitivity_ignore = value;
        }

        if let Some(value) = options.embedded_language_formatting {
            format_options.embedded_language_formatting = match value.as_str() {
                "auto" => EmbeddedLanguageFormatting::Auto,
                "off" => EmbeddedLanguageFormatting::Off,
                value => {
                    return Err(invalid_option(
                        "embedded_language_formatting",
                        value,
                        "auto or off",
                    ))
                }
            };
        }

        Ok(format_options)
    }
}

fn quote_style(option: &str, value: String) -> Result<QuoteStyle, String> {
    match value.as_str() {
        "double" => Ok(QuoteStyle::Double),
        "single" => Ok(QuoteStyle::Single),
        value => Err(invalid_option(option, value, "double or single")),
    }
}

fn invalid_option(option: &str, value: &str, expected: &str) -> String {
    format!("invalid {option}: {value}; expected {expected}")
}

rustler::init!("Elixir.Oxfmt.NIF");
