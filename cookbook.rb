require "csv"
require_relative "recipe"


class Cookbook
  attr_reader :recipes

  def initialize(csv_file)
    @recipes = []
    @csv_file = csv_file
    @options = { headers: ["name", "description", "rating", "done", "prep_time"] }
    load_csv
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  def all
    @recipes
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_csv
  end

  def mark_as_done(index)
    @recipes[index].done!
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@csv_file, **@options) do |row|
      @recipes << Recipe.new(
        name: row["name"],
        description: row["description"],
        rating: row["rating"],
        prep_time: row["prep_time"],
        done: row["done"]
      )
    end
  end

  def save_csv
    CSV.open(@csv_file, 'wb', **@options) do |csv|
      @recipes.each { |recipe| csv << [recipe.name, recipe.description, recipe.rating, recipe.done?, recipe.prep_time] }
    end
  end
end
