class EntryHtml < ActiveRecord::Base
  belongs_to :entry
  # attr_accessible :alternative_japanische_lesungen, :chinesisch, :deutsche_uebersetzung, :entry_id, :jahreszahlen, :japanische_umschrift, :kanji, :kennzahl, :koreanisch, :lemma_art, :namenskuerzel, :page_reference, :pali, :romaji_order, :sanskrit, :schreibvarianten, :spaltenzahl, :tibetisch, :uebersetzung, :weitere_sprachen
end
