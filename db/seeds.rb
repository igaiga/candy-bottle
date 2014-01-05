# -*- coding: utf-8 -*-
target_words = ['いがいが', 'いがさん', 'igaiga']
target_words.each do |word|
  Target.new(word: word).save! unless Target.where(word: word).exists?
end
