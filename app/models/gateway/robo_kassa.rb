class Gateway::RoboKassa < Gateway
  preference :login, :string
  preference :password1, :password  
  preference :password2, :password
  
  def provider_class
    ActiveMerchant::Billing::RoboKassaGateway
  end 
  
end
