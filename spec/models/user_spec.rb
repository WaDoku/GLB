require 'spec_helper'

describe User do
  let(:editor) { FactoryGirl.create(:editor) }

  before do
    editor
  end
  it "should create a new instance of a user
  given valid attributes" do
    expect(editor).to be_valid
    expect(editor.role).to eq('editor')
  end
  it "is invalid without name" do
    editor.name = nil
    expect(editor).not_to be_valid
  end
  it "is invalid without email" do
    editor.email= nil
    expect(editor).not_to be_valid
  end
  it "is invalid without password" do
    editor.password = nil
    expect(editor).not_to be_valid
  end
end
