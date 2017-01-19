#Tink

A simple SMS-based chatbot designed to help couples discover mutual interests.

##How it works

Every few days, Tink will pick a random time to text randomly-selected yes-or-no questions from a list of questions to both people in a couple. When both people reply "Y" to the same question, it will notify both parties about a potential matching interest.

Basically it's Tinder, but for couples. But no, not like that. (Eww.)

##Dependencies

###End-user Application
* *nix
* RVM
* Ruby/Rails
* Foreman
* Twilio
* Google App with Credentials API turned on

##Set up
1. Set up a Twilio account
1. Set up a Google application
  1. Turn on the "credentials" API
  1. Set redirect URL to `http(s)://<server>:<port>/auth/google_oauth2`
1. Install foreman
1. Install RVM
1. Clone the repo and `cd` into it (following RVM prompts, if any)
1. `bundle`
1. `db:setup`
1. `whenever --update-crontab`

##Configuration
Create a `.env` file for foreman and set the following variables.

```
DISABLE_SPRING=true
RAILS_ENV=production
OAUTH_CLIENT_ID=
OAUTH_CLIENT_SECRET=
TWILIO_DEVELOPMENT=
TWILIO_DEVELOPMENT_NUMBER=
TWILIO_TEST=
TWILIO_TEST_NUMBER=
TWILIO_PRODUCTION=
TWILIO_PRODUCTION_NUMBER=
SECRET_KEY_BASE=
```

##Launching

###Web app
`foreman run rails s` starts the web server

###Cron
`sudo service cron restart` restarts cron to pick up changes to the crontab

###Console
`foreman run rails c` starts the rails console

`User.play` manually triggers sending questions (if, say, cron is off)

`User.play true` forces the app to send questions immediately, ingoring the `next_ask` field on the users

##Questions

###Authoring
With ten questions in total, Tink will have enough material for about 2.5 weeks. Questions should all have Yes or No answers and roughly 25% of them should have a high likelihood of matching (to keep both parties engaged).

###Masking
Every time Tink asks a question, it will first ask if it's okay to send the question (to avoid any embarrassing situations). Match responses will be sent without a leading prompt, so be mindful of that when answering "Y" to a question.

##License

Tink is opensource with some rights reserved under the MIT license.