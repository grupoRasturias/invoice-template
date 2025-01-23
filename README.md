# Invoice Format Template (Typst)

This is a Quarto template that assists you in creating PDF invoices via Typst.

## Creating a New Invoice

You can use this as a template to create an invoice.
To do this, use the following command:

```bash
quarto use template grupoRasturias/invoice-template
```

This will install the extension and create an example qmd file that you can use as a starting place for your invoice.

## Usage

To use the format, you can use the format name `invoice-typst`.
For example:

```bash
quarto render template.qmd --to invoice-typst
```

Or update `template.qmd` and render it directly in RStudio.

You can view a preview of the rendered template below: [Invoice Template](https://github.com/grupoRasturias/invoice-template/blob/main/rendered_template.pdf)
