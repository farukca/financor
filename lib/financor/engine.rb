module Financor
  class Engine < ::Rails::Engine
    isolate_namespace Financor

    config.i18n.default_locale = "en-EN"
    config.i18n.load_path += Dir[config.root.join('locales', '*.{yml}').to_s]

    initializer "financor.action_controller" do |app|
      ActiveSupport.on_load :action_controller do
        helper Financor::BudgetlinesHelper
        helper Financor::InvoicesHelper
        helper Financor::InvolinesHelper
        helper Financor::TaxcodesHelper
      end
    end

    config.generators do |g|
      g.test_framework :mini_test, spec: true, fixture: false
    end
  end
end
