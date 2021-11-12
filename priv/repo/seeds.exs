# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ConduitElixir.Repo.insert!(%ConduitElixir.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ConduitElixir.Repo
alias ConduitElixir.Articles.Article
alias ConduitElixir.Favorites.ArticleFavorite
alias ConduitElixir.Tags.ArticleTag
alias ConduitElixir.Tags.Tag
alias ConduitElixir.Auth.User

# Clear the database 

Repo.delete_all(ArticleFavorite)
Repo.delete_all(ArticleTag)
Repo.delete_all(Article)
Repo.delete_all(User)
Repo.delete_all(Tag)

# Enter data

user1_attrs = %{
  email: "ali@test.com",
  username: "aa87",
  password: "abcd1234"
}

user2_attrs = %{
  email: "sam@test.com",
  username: "sam87",
  password: "abcd1234"
}

{:ok, user1} = ConduitElixir.Auth.register_user(user1_attrs)
{:ok, user2} = ConduitElixir.Auth.register_user(user2_attrs)

article1_attr = %{
  "tagList" => ["tag1", "tag2"],
  "title" => "Article 1",
  "body" => "Body 1",
  "description" => "Description 1"
}

article2_attr = %{
  "tagList" => ["tag1", "tag2"],
  "title" => "Article 2",
  "body" => "Body 2",
  "description" => "Description 2"
}

article3_attr = %{
  "tagList" => ["tag3", "tag4"],
  "title" => "Article 3",
  "body" => "Body 3",
  "description" => "Description 3"
}

article4_attr = %{
  "tagList" => ["tag3", "tag4"],
  "title" => "Article 4",
  "body" => "Body 4",
  "description" => "Description 4"
}

{:ok, article1} = ConduitElixir.Articles.create_article(article1_attr, user1)
{:ok, article2} = ConduitElixir.Articles.create_article(article2_attr, user1)
{:ok, article3} = ConduitElixir.Articles.create_article(article3_attr, user2)
{:ok, article4} = ConduitElixir.Articles.create_article(article4_attr, user2)

ConduitElixir.Articles.favorite_article(user2.id, article1.slug)
ConduitElixir.Articles.favorite_article(user2.id, article2.slug)
ConduitElixir.Articles.favorite_article(user1.id, article3.slug)
ConduitElixir.Articles.favorite_article(user1.id, article4.slug)
