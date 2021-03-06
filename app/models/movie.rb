class Movie < ActiveRecord::Base
    def self.on_rankings(list)
        return Movie.where("LOWER(rating) IN (?)", list.map(&:downcase))
    end
    
    def self.all_rankings
        Movie.select(:rating).map(&:rating).uniq
    end
end
