# frozen_string_literal: true

require "test_helper"

class Forms::TextFieldComponentTest < ViewComponent::TestCase
  # Model for testing a form object
  class DummyModel
    include ActiveModel::Model
    attr_accessor :name

    validates :name, presence: true
  end

  # Create a fake valid view to create a form builder
  def form_for(model)
    view = ActionView::Base.new(
      ActionController::Base.view_paths,
      {},
      ActionController::Base.new
    )

    ActionView::Helpers::FormBuilder.new(
      :dummy_model,
      model,
      view,
      {}
    )
  end

  test 'renders a text field with base classes' do
    model = DummyModel.new(name: 'Alberto')
    form = form_for(model)

    render_inline(
      Forms::TextFieldComponent.new(
        form_object: form,
        attribute: :name
      )
    )

    assert_selector "input[type='text']"
    assert_selector 'input.w-full'
    assert model.errors.blank?
  end

  test 'renders a text field with error classes' do
    model = DummyModel.new(name: '')
    model.valid?
    form = form_for(model)

    render_inline(
      Forms::TextFieldComponent.new(
        form_object: form,
        attribute: :name
      )
    )

    # Tailwind uses ':' in class names (e.g. focus:ring-red-500). In CSS selectors,
    # ':' has special meaning, so we must escape it to match the literal class.
    assert_selector 'input.border-red-500'
    assert_selector 'input.focus\\:ring-red-500'
    assert_selector 'input.focus\\:border-red-500'
    assert model.errors.present?
    assert_equal "Name can't be blank", model.errors.full_messages.first
  end
end
