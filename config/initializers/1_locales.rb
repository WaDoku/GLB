require 'i18n'
require "i18n/backend/fallbacks"
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

I18n.available_locales = [:en, :de, :jp]
I18n.default_locale = :de
