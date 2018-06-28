defmodule Nyon.Email do
  import Bamboo.Email

  @from "hello@nyon.in"

  def magic_link_mail(email, link_url) do
    new_email()
    |> to(email)
    |> from(@from)
    |> subject("Hello from Nyon")
    |> html_body("<a href='#{link_url}'>Login</a>")
    |> text_body(link_url)
  end
end
