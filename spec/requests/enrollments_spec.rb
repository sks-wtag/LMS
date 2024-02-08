require 'rails_helper'

RSpec.describe "Enrollments", type: :request do
  let!(:organization) { create(:organization, name: "Welldev") }
  let!(:admin) { create(:user, organization: organization, role: "admin") }
  let!(:instructor) { create(:user, organization: organization, role: "instructor") }
  let!(:learner) { create(:user, organization: organization, role: "learner") }
  let!(:course) { create(:course) }
  let!(:enrollment) { create(:enrollment, enrollment_type: "learner", user_id: learner.id, course_id: course.id) }
  let!(:lesson) { create(:lesson, course_id: course.id) }

  describe "GET /Dashboard/enroll_course/:course_id" do
    it "when it created a valid params as an instructor" do
      login(instructor)
      get "/dashboard/enroll_course/#{course.id}"
      expect(assigns(:users)).to match_array([admin, instructor, learner])
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
    it "When it crated a valid request as an instructor" do
      login(instructor)
      expect do
        delete "/dashboard/dis_enroll_course/#{course.id}"
      end.to change(Enrollment, :count).by(1)
    end
  end

  def login(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end
end
