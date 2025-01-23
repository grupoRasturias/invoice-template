// Parse dates
#let parse-date(date) = {
  let date = date.replace("\\", "")
  let date = str(date).split("-").map(int)
  datetime(year: date.at(0), month: date.at(1), day: date.at(2))
}

// Main function
#let invoice(
  title: none,
  description: none,
  logo: none,
  sender: none,
  invoice: none,
  bank: none,
  recipient: none,
  lang: "es",
  region: "ES",
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  font: "Helvetica Neue",
  heading-family: none,
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  fontsize: 12pt,
  title-size: 1.5em,
  body
) = {

  // Heading style
  show heading: it => [
    #set par(leading: heading-line-height)
    #set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color, hyphenate: false)
    #it.body
  ]
  
  // Defining variables
  let issued = parse-date(invoice.at("issued"))

  set document(
    title: "Factura " + invoice.at("number").replace("\\", "") + " - " + recipient.at("name").replace("\\", ""),
    author: sender.at("name").replace("\\", ""),
    date: issued
  )
  set page(
    paper: paper,
    margin: margin,
  )
  set par(justify: true)
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
  )

  // Logo watermark
  place(
    image(logo, width: 5cm),
    dx: 20%,
    dy: 60%
  )

  // Sender and recipient information
  grid(
    columns: (50%, 50%),
    // Sender
    align(left, {
      // Sender name
      heading(level: 2, sender.at("name").replace("\\", ""))
      // Address
      if "address" in sender and sender != none {
        v(fontsize * 0.5) // Blank space
        emph(sender.at("address").at("street").replace("\\", ""))
        linebreak()
        sender.at("address").at("zip").replace("\\", "") + " " + sender.at("address").at("city").replace("\\", "")
        if "state" in sender.at("address") and not sender.at("address").at("state") in (none, "") {
          ", " + sender.at("address").at("state").replace("\\", "")
        } else {
          ""
        }
        linebreak()
        sender.at("address").at("country").replace("\\", "")
      }
      v(fontsize * 0.1) // Blank space
      // Email and NIF
      if "email" in sender and sender != none {
        link("mailto:" + sender.at("email").replace("\\", ""))
      } else {
        hide("a")
      }
      linebreak()
      if "nif" in sender and sender != none and sender.at("nif") != "" {
        "NIF: " + sender.at("nif").replace("\\", "")
      } else {
        hide("a")
      }
    }),

    // Recipient
    align(right, {
      // Recipient name
      heading(level: 2, recipient.at("name").replace("\\", ""))
      // Address
      if "address" in recipient and recipient != none {
        v(fontsize * 0.5) // Blank space
        emph(recipient.at("address").at("street").replace("\\", ""))
        linebreak()
        recipient.at("address").at("zip").replace("\\", "") + " " + recipient.at("address").at("city").replace("\\", "")
        if "state" in recipient.at("address") and not recipient.at("address").at("state") in (none, "") {
          ", " + recipient.at("address").at("state").replace("\\", "")
        } else {
          ""
        }
        linebreak()
        recipient.at("address").at("country").replace("\\", "")
      }
    })
  )

  v(fontsize * 1) // Blank space

  // Invoice information
  align(left, {
    // Issued date
    if "issued" in invoice and invoice != none {
      strong("Fecha: ") + invoice.at("issued").replace("\\", "")
      linebreak()
    } else {
      hide("a")
    }
    // Invoice number
    if "number" in invoice and invoice != none and invoice.at("number") != "" {
      strong("Nº Factura: ") + invoice.at("number").replace("\\", "")
      linebreak()
    } else {
      hide("a")
    }
  })

  v(fontsize * 2) // Blank space

  // Table
  align(left, {
    // Table title
    if title != none {
      heading(level: 1, title.replace("\\", ""))
      if description != none {
        emph(description.replace("\\", ""))
      }
    }
    // Table content
    body
  })

  // Exemption
  grid(
    columns: (60%, 40%),
    hide("a"), // Hide first column
    align(right, if "exempted" in sender and sender != none and sender.exempted != "none" and sender.exempted != none {
      text(luma(100), emph(sender.at("exempted").replace("\\", "")), size: 8pt)
    } else {
      hide("a")
    })
  )

  align(bottom, {
  // Gracias!
    table(
      columns: 100%,
      rows: 20pt,
      fill: luma(240),
      inset: 0pt,
      align: (center + horizon),
      stroke: none,
      [¡Gracias!]
    )
    // Bank information
    if "bic" in bank and "iban" in bank and bank != none {
      // Heading
      heading(level: 3, "Información de pago")
      v(fontsize * 0.5)
      // BIC
      "BIC: " + bank.at("bic").replace("\\", "")
      linebreak()
      // IBAN
      "IBAN: " + bank.at("iban").replace("\\", "")
      linebreak()
    } else {
      hide("a")
    }

    v(fontsize * 2) // Blank space
  })
}
