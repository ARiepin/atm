Note::AVAILABLE_DENOMINATIONS.each {|el| 10.times { Note.create!(denomination: el) } }
