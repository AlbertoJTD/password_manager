module ApplicationHelper
  # When the form is sent via POST, we need to convert the path to GET
  # Beacuse `url_for` uses the POST method when there are errors
  # and if you change the locale, it will try to use GET method for a POST/PATCH/PUT path
  # This is a workaround due to a conflict between passwords routes and devise routes
  def locale_switch_path(locale)
    # Handle POST-only paths that need to be converted to GET paths
    # Remove locale prefix if present to match the path
    path_without_locale = request.path.gsub(%r{^/(en|es)/}, '/')

    case path_without_locale
    when %r{/users/password$}
      # Password reset POST path -> convert to GET path
      new_user_password_path(locale: locale)
    else
      # For other paths, use url_for with the new locale
      url_for(locale: locale)
    end
  end
end
