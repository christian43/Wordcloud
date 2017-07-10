################################# MATCH VARIABILITY OF TECHNICAL PARAMETERS #################################

##
# 1. Definiere Variablen
# 2. Lese Daten ein
# 3. Teile Spiele in sechs Intervalle
# 4. Bilde Mittelwerte für die einzelnen Variablen
##
# VARIABLEN: NACH RUSSEL: Total touches, angekommene Pässe, angekommene lange Pässe, clearance, erfolgreiches Drbblings,
# Dauer der nocontrol Phasen
#################################

library(Opta)
library(data.table)
load("~/Desktop/InstitutfuerSpielanalyse/OptaData/alleSpieleList.RData")

spiele1 <- rbindlist(spiele, fill = TRUE)

Events <- c(1,
			2,
			3,
			4,
			7,
			8,
			9,
			10,
			11,
			12,
			13,
			14,
			15,
			16,
			41,
			42,
			50,
			54,
			61,
			73,
			74)
TotalTouches <- spiele1[type_id %in% Events]
TotalTouches <- TotalTouches[!type_id == 1 & outcome == 0]
TotalTouches <- TotalTouches[!type_id == 2 & outcome == 0]
TotalTouches <- TotalTouches[!type_id == 3 & outcome == 0]
TotalTouches <- TotalTouches[!type_id == 4 & outcome == 0]

TotalTouches[,INT := ifelse(secCounter < 900, "INT1", "") ]
TotalTouches[secCounter >= 900 & secCounter <= 1800] <- "INT2"


TotalTouches[,if(secCounter >= 900 & secCounter <= 1800) "INT2"]
INT3 <- TotalTouches[secCounter > 1800 & secCounter <= 2967]
INT4 <- TotalTouches[secCounter > 2967 & secCounter <= 3600]
INT5 <- TotalTouches[secCounter > 3600 & secCounter <= 4500]
INT6 <- TotalTouches[secCounter > 4500 & secCounter <= 5830]


TT <- TotalTouches[,.(touches = .N), by = .(id, player_id, period_id, team_id)]
MEANS <- TT[,.(MEAN = mean(touches),
				   SD = sd(touches)), by = period_id]
boxplot(TT$touches ~ TT$period_id, notch = TRUE)

