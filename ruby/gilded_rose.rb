class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if item.name.end_with? 'Sulfuras, Hand of Ragnaros'
      
      item.sell_in -= 1
      
      case item.name
      when /Aged Brie$/ then update_aged_brie(item)
      when /Backstage passes to a TAFKAL80ETC concert$/ then update_backstage(item)
      else update_item(item)
      end

      item.quality = item.quality.clamp(0..50)
    end
  end

  private

  def update_item(item)
    decrement = item.name.start_with?('Conjured') ? 2 : 1
    item.quality -= decrement
    item.quality -= decrement if item.sell_in < 0
  end

  def update_aged_brie(item)
    item.quality += 1
  end

  def update_backstage(item)
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
