# namenskuerzel  # Short name version
# kennzahl  # Index number
# spaltenzahl  # Number of columns
# japanische_umschrift  # Japanese transliteration
# kanji  # Current word dictionary form
# pali  # Pali Transliteration
# sanskrit  # Sanscrit Transliteration
# chinesisch  # Chinese Transliteration
# tibetisch
# koreanisch
# weitere_sprachen  # Other languages
# alternative_japanische_lesungen  # Alternative Japanese Readings
# schreibvarianten  # Spellings variations
# deutsche_uebersetzung  # German Translations
# lemma_art  # Dictionary Entry Type
# jahreszahlen  # Date
# uebersetzung  # Translation
# quellen  # Sources
# literatur  # Literature
# eigene_ergaenzungen  # Own Additions
# quellen_ergaenzungen  # Additions from sources
# literatur_ergaenzungen  # Additions from literature
# page_reference
# freigeschaltet                   default: false # Published
# romaji_order

class Entry < ActiveRecord::Base
  has_paper_trail

  ALLOWED_PARAMS = [:namenskuerzel, :kennzahl, :spaltenzahl, :japanische_umschrift, :kanji, :pali, :sanskrit, :chinesisch, :tibetisch, :koreanisch, :weitere_sprachen, :alternative_japanische_lesungen, :schreibvarianten, :deutsche_uebersetzung, :lemma_art, :jahreszahlen, :uebersetzung, :quellen, :literatur, :eigene_ergaenzungen, :quellen_ergaenzungen, :literatur_ergaenzungen, :page_reference, :romaji_order]

  belongs_to :user
  has_many :comments
  has_many :entry_docs
  has_many :entry_htmls

  validates :kennzahl, presence: true
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

end
