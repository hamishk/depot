require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end 

  test "product price must be positive" do
    product = Product.new(title:        "My book title:",
                          description:  "yyy",
                          image_url:    "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal product.errors[:price], ["must be greater than or equal to 0.01"]

    product.price = 0
    assert product.invalid?
    assert_equal product.errors[:price], ["must be greater than or equal to 0.01"]

    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(title:        "My Dogs are Great",
                description:  "I have all the best dogs",
                price:        1,
                image_url:    image_url)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gid.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title:           products(:book_about_dogs).title,
                          description:     "yyy",
                          price:           1,
                          image_url:       "dogssss.jpg")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(title:           products(:book_about_dogs).title,
                          description:     "yyy",
                          price:           1,
                          image_url:       "dogssss.jpg")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                  product.errors[:title]
  end

  test "product is not valid with short title" do
    product = products(:title_too_short)
    assert product.invalid?
    assert_equal ["title too short"], product.errors[:title]
  end
end
