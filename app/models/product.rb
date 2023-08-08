# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  title      :string
#  code       :string
#  stock      :integer          default(0)
#  price      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord

    before_save :validate_product
    after_save :send_notification
    after_save :push_notification, if: :discount?

    validates :title, presence: { message: 'Es necesario definir un valor para el titulo' }
    validates :code, presence: { message: 'Es necesario definir un valor para el codigo' }

    validates :code, uniqueness: { message: 'El codigo ya se encuentra en uso' }
    
    validates :price, length: { minimum: 3, maximun: 10 }, if: :has_price?

    validates_with ProductValidator

  def total
   self.price / 100
  end

  def discount?
    self.total < 5
  end

  def has_price?
    !self.price.nil? && self.price > 0
  end



  def validate_product
   puts "\n\n>>> Un nuevo producto será añadido a almacen"
  end

  def send_notification
    puts "\n\n>>> Un nuevo producto fue añadido a almacen: #{self.title} - #{self.total} USD"
  end

  def push_notification
        puts "\n\n>>> Un nuevo producto en descuento ya se encuentra disponible: #{self.title} - #{self.total} USD"
  end

end
