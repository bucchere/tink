class Question < ApplicationRecord
  has_many :answers

  def self.unasked(user_id)
    where("id in (?)", all.map(&:id) - Answer.where(user_id: user_id).map(&:question_id))
  end

  def self.ask(user_id)
    unasked_questions = self.unasked(user_id)
    unasked_questions.size > 0 ? unasked_questions.sample.ask(user_id) : nil
  end

  def ask(user_id)
    Question.transaction do
      answer = Answer.create(user_id: user_id, question_id: self.id)
      User.find(user_id).ask_question(answer)
    end
  end

  def answer(user_id, yes=nil)
    Question.transaction do
      answer = Answer.find_or_create_by(user_id: user_id, question_id: self.id)
      answer.yes = yes
      answer.save!
      answer
    end
  end
end