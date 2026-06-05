use oxc_allocator::Allocator;
use oxc_formatter::JsFormatOptions;
use oxc_span::SourceType;

#[rustler::nif]
fn format(source: String) -> Result<String, String> {
    let allocator = Allocator::default();
    let source_type = SourceType::default();
    let formatted = oxc_formatter::format(
        &allocator,
        &source,
        source_type,
        JsFormatOptions::default(),
        None,
    )
    .map_err(|error| error.to_string())?;
    let printed = formatted
        .print()
        .map_err(|error| format!("failed to print formatted code: {error}"))?;

    Ok(printed.into_code())
}

rustler::init!("Elixir.Oxfmt.NIF");
