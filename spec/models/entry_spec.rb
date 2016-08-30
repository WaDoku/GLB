require 'spec_helper'

describe Entry do
  let!(:entry) { FactoryGirl.create(:entry) }

  it 'creates a new instance of an entry given valid attributes' do
    expect(entry).to be_persisted
    expect(entry).to be_valid
  end

  it 'is invalid without kennzahl' do
    entry.kennzahl = nil
    expect(entry.valid?).to be(false)
  end

  it 'is invalid when no field of the group
  lemma_schreibungen_und_aussprachen is filled out' do
    entry.japanische_umschrift = ''
    expect(entry.valid?).to be(false)
    expect(entry.errors.messages[:base].first).to eq('Mindestens '\
    "ein Feld der Gruppe \'Lemma-Schreibungen und -Aussprachen\' "\
    "muss ausgefüllt sein!")
  end
  it 'is valid when at least on field of the group
  lemma_schreibungen_und_aussprachen is filled out' do
    entry.japanische_umschrift = ''
    entry.kanji = 'kanji'
    expect(entry.valid?).to be(true)
  end
  it 'is invalid when no field of the group
  uebersetzungen_quellenangaben_literatur_und_ergaenzungen is filled out' do
    entry.deutsche_uebersetzung = ''
    expect(entry.valid?).to be(false)
    expect(entry.errors.messages[:base].first).to eq('Mindestens ein Feld '\
    "der Gruppe \'Uebersetzungen , Quellenangaben, Literatur und "\
    "Ergaenzungen\' muss ausgefüllt sein!")
  end
  it 'is valid when at least one field of the
  group uebersetzungen_quellenangaben_literatur_und_ergaenzungen
  is filled out' do
    entry.deutsche_uebersetzung = ''
    entry.uebersetzung = 'fernfahrer'
    expect(entry.valid?).to be(true)
  end
end
