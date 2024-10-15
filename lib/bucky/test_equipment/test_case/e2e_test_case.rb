# frozen_string_literal: true

require 'selenium-webdriver'
require_relative './abst_test_case'
require_relative '../user_operation/user_operator'
require_relative '../pageobject/pages'
require_relative '../selenium_handler/webdriver_handler'
require_relative '../verifications/service_verifications'

module Bucky
  module TestEquipment
    module TestCase
      class E2eTestCase < Bucky::TestEquipment::TestCase::AbstTestCase
        include Bucky::TestEquipment::SeleniumHandler::WebdriverHandler

        TEST_CATEGORY = 'e2e'

        class << self
          def startup; end

          def shutdown; end
        end

        # Initialize the following class
        #   - webdriver
        #   - page object
        #   - user oparation
        #   - verification
        # @param [Hash] suite
        def t_equip_setup
          @driver = create_webdriver(suite_data[:device])
# "driver: "
          @pages = Bucky::TestEquipment::PageObject::Pages.new(suite_data[:service], suite_data[:device], @driver)
          service_verifications_args = { service: suite_data[:service], device: suite_data[:device], driver: @driver, pages: @pages, method_name: method_name }
          @service_verifications = Bucky::TestEquipment::Verifications::ServiceVerifications.new(service_verifications_args)

# "user_operator_argsの中身は
# {:app=>\"service_a\", :device=>\"pc\", :driver=>nil,
#:pages=>#<Bucky::TestEquipment::PageObject::Pages:0x0000ffff99f64070>}"
          user_operator_args = { app: suite_data[:service], device: suite_data[:device], driver: @driver, pages: @pages }
# "user_operator_args: {:app=>\"service_a\", :device=>\"pc\", :driver=>nil, :pages=>#<Bucky::TestEquipment::PageObject::Pages:0x0000ffff7e824988>}"

# "@user_operator: #<Bucky::TestEquipment::UserOperation::UserOperator:0x0000ffffac4f51d0 @operation_helper=#<Bucky::TestEquipment::UserOperation::UserOperationHelper:0x0000ffffac39b050 @app=\"service_a\", @device=\"pc\", @driver=nil, @pages=#<Bucky::TestEquipment::PageObject::Pages:0x0000ffffac4549d8>>, @pages=#<Bucky::TestEquipment::PageObject::Pages:0x0000ffffac4549d8>>"
          @user_operator = Bucky::TestEquipment::UserOperation::UserOperator.new(user_operator_args)
        end

        # Call mothod of verification
        # @param [Hash] verify_args e.g.) {:exec=>{verify: "assert_title", expect: "page title"}, :step_number=> 1, :proc_name=> "test proc"}
        def verify(**verify_args)
          p "verify_argsは#{verify_args}"
          @service_verifications.send(verify_args[:exec][:verify], **verify_args)
        end

        # Call method of user operation
        # @param [Hash] op_args e.g.) {:exec=>{:operate=>"click", :page=>"top_page", :part=>"fizz_button"}, :step_number=> 1, :proc_name=> "test proc"}
        def operate(**op_args)
# "op_argsは {:exec=>{:operate=>\"go\", :url=>\"http://bucky.net\"}, :step_number=>1, :proc_name=>\"open index\"}"
          @user_operator.send(op_args[:exec][:operate], method_name, **op_args)
        end

        def setup
          super
          t_equip_setup
        end

        def teardown
          p "@driver: #{@driver}"
          @driver.quit
        ensure
          super
        end
      end
    end
  end
end
