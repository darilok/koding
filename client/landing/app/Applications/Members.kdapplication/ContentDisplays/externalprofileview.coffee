class ExternalProfileView extends JView

  constructor: (options, account) ->

    options.tagName  or= 'a'
    options.provider or= ''
    options.cssClass   = KD.utils.curry "external-profile #{options.provider}", options.cssClass
    options.attributes = href : '#'

    super options, account

    @linked        = no
    {provider}     = @getOptions()
    mainController = KD.getSingleton 'mainController'

    mainController.on "ForeignAuthSuccess.#{provider}", @bound "setLinkedState"


  viewAppended:->

    super

    @setTooltip title : "Click to bind your #{@getOption 'nicename'} account"
    @setLinkedState()

  setLinkedState:->

    return  unless @parent
    account    = @parent.getData()
    {provider} = @getOptions()

    account.fetchStorage "ext|profile|#{provider}", (err, storage)=>
      return warn err  if err
      return           unless storage
      @setData storage

      @$().detach()
      @$().prependTo @parent.$('.external-profiles')
      @linked = yes
      @setClass 'linked'
      @setAttributes
        href   : JsPath.getAt @getData().content, @getOption('urlLocation')
        target : '_blank'

    account     = @parent.getData()
    {firstName} = account.profile
    provider    = @getOption 'nicename'

    @setTooltip if KD.isMine account
    then title : "Go to my #{provider} profile"
    else title : "Go to #{firstName}'s #{provider} profile"


  click:(event)->

    return log 'send him to external profile' if @linked

    {provider} = @getOptions()
    if KD.isMine @parent.getData()
      KD.utils.stopDOMEvent event
      KD.singletons.oauthController.openPopup provider


  pistachio:->

    """
    <span class="icon"></span>
    """