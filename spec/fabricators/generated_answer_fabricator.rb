Fabricator(:generated_answer) do
  answer
  content { |attrs| attrs[:answer].content }
  correct { |attrs| attrs[:answer].correct }
end

Fabricator(:gen_answer, from: :generated_answer) do
end

Fabricator(:gen_correct, from: :generated_answer) do
  correct { true }
end

Fabricator(:gen_incorrect, from: :generated_answer) do
  correct { false }
end
