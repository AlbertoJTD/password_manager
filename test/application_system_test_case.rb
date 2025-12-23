require "test_helper"

Capybara.register_driver :chrome_no_alerts do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--incognito')
  options.add_argument('--disable-features=PasswordLeakDetection,PasswordManager')

  # # Disable password leak detection and password manager features
  # options.add_argument('--disable-features=PasswordLeakDetection,PasswordManagerOnboarding')
  # options.add_argument('--disable-password-manager-reauthentication')
  # options.add_argument('--disable-save-password-bubble')
  # options.add_argument('--disable-infobars')
  # options.add_argument('--disable-background-networking') # Prevents leak checks
  # options.add_argument('--disable-sync') # Prevents syncing which can trigger leak checks
  # options.add_argument('--disable-default-apps')
  # options.add_argument('--no-first-run')
  # options.add_argument('--no-default-browser-check')
  # options.add_argument('--disable-extensions')
  # options.add_argument('--disable-popup-blocking')
  # options.add_argument('--disable-translate')
  # options.add_argument('--disable-background-timer-throttling')
  # options.add_argument('--disable-renderer-backgrounding')
  # options.add_argument('--disable-backgrounding-occluded-windows')
  # options.add_argument('--disable-component-update')
  # options.add_argument('--disable-domain-reliability')
  # options.add_argument('--disable-features=TranslateUI')
  # options.add_argument('--disable-ipc-flooding-protection')
  # options.add_argument('--disable-hang-monitor')
  # options.add_argument('--disable-prompt-on-repost')
  # options.add_argument('--disable-client-side-phishing-detection') # Disable phishing detection which includes password checks

  # # Disable password manager and leak detection via preferences
  # options.add_preference('credentials_enable_service', false)
  # options.add_preference('profile.password_manager_enabled', false)
  # options.add_preference('profile.default_content_setting_values.notifications', 2)
  # options.add_preference('credentials_enable_autosignin', false)
  # options.add_preference('password_manager.allow_show_passwords', false)

  # # Additional preferences to disable password leak detection
  # options.add_preference('profile.managed_default_content_settings.notifications', 2)
  # options.add_preference('profile.content_settings.exceptions.notifications', {})
  # options.add_preference('profile.default_content_setting_values.automatic_downloads', 1)

  # # Disable Safe Browsing which includes password leak detection
  # options.add_preference('safebrowsing.enabled', false)
  # options.add_preference('safebrowsing.malware.enabled', false)
  # options.add_preference('safebrowsing.phishing.enabled', false)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :chrome_no_alerts, screen_size: [1400, 1400]
end
