fish = read.csv("data/coral_fish.csv")

View(fish)

## 2 typos to fix
table(fish$type)

# there is a typo : sbutropical
i = which(fish$type == "sbutropical")
fish$type[i] = "subtropical"

i = which(fish$type == "trpical")
fish$type[i] = "tropical"

## 2 cases to delete

# delete row 189
# i = which(fish$richness < 0)
# fish[-i, ]

which(! fish$richness < 0)
fish[i, ]

fish = subset(fish, richness >= 0 & 
			  	richness < 1000)

#### PENGUINS
penguins = read.csv("https://raw.githubusercontent.com/allisonhorst/palmerpenguins/refs/heads/main/inst/extdata/penguins.csv")
View(penguins)

subset(penguins, !is.na(body_mass_g)

subset(penguins, complete.cases(penguins))













