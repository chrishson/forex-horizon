import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
        "conversionRateInput",
        "liveRateInput",
        "baseCurrencyTarget",
        "quoteCurrencyTarget"
    ]

    static values = {}

    update() {
        const liveRate = this.liveRateInputTarget.textContent.trim()
        this.conversionRateInputTarget.value = liveRate
    }

    updateConversionRate() {
      const form = this.element
      const url = "/income-forecast/update"
      const params = new URLSearchParams({
        base_currency: this.baseCurrencyTargetTarget.value,
        quote_currency: this.quoteCurrencyTargetTarget.value
      })

      fetch(`${url}?${params}`, {
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