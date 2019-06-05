#script6 - Warsaw bridges results - correlation matrix
library(corrplot)

all_data <- read.table("/home/lukasz/Pulpit/Results_WAW_Bridges5/bridges_5.csv", header = TRUE, sep = "\t")
all_data_selected_columns <- all_data[, c(8, 11, 12, 13, 14, 15, 16, 17, 18, 20)]
all_data_selected_columns <- all_data[, c(8, 11, 16, 12, 13, 14)]
correlation_matrix = cor(all_data_selected_columns)
colnames(correlation_matrix) <- c("Długość trasy \"Blind\" [km]", "Długość trasy \"Traffic\" [km]", "Czas przejazdu trasą \"Real\" [s]",
                                  "A |bridge_traffic - bridge_real|", "B |bridge_blind - bridge_real|",
                                  "C |bridge_traffic - bridge_blind|")
rownames(correlation_matrix) <- c("Długość trasy \"Blind\" [km]", "Długość trasy \"Traffic\" [km]", "Czas przejazdu trasą \"Real\" [s]",
                                  "A |bridge_traffic - bridge_real|", "B |bridge_blind - bridge_real|",
                                  "C |bridge_traffic - bridge_blind|")
write.table(correlation_matrix, "/home/lukasz/Pulpit/Results_WAW_Bridges5/correlation_matrix_5_2.csv", sep="\t")

dev.new(width = 550, height = 330, unit = "px")
corrplot(correlation_matrix, type = "upper", tl.col = "black")
