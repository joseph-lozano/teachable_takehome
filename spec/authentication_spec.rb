require "json"
RSpec.describe Todoable::Authentication do
  it "sets the token on login" do
    valid_token = "valid_token"
    username = "valid_user"
    password = "valid_pass"
    stub_request(:post, "http://https//todoable.teachable.tech/api/authenticate:80/api/authenticate").
      with(
      basic_auth: [username, password],
      headers: {
        "Accept" => "*/*",
      },
    ).
      to_return(status: 200, body: { token: valid_token }.to_json, headers: {})
    t = Todoable::Authentication.new(username, password)
    expect(t.token).to eq(valid_token)
  end

  it "returs a 401 with invalid credetials" do
    username = "valid_user"
    password = "invalid_pass"
    stub_request(:post, "http://https//todoable.teachable.tech/api/authenticate:80/api/authenticate").
      with(
      basic_auth: [username, password],
      headers: {
        "Accept" => "*/*",
      },
    ).
      to_return(status: 401, body: {}.to_json, headers: {})
    expect { Todoable::Authentication.new(username, password) }.to raise_error(AuthenticationError)
  end
end
