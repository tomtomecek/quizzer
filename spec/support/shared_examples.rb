shared_examples "require sign in" do
  it "redirects to root url" do
    clear_current_user
    action
    expect(flash[:danger]).to be_present
    expect(response).to redirect_to root_url
  end
end

shared_examples "require admin sign in" do
  it "redirects to root url" do
    clear_current_admin
    action
    expect(flash[:danger]).to be_present
    expect(response).to redirect_to root_url
  end
end

shared_examples "require admin sign out" do
  it "redirects to admin courses url" do
    set_current_admin
    action
    expect(flash[:info]).to be_present
    expect(response).to redirect_to admin_courses_url
  end
end

shared_examples "redirect users" do
  it "redirects signed in users to root url" do
    set_current_user
    action
    expect(flash[:info]).to be_present
    expect(response).to redirect_to root_url
  end
end
