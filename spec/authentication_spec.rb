require "json"
RSpec.describe Todoable::Authentication do
  it "sets the token on login" do
    valid_token = "valid_token"
    stub_request(:post, "http://https//todoable.teachable.tech/api/authenticate:80/api/authenticate").
      with(
      headers: {
        "Accept" => "*/*",
        "Authorization" => "Basic dmFsaWRfdXNlcjp2YWxpZF9wYXNz",
      },
    ).
      to_return(status: 200, body: { token: valid_token }.to_json, headers: {})
    username = "valid_user"
    password = "valid_pass"
    t = Todoable::Authentication.new(username, password)
    expect(t.token).to eq(valid_token)
  end

  it "returs a 401 with invalid credetials" do
    stub_request(:post, "http://https//todoable.teachable.tech/api/authenticate:80/api/authenticate").
      with(
      headers: {
        "Accept" => "*/*",
        "Authorization" => "Basic dmFsaWRfdXNlcjppbnZhbGlkX3Bhc3M=",
      },
    ).
      to_return(status: 401, body: {}.to_json, headers: {})
    username = "valid_user"
    password = "invalid_pass"
    expect { Todoable::Authentication.new(username, password) }.to raise_error(AuthenticationError)
  end
end
