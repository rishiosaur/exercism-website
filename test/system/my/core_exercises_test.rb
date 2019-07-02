require 'application_system_test_case'

class My::CoreExercisesTest < ApplicationSystemTestCase
  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    Git::ExercismRepo.stubs(pages: [])

    @user = create(:user, :onboarded)
    @track = create :track
    @exercise = create :exercise, track: @track, core: true
    @solution = create :solution, exercise: @exercise, user: @user

    create :user_track, user: @user, track: @track, independent_mode: false
    sign_in!(@user)
  end

  test "completed" do
    @solution.update(completed_at: Time.current, approved_by: create(:user))

    visit my_track_path(@track)
    assert_selector ".core-exercises .exercise-wrapper.completed .status", text: "COMPLETED"
  end

  test "completed but independent" do
    @solution.update(completed_at: Time.current)

    visit my_track_path(@track)
    assert_selector ".core-exercises .exercise-wrapper.completed .status", text: "COMPLETED\nUNMENTORED"
  end

  test "approved" do
    @solution.update(approved_by: create(:user))

    visit my_track_path(@track)
    assert_selector ".core-exercises .exercise-wrapper.in-progress .status", text: "APPROVED"
  end
end
