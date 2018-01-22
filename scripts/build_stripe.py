import stripe
# from private.private import config

# stripe.api_key = config['stripe']['test']
stripe.api_key = '<test api key here>'

basic_subscription = stripe.Plan.create(
  currency='usd',
  interval='month',
  name='Basic Subscription',
  amount=0,
  id='basic-subscription'
)

premium_subscription = stripe.Plan.create(
  currency='usd',
  interval='month',
  name='Premium Subscription',
  amount=5,
  id='premium-subscription'
)
