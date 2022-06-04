# Translation in Shiny apps using shiny.i18n

## Defining strings to be translated

shiny.i18n does not allow translation of multiline strings, therefore we have to work around it a bit.

- **For short strings** use the string itself as the translation key:

        i18n$t('Input your name:')

- **For longer multiline strings** use a short keyword as the translation key.

        i18n$t('long_text_1')

## Translating dropdowns

Translating dropdown labels is posible with some work. Define the choices as a named list like this:

    dropdownChoices <- c('one', 'two', 'three')
    names(dropdownChoices) <- c(i18n$t('Option 1'), i18n$t('Option 2'), i18n$t('Option 3'))

Then use them in a `selectInput`:

    selectInput('dropdown', label=i18n$t("Useless dropdown"), choices=dropdownChoices)

## Extracting strings to a JSON file

shiny.i18n includes a function which parses R code and extracts translation strings

    library(shiny.i18n)
    create_translation_file('app.R')

Running the above in an R shell will generate a `translations.json` file like this:

    {
        "translation": [
            {
                "key": "Old Faithful Geyser Data"
            },
            {
                "key": "Number of bins:"
            }
        ],
        "languages": [
            "key"
        ]
    }

Then one just has to add translations to the file:

    {
        "translation": [
            {
                "key": "Old Faithful Geyser Data",
                "es": "Datos del Géiser 'Old Faithful'"
            },
            {
                "key": "Number of bins:",
                "es": "Número de barras:"
            }
        ],
        "languages": [
            "key",
            "es"
        ]
    }

Notice how we're using `key` to refer to the default language. This is OK until we have to use single-line keys for multiline blocks of text. An idea:

 1. Defer translation of multiline blocks of text until the very end, at the beginning only translate single-line phrases using `"key"` as English.
 2. Use a little program to copy every "key": "XXX" entry in the `translation.json` file into a `"en": "XXX"` entry.
 3. Translate the long texts in the `"en"` keys.
 4. Update the source code to use `en` as for the English language where necessary (e.g. in the language chooser). At this point the strings in `key` become unused.

**Warning: `create_translation_file` will overwrite `translation.json`!** An option to be safer is to rename the file before starting translation to something like `final-translation.json` and then instructing shiny.i18n to use that file as the source:

    
    i18n <- Translator$new(translation_json_path = paste0(getwd(), '/final-translation.json') )