require 'rails_helper'

RSpec.describe "Enrollments", type: :request do
  let!(:organization) { create(:organization, name: "Welldev") }
  let!(:admin) { create(:user, organization: organization, role: "admin") }
  let!(:instructor) { create(:user, organization: organization, role: "instructor") }
  let!(:learner) { create(:user, organization: organization, role: "learner") }
  let!(:learner_1) { create(:user, organization: organization, role: "learner") }
  let!(:course) { create(:course) }
  let!(:course_1) { create(:course) }
  let!(:enrollment) { create(:enrollment, enrollment_type: "instructor", user_id: instructor.id, course_id: course.id) }
  let!(:enroll_as_learner) { create(:enrollment, enrollment_type: "learner", user_id: learner.id, course_id: course.id) }
  let!(:lesson) { create(:lesson, course_id: course.id) }

  describe "GET /Dashboard/enroll_course/:course_id" do
    it "when it created a valid params as an instructor" do
      login(instructor)
      get "/dashboard/enroll_course/#{course.id}"
      expect(assigns(:users)).to match_array([admin, instructor, learner,learner_1])
    end

    it "when it created a invalid params as an admin" do
      login(admin)
      get "/dashboard/enroll_course/#{234234}"
      expect(flash[:notice]).to eq("Invalid params")
      expect(response).to redirect_to "/dashboard/show_course"
    end
  end

  describe "POST /dashboard/enroll_course/:course_id" do
    it "When it crated a valid request as an admin" do
      login(admin)
      expect do
        post "/dashboard/enroll_course/#{course.id}", params:
          {
            completion_time: DateTime.now + 7.day,
            user_id: admin.id
          }
      end.to change(Enrollment, :count).by(1)
      expect(flash[:notice]).to eq("Enrolled successfully")
    end

    it "When it crated a valid request as an admin but completion time is less then the current date" do
      login(admin)
      post "/dashboard/enroll_course/#{course.id}", params:
        {
          completion_time: DateTime.now - 7.day,
          user_id: admin.id
        }
      expect(flash[:notice]).to eq(["can't be set past date"])
      expect(response).to redirect_to "/dashboard/enroll_course/#{course.id}"
    end
  end

  describe "DELETE /dashboard/dis_enroll_course/:course_id" do
    it "When it creates a valid request as an admin to dis_enroll an instructor" do
      login(admin)
      expect do
        delete "/dashboard/dis_enroll_course/#{course.id}",
               params:
                 {
                   user_id: instructor.id
                 }
      end.to change(Enrollment, :count).by(0)
      expect(flash[:notice]).to eq("He/She is the owner of this course.")
      expect(response).to redirect_to "/dashboard/enroll_course/#{course.id}"
    end

    it "When it creates a valid request as an instructor to dis_enroll an incomplete learner" do
      login(instructor)
      expect do
        delete "/dashboard/dis_enroll_course/#{course.id}",
               params:
                 {
                   user_id: learner.id
                 }
      end.to change(Enrollment, :count).by(-1)
      expect(flash[:notice]).to eq("Successfully dis-enroll.")
      expect(response).to redirect_to "/dashboard/enroll_course/#{course.id}"
    end

    it "When it creates a valid request as an instructor to dis_enroll a completed course" do
      login(instructor)
      FactoryBot.create(:user_course_progress, user_id: learner.id, lesson_id: lesson.id, enrollment_id:enroll_as_learner.id)
      expect do
        delete "/dashboard/dis_enroll_course/#{course.id}",
               params:
                 {
                   user_id: learner.id
                 }
      end.to change(Enrollment, :count).by(0)
      expect(flash[:notice]).to eq("This course has already been completed.")
      expect(response).to redirect_to "/dashboard/enroll_course/#{course.id}"
    end

    it "When it creates a valid request for an instructor to disenroll a user who has not enrolled yet" do
      login(instructor)
      expect do
        delete "/dashboard/dis_enroll_course/#{course.id}",
               params:
                 {
                   user_id: learner_1.id
                 }
      end.to change(Enrollment, :count).by(0)
      expect(flash[:notice]).to eq("This course has not already been enrolled in by this user.")
    end
  end

  describe "POST /dashboard/complete_lesson/:lesson_id" do
    it "When it creates a valid request as an learner to complete a lesson" do
      login(learner)
      expect do
        post "/dashboard/complete_lesson/#{lesson.id}",
             params:
               {
                 enrollment_id: enroll_as_learner.id
               }
      end.to change(UserCourseProgress, :count).by(1)
      expect(flash[:notice]).to eq("Thanks for completing this lesson!")
      expect(response).to redirect_to "/dashboard/show_a_course/#{lesson.course_id}"
    end
  end
  def login(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end
end
