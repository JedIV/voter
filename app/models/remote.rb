class Remote
  TITLE = 'BROKER'

  def initialize
    #caps = Selenium::WebDriver::Remote::Capabilities.firefox(proxy: Selenium::WebDriver::Proxy.new(http: "#{proxy}:8080"))
    @driver = Selenium::WebDriver.for :firefox

    wait        = Selenium::WebDriver::Wait.new(:timeout => 20)
    wait.until{ @driver.navigate.to "http://playground.votenow.tv/?initialWidth=1260&childId=web-series" }
    sleep random_seconds
    @driver.manage.window.maximize
    @email = Faker::Name.first_name + Faker::Name.last_name + "@gmail.com"
  end

  
  def find_video
    contestants = @driver.find_elements(:class, 'contestant-view') 
    contestants.each { |contestant| contestant.click if contestant.text == TITLE }
  end

  def random_seconds
    [*1..2].sample
  end

  def enter_email
    wait  = Selenium::WebDriver::Wait.new(:timeout => 20)
    wait2 = Selenium::WebDriver::Wait.new(:timeout => 20)
    wait.until{ @driver.find_element(:class, "text-vote").click }
    wait.until{ @driver.find_element(:css, "div.socialBox:nth-child(2)").click }
    @driver.find_element(:css, "div.checkbox-parent:nth-child(1) > span:nth-child(1)").click
    email_field = @driver.find_element(:id, "email")
    email_field.click
    email_field.send_keys(@email)

    @driver.find_element(:id, "submitEmailAuth").click
    sleep random_seconds

    wait2.until{ @driver.find_element(:class, "btn-close").click }
    sleep random_seconds
  end

  def vote
    wait  = Selenium::WebDriver::Wait.new(:timeout => 20)
    wait2 = Selenium::WebDriver::Wait.new(:timeout => 20)

    sleep random_seconds
    wait.until{ @driver.find_element(:class, "text-vote").click }

    sleep random_seconds
    wait2.until{ @driver.find_element(:class, "btn-close").click }
  end

  def action_loop(vote_count = 0)
    find_video
    enter_email
    9.times do
      vote_count = vote_count + 1
      puts vote_count.to_s + " votes"
      find_video
      vote
    end
    @driver.quit
    vote_count
  end

  def self.do_it_a_lot
    vote_count = 0
    1000.times do
      vote_count = Remote.new.action_loop(vote_count)
    end
  end
end
