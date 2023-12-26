class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_foods, dependent: :destroy

  def foods
    RecipeFood.joins(:food).where(recipe_id: id)
      .select('foods.*, recipe_foods.*')
  end

  def toggle_public
    update(public: !public)
  end
end
