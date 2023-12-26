# app/services/shopping_list_generator.rb

class ShoppingListGenerator
  def self.generate_shopping_list(inventory_id, recipe_id)
    RecipeFood.left_outer_joins(food: :inventory_foods).where(recipe_id:)
      .where.not(
        food_id: InventoryFood.select(:food_id)
                              .where(inventory_id:)
      )
      .or(
        RecipeFood.where.not(
          id: RecipeFood.joins(food: :inventory_foods)
                        .where('inventory_id = ? AND foods.id = recipe_foods.food_id', inventory_id)
                        .where('inventory_foods.quantity >= recipe_foods.quantity')
                        .pluck(:id)
        )
      )
      .select('CASE WHEN inventory_foods.quantity < recipe_foods.quantity
                          THEN recipe_foods.quantity - inventory_foods.quantity
                                   ELSE recipe_foods.quantity END AS quantity',
              'foods.name',
              'foods.id AS food_id',
              'foods.price',
              'foods.measurement_unit')

    # RecipeFood.left_outer_joins(food: :inventory_foods)
    #   .where('inventory_foods.inventory_id != ?
    #     OR inventory_foods.quantity < recipe_foods.quantity', inventory_id)
    #   .where(recipe_id: recipe_id)
    # .select(
    #   'CASE WHEN inventory_foods.quantity < recipe_foods.quantity
    #   THEN recipe_foods.quantity - inventory_foods.quantity
    #   ELSE recipe_foods.quantity END AS quantity',
    #   'foods.name',
    #   'foods.id AS food_id',
    #   'foods.price',
    #   'foods.measurement_unit'
    # )
    #   .order('foods.name')
    #   .includes(food: :inventory_foods)
  end
end
