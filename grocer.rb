def find_item_by_name_in_collection(name, collection)
  collection.count.times do |index|
    return collection[index] if collection[index][:item] === name
  end
  nil
end

def consolidate_cart(cart)
  consolidated = []
  
  cart.count.times do |index|
    new_item = cart[index]
    item_in_cart = find_item_by_name_in_collection(new_item[:item], consolidated)
    if item_in_cart
      item_in_cart[:count] += 1
    else
      new_item[:count] = 1
      consolidated << new_item
    end
  end
  consolidated
end

def create_couponed_item(coupon, item)
  {
    item: "#{item[:item]} W/COUPON",
    price: coupon[:cost] / coupon[:num],
    clearance: item[:clearance],
    count: coupon[:num]
  }
end

def apply_coupons(cart, coupons)
  coupons.count.times do |index|
    coupon = coupons[index]
    item_in_cart = find_item_by_name_in_collection(coupon[:item], cart)
    if item_in_cart && item_in_cart[:count] >= coupon[:num]
      cart << create_couponed_item(coupon, item_in_cart)
      item_in_cart[:count] -= coupon[:num]
    end
  end
  cart
end

def discount(price)
  (price * 0.8).round(2)
end

def apply_clearance(cart)
  cart.count.times do |index|
    item = cart[index]
    item[:price] = discount(item[:price]) if item[:clearance]
  end
  cart
end

def apply_discount(total)
  discount_threshold = 100
  discount_factor = 0.9
  total > discount_threshold ? total * discount_factor : total
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  result = 0
  cart.count.times do |index|
    item = cart[index]
    result += (item[:price] * item[:count])
  end
  result = apply_discount(result)
end
