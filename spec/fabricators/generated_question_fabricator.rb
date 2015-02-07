Fabricator(:generated_question) do
  question  
  content { |attrs| attrs[:question].content }
  points { |attrs| attrs[:question].points }
end

Fabricator(:gen_question, from: :generated_question) do
end
