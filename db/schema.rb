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

ActiveRecord::Schema.define(version: 20150225135849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_expires_at"
    t.string   "remember_digest"
    t.boolean  "activated",                 default: false
    t.string   "activation_token"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificates", force: true do |t|
    t.integer  "student_id"
    t.integer  "enrollment_id"
    t.string   "licence_number"
    t.datetime "expires_at"
    t.boolean  "distinction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string "title"
    t.text   "description"
    t.string "slug"
  end

  create_table "enrollments", force: true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.boolean  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed",  default: false
  end

  create_table "exams", force: true do |t|
    t.integer  "quiz_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",        default: "in progress"
    t.integer  "score"
    t.integer  "enrollment_id"
    t.boolean  "passed"
  end

  add_index "exams", ["enrollment_id"], name: "index_exams_on_enrollment_id", using: :btree
  add_index "exams", ["quiz_id"], name: "index_exams_on_quiz_id", using: :btree
  add_index "exams", ["student_id"], name: "index_exams_on_student_id", using: :btree

  create_table "generated_answers", force: true do |t|
    t.integer  "generated_question_id"
    t.text     "content"
    t.boolean  "correct"
    t.boolean  "student_marked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "answer_id"
  end

  add_index "generated_answers", ["answer_id"], name: "index_generated_answers_on_answer_id", using: :btree
  add_index "generated_answers", ["generated_question_id"], name: "index_generated_answers_on_generated_question_id", using: :btree

  create_table "generated_questions", force: true do |t|
    t.integer  "question_id"
    t.integer  "exam_id"
    t.text     "content"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "generated_questions", ["exam_id"], name: "index_generated_questions_on_exam_id", using: :btree
  add_index "generated_questions", ["question_id"], name: "index_generated_questions_on_question_id", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "enrollment_id"
    t.integer  "quiz_id"
    t.integer  "student_id"
    t.integer  "attempt"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["enrollment_id"], name: "index_permissions_on_enrollment_id", using: :btree
  add_index "permissions", ["quiz_id"], name: "index_permissions_on_quiz_id", using: :btree
  add_index "permissions", ["student_id"], name: "index_permissions_on_student_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "quiz_id"
    t.text     "content"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id", using: :btree

  create_table "quizzes", force: true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "published",          default: false
    t.integer  "passing_percentage"
    t.integer  "position"
  end

  add_index "quizzes", ["course_id"], name: "index_quizzes_on_course_id", using: :btree
  add_index "quizzes", ["slug"], name: "index_quizzes_on_slug", using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "email"
    t.string   "name"
    t.string   "avatar_url"
    t.string   "github_account_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
