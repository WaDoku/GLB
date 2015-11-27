class EntryDoc < ActiveRecord::Base
  belongs_to :entry
  # attr_accessible :alternative_japanische_lesungen, :chinesisch, :deutsche_uebersetzung, :eigene_ergaenzungen, :entry_id, :jahreszahlen, :japanische_umschrift, :kanji, :kennzahl, :koreanisch, :lemma_art, :literatur, :literatur_ergaenzungen, :namenskuerzel, :page_reference, :pali, :quellen, :quellen_ergaenzungen, :romaji_order, :sanskrit, :schreibvarianten, :spaltenzahl, :tibetisch, :uebersetzung, :weitere_sprachen
end
