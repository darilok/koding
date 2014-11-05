class PaypalFormView extends KDFormViewWithFields

  getInitialState: -> KD.utils.dict()

  constructor: (options = {}, data) ->

    @state = KD.utils.extend @getInitialState(), options.state

    options.fields = @getFields()

    super options, data

    @loadActionAttribute()


  submit: (event) ->


  loadActionAttribute: ->

    { planTitle, planInterval } = @state

    { paymentController } = KD.singletons

    paymentController.getPaypalToken planTitle, planInterval, (err, token) =>

      @state.token = token

      actionUrl = "https://www.sandbox.paypal.com/incontext?token=#{token}"
      @setAttribute 'action', actionUrl
      @setAttribute 'method', 'post'

      @emit 'PaypalTokenLoaded'


  getFields: -> {
    planTitle:
      defaultValue: @state.planTitle
      type: 'hidden'
      cssClass: 'hidden'
    planInterval:
      defaultValue: @state.planInterval
      type: 'hidden'
      cssClass: 'hidden'
    # success_url:
    #   defaultValue: 'http://lvh.me:8090/-/payments/paypal/return'
    #   type: 'hidden'
    #   cssClass: 'hidden'
    # cancel_url:
    #   defaultValue: 'http://lvh.me:8090/-/payments/paypal/cancel'
    #   type: 'hidden'
    #   cssClass: 'hidden'
  }
