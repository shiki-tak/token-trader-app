class HashedusersController < ApplicationController
  require 'digest/sha3'
  require "#{Dir.pwd}/app/models/EthereumAPI.rb"

  # Make hashed account from username and password
  def createhasheduser(username, password)
    @hasheduser = Hasheduser.new
    smartContract = EthereumAPI.new()
    hash = Digest::SHA3.new
    hash.update(username)
    @hasheduser.hashed_username = hash.update(password).to_s
    @hasheduser.ether_account = smartContract.createGethAccount(password)
    if @hasheduser.save
      puts "Success create hashed user account"
      puts "Hashed username result: #{@hasheduser.hashed_username}"
      puts "Ether Account: #{@hasheduser.ether_account}"
    else
      # TODO: Processing when an error occurs
    end
  end
end
