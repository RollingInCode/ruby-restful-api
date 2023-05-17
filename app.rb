require 'grape'
require 'grape-entity'
require 'json'

# Entity representing a User
class UserEntity < Grape::Entity
  expose :id
  expose :name
  expose :email
end

# User class with sample data
class User
  attr_accessor :id, :name, :email

  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end
end

# Sample data
users = [
  User.new(1, 'John Doe', 'john@example.com'),
  User.new(2, 'Jane Smith', 'jane@example.com')
]

class API < Grape::API
  format :json
  prefix :api

  resource :users do
    desc 'Get all users'
    get do
      present users, with: UserEntity
    end

    desc 'Get a user by ID'
    route_param :id do
      get do
        user = users.find { |u| u.id == params[:id].to_i }
        if user
          present user, with: UserEntity
        else
          error!('User not found', 404)
        end
      end
    end

    desc 'Create a new user'
    params do
      requires :name, type: String
      requires :email, type: String
    end
    post do
      new_id = users.map(&:id).max + 1
      user = User.new(new_id, params[:name], params[:email])
      users << user
      present user, with: UserEntity
    end
  end
end

