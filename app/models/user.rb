class User < ApplicationRecord
  has_many :answers

  FRIENDLY_REPLIES = ["That's good to know!",
                      "Cool, thanks for sharing.",
                      "Hey, thanks for playing!",
                      "They say knowing is half the battle.",
                      "So glad you shared that with me, thanks!",
                      "I'm flattered that you shared that with me. Thanks.",
                      "Thanks for your message. From where I sit, you look dashing today.",
                      "Now I can get to know you and you can get to know me. Fun, right?"].freeze

  def pending_answers
    answers.where('yes is null').order('updated_at desc')
  end

  def ask_question(answer)
    unless answer.yes.present?
      if answer.accepted?
        self.notify("✧ Tink would like to know: #{answer.question.text} Reply Y or N ✧", false)
      else
        self.notify("✧ I have a new message for you! Reply Y if you want to see it ✧", false)
      end
      return answer
    end
    nil
  end

  def answer_question(response_body)
    #make sure we understand the reply
    reply = case response_body.strip
    when *['Y', 'y', 'YES', 'yes', 'Yes', true, 1, '1', 't', 'T', 'true', 'TRUE']
      true
    when *['N', 'n', 'NO', 'no', 'No', false, 0, '0', 'f', 'F', 'false', 'FALSE']
      false
    else
      self.notify("Sorry, I'm not smart enough to handle anything other than yes/no answers (for now).", [true,false].sample)
      return nil
    end

    #ignore input if it doesn't match up with a pending question
    User.transaction do
      answer = self.pending_answers.first
      unless answer.present?
        self.notify('Thanks! I like you.', true)
        return nil
      end

      #the actions happening last in the answer-processing flow are coded first (to avoid `unless...`)
      if answer.yes.present?
        #ignore input; this answer has already been fully processed
        self.notify("Thanks! You're the best.", true)
      else #the question has not been answered yet
        if answer.accepted?
          #user has already accepted the question; now it's time to save the answer
          answer.yes = reply
          answer.save!
          self.notify FRIENDLY_REPLIES.sample, [true, false].sample
          Answer.match(answer) if answer.yes
        else
          #user was replying-Y to accept the question
          if reply
            answer.update_attribute(:accepted, true)
            answer.reload
            self.ask_question(answer)
          end
        end
      end
      answer
    end
  end

  def notify_of_match(answer)
    unless answer.matched?
      self.notify("✧ Tink found a match! ❥ #{answer.user.name} ❥ also answered yes to: '#{answer.question.text}'", true)
    end
  end

  def notify(message_body, love=true)
    Rails.application.config.twilio_client.account.messages.create({
      :to => self.mobile,
      :from => Rails.application.config.twilio_number,
      :body => love ? "#{message_body} ❥Tink" : message_body
    })
    logger.info "To #{self.name}: #{message_body}"
  end

  def self.play(force = false)
    User.where('mobile is not null').each do |user|
      if force || (!user.next_ask.present? || user.next_ask <= Time.now)
        Question.ask(user.id)
        user.update_attribute(:next_ask,
          (Time.zone.today + [*1..3].sample.days).to_time.change({ hour: [*16..23].sample, min: [*1..59].sample }))
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider ||= auth.provider
      user.uid ||= auth.uid
      user.name ||= auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end