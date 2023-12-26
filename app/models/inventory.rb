class Inventory < ApplicationRecord
  belongs_to :user
  has_many :inventory_foods, dependent: :destroy
  has_many :foods, through: :inventory_foods

  def foods
    InventoryFood.joins(:food).where(inventory_id: id)
      .select('foods.*, inventory_foods.*')
  end
end
