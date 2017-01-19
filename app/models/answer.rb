class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  def self.match(answer)
    Answer.transaction do
      user = answer.user
      matching_answer = where(["question_id = ? and yes = 1 and user_id <> ?", answer.question_id, user.id]).order('updated_at desc').first
      if matching_answer.present?
        matching_answer.user.notify_of_match(answer)
        answer.update_attribute(:matched, true)
        sleep([*3..7].sample) #prevent race condition wherein match notification arrives before thank you
        user.notify_of_match(matching_answer)
        matching_answer.update_attribute(:matched, true)
      end
    end
  end
end