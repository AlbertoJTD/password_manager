# frozen_string_literal: true

class Forms::TextFieldComponent < ViewComponent::Base
  def initialize(form_object:, attribute:, **options)
    super()
    raise ArgumentError, 'form_object must be a form object' unless form_object.is_a?(ActionView::Helpers::FormBuilder)
    raise ArgumentError, 'attribute must be present' if attribute.blank?

    @form_object = form_object
    @attribute = attribute
    @placeholder = options[:placeholder]
    @base_classes = options[:base_classes] || 'w-full px-4 py-2 border rounded-lg transition-colors outline-none'
    @no_error_classes = options[:no_error_classes] || 'border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500'
    @error_classes = options[:error_classes] || 'border-red-500 focus:ring-red-500 focus:border-red-500'
  end

  def input_classes
    class_names(
      @base_classes,
      @no_error_classes => no_errors?,
      @error_classes => any_errors?
    )
  end

  def any_errors?
    @form_object.object.errors[@attribute].any?
  end

  def no_errors?
    !any_errors?
  end
end
