# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150117205210) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string "title"
    t.text   "description"
    t.string "slug"
  end

  create_table "exams", force: true do |t|
    t.integer  "quiz_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "student_answers", array: true
  end

  add_index "exams", ["quiz_id"], name: "index_exams_on_quiz_id", using: :btree
  add_index "exams", ["student_id"], name: "index_exams_on_student_id", using: :btree

  create_table "generated_answers", force: true do |t|
    t.integer "question_id"
    t.integer "exam_id"
  end

  add_index "generated_answers", ["exam_id"], name: "index_generated_answers_on_exam_id", using: :btree
  add_index "generated_answers", ["question_id"], name: "index_generated_answers_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer "quiz_id"
    t.text    "content"
    t.integer "value"
  end

  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id", using: :btree

  create_table "quizzes", force: true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "quizzes", ["course_id"], name: "index_quizzes_on_course_id", using: :btree
  add_index "quizzes", ["slug"], name: "index_quizzes_on_slug", using: :btree

  create_table "student_answers", force: true do |t|
    t.integer  "question_id"
    t.integer  "exam_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_answers", ["exam_id"], name: "index_student_answers_on_exam_id", using: :btree
  add_index "student_answers", ["question_id"], name: "index_student_answers_on_question_id", using: :btree

end
