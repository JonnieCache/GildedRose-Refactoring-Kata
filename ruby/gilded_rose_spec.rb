require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe '#update_quality' do
    let(:rose) { GildedRose.new([item]) }
  
    context 'with a basic item' do
      let(:sell_in) { 10 }
      let(:quality) { 5 }
      let(:name)    { 'foo' }
      let(:item) {Item.new(name, sell_in, quality)}

      it 'decrements quality' do
        expect { rose.update_quality }.to change { item.quality }.from(5).to(4)
      end

      it 'decrements sell_in' do
        expect { rose.update_quality }.to change { item.sell_in }.from(10).to(9)
      end

      context 'sell by date passed' do
        let(:sell_in) { -1 }

        it 'decrements quality by 2' do
          expect { rose.update_quality }.to change { item.quality }.from(5).to(3)
        end
      end

      context 'with quality 0' do
        let(:quality) { 0 }

        it 'doesnt change quality' do
          expect { rose.update_quality }.not_to change { item.quality }
        end
      end

      describe 'Aged Brie' do
        let(:name) { 'Aged Brie' }

        it 'increments quality' do
          expect { rose.update_quality }.to change { item.quality }.from(5).to(6)
        end

        context 'with quality 50' do
          let(:quality) { 50 }

          it 'doesnt change quality' do
            expect { rose.update_quality }.not_to change { item.quality }
          end
        end
      end

      describe 'Sulfuras, Hand of Ragnaros' do
        let(:name) { 'Sulfuras, Hand of Ragnaros' }
        
        it 'doesnt change quality' do
          expect { rose.update_quality }.not_to change { item.quality }
        end

        it 'doesnt change sell_in' do
          expect { rose.update_quality }.not_to change { item.sell_in }
        end

      end

      describe 'Backstage passes to a TAFKAL80ETC concert' do
        let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }

        context 'less than 10 days to go' do
          let(:sell_in) { 7 }

          it 'increments quality by 2' do
            expect { rose.update_quality }.to change { item.quality }.from(5).to(7)
          end
        end

        context 'less than 5 days to go' do
          let(:sell_in) { 4 }

          it 'increments quality by 3' do
            expect { rose.update_quality }.to change { item.quality }.from(5).to(8)
          end
        end

        context 'less than 0 days to go' do
          let(:sell_in) { -1 }

          it 'sets quality to 0' do
            expect { rose.update_quality }.to change { item.quality }.from(5).to(0)
          end
        end
      end
    end

  end

end
