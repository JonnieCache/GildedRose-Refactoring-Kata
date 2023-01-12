class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if item.name.end_with? 'Sulfuras, Hand of Ragnaros'
      conjured = item.name.start_with? 'Conjured'

      case item.name
      when /Aged Brie$/ then update_aged_brie(item)
      when /Backstage passes to a TAFKAL80ETC concert$/ then update_backstage(item)
      else update_item(item, conjured)
      end

      item.quality = item.quality.clamp(0..50)
    end
  end

  private

  def decrement_quality(item, conjured)
    item.quality -= conjured ? 2 : 1
  end

  def update_item(item, conjured)
    item.sell_in -= 1

    decrement_quality(item, conjured)
    decrement_quality(item, conjured) if item.sell_in < 0
  end

  def update_aged_brie(item)
    item.sell_in -= 1
    item.quality += 1
  end

  def update_backstage(item)
    item.sell_in -= 1

    case item.sell_in
    when 0..5 then item.quality += 3
    when 6..10 then item.quality += 2
    when -Float::INFINITY..0 then item.quality = 0
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
