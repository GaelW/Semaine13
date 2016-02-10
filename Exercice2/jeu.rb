class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
       res = "#{@nom} "
    if @en_vie
      res += "(#{@points_de_vie}/100 points de vie)"
    else
      res += "(vaincu)"
    end
    res
  end

  def attaque(personne)
       puts "#{@nom} attaque #{personne.nom}"
    personne.subit_attaque(degats)
    sleep 0.2
  end

  def subit_attaque(degats_recus)
      puts "#{@nom} subit #{degats_recus}hp de dégats!"
    @points_de_vie -= degats_recus

    if @points_de_vie <= 0 && @en_vie
      @en_vie = false
      puts "#{@nom} a été vaincu :("
    end

    sleep 0.2
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
       @degats_bonus = 0


    super(nom)
  end

  def degats
  
    puts "#{@nom} profite de #{@degats_bonus} points de dégats bonus"
    sleep 0.2
    rand(50) + @degats_bonus + 10
  end

  def soin
       @points_de_vie += rand(30) + 10
    puts "#{@nom} regagne de la vie."
    sleep 0.2
  end

  def ameliorer_degats
      @degats_bonus += rand(15) + 20
    puts "#{@nom} gagne en puissance !"
    sleep 0.2
  end
end

class Ennemi < Personne
  def degats
   
    rand(10) + 1
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

        i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Abandonner comme un lâche :("
  end

  def self.est_fini(joueur, monde)

    if !joueur.en_vie || monde.ennemis_en_vie.size == 0
      return true
    else
      return false
    end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
      @ennemis.select do |ennemi|
      ennemi.en_vie
    end
  end
end

monde = Monde.new

monde.ennemis = [
  Ennemi.new("Microsoft"),
  Ennemi.new("Google"),
  Ennemi.new("Samsung")
]


joueur = Joueur.new("Jean-Michel Fauconnier")

puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

100.times do |tour|
  puts "\n------------------ Tour #{tour} ------------------"


  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
    choix = gets.chomp.to_i

  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
       break
  else
       ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
   monde.ennemis_en_vie.each do |ennemi|
       ennemi.attaque(joueur)
  end

  puts "\nEtat du héro : #{joueur.info}\n"

    break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

if joueur.en_vie
  puts "Jean-Michel a gagné !"
else
  puts "Jean-Michel a perdu !"
end




