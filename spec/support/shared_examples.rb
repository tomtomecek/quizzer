shared_examples "require sign in" do
  it "redirects to root url" do
    clear_current_user
    action
    expect(flash[:danger]).to be_present
    expect(response).to redirect_to root_url
  end
end