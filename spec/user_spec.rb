require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    User.new(first_name: "John",
    last_name: "Smith",
    email: "test@test.com",
    password: '1234567', password_confirmation: '1234567')
  }

  describe 'Validations' do

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it "is not valid if password and password_confirmation does not match" do
      subject.password = "1234567"
      expect(subject).to be_valid
    end

    it "is not valid if the password is too short" do
      subject.password = "123"
      subject.password_confirmation ="123"
      expect(subject).to_not be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if email already exists" do
      User.create(first_name: "John",  last_name: "Smith", email: "test@test.com", password: "1234567", password_confirmation: "1234567")
      expect(subject).to_not be_valid
    end

    it "is not valid if email is not unique without caplocks" do
      User.create(first_name: "John", last_name: "Smith", email: "test@test.Com", password: "1234567", password_confirmation: "1234567")

      expect(subject).to_not be_valid
    end

    it "is not valid without a first name" do
      subject.first_name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a last name" do
      subject.last_name = nil
      expect(subject).to_not be_valid
    end
  end

  describe '.authenticate_with_credentials' do

    it 'should match password and email' do
      user = User.create(first_name: 'John', last_name: 'Smith',
        email: 'test@test.com', password: '1234567',
        password_confirmation: '1234567')

      session = User.authenticate_with_credentials('test@test.com', '1234567')

      expect(session).to eq user
    end

    it 'should match when there is a space in front of email' do
      user = User.create(first_name: 'Smith', last_name: 'John',
        email: 'test@test.com', password: '1234567',
        password_confirmation: '1234567')

      session = User.authenticate_with_credentials(' test@test.com', '1234567')
      expect(session).to eq user
    end

    it 'should match when there is a space at the end of the email' do
      user = User.create(first_name: 'Smith', last_name: 'John',
        email: 'test@test.com', password: '1234567',
        password_confirmation: '1234567')

      session = User.authenticate_with_credentials('test@test.com ', '1234567')
      expect(session).to eq user
    end

    it 'should match when user types wrong cases' do
      @user = User.create(first_name: 'Smith', last_name: 'John',
        email: 'test@test.com', password: '1234567',
        password_confirmation: '1234567')

      session = User.authenticate_with_credentials('TEST@test.com ', '1234567')
      expect(session).to eq @user
    end
  end
end