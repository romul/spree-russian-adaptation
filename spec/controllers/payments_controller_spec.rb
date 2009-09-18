require File.dirname(__FILE__) + '/../spec_helper'

describe PaymentsController do

  #Delete these examples and add some real ones
  it "should use PaymentsController" do
    controller.should be_an_instance_of(PaymentsController)
  end


  it "GET 'index' should be successful" do
    get 'index'
    response.should be_success
  end
end
