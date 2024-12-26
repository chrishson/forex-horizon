import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
        "conversionRateInput",
        "liveRateInput",
        "baseCurrency",
        "quoteCurrency"
    ]

    static values = {}

    update() {
        const liveRate = this.liveRateInputTarget.textContent.trim()
        this.conversionRateInputTarget.value = liveRate
    }

    swapCurrencies() {
        const baseCurrency = this.baseCurrencyTarget.value
        const quoteCurrency = this.quoteCurrencyTarget.value
        this.baseCurrencyTarget.value = quoteCurrency
        this.quoteCurrencyTarget.value = baseCurrency
        this.updateConversionRate()
    }

    updateConversionRate() {
      const url = "/forms/currency-conversion-form/update-conversion-rate"
      const params = new URLSearchParams({
        base_currency: this.baseCurrencyTarget.value,
        quote_currency: this.quoteCurrencyTarget.value
      })

      fetch(`${url}?${params}`, {
          method: "POST",
          headers: {
              "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
              // set Accept header to issue a proper TURBO_STREAM request
              "Accept": "text/vnd.turbo-stream.html"
          }
      })
          .then(response => response.text())
          .then(text => Turbo.renderStreamMessage(text));
    }
}