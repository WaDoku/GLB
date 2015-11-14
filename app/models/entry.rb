class Entry < ActiveRecord::Base
  require 'csv'
  has_paper_trail
  belongs_to :user
  has_many :comments
  has_many :entry_docs
  has_many :entry_htmls
  attr_accessible :alternative_japanische_lesungen, :chinesisch, :deutsche_uebersetzung, :eigene_ergaenzungen, :jahreszahlen, :japanische_umschrift, :japanische_umschrift_din, :kanji, :kennzahl, :koreanisch, :lemma_art, :literatur, :literatur_ergaenzungen, :pali, :quellen, :quellen_ergaenzungen, :sanskrit, :schreibvarianten, :spaltenzahl, :tibetisch, :uebersetzung, :namenskuerzel, :weitere_sprachen, :freigeschaltet, :romaji_order

  validates :kennzahl, presence: true, kennzahl: true
  before_save :cleanup

  def self.search(query)
    Entry.where("japanische_umschrift LIKE ? OR kanji LIKE ? OR namenskuerzel = ? OR kennzahl = ? OR romaji_order LIKE ?", "%#{query}%", "%#{query}%", "#{query}", "#{query}", "%#{query}%")
  end
  
  def cleanup
    substituter = Substituter.new
    if self.japanische_umschrift
      self.romaji_order = substituter.substitute(self.japanische_umschrift).downcase
    end
  end

  def self.to_csv
    CSV.generate(:col_sep=>"\t", :quote_char => '"') do |csv|
      csv << column_names
      Entry.find_each(batch_size: 500) do |entry|
        csv << entry.attributes.values_at(*column_names)
      end
    end
  end

end
