# J. Jedediah Smith
# BIFX 546 Final
# Dr. Sierra Sosa
# 5/6/2023


#######################
### BASIC DATA PREP ###
#######################

# Import our data, remove N/A variable, remove id, and make it all numbers.
library(dplyr)
library(stringr)
data <- read.csv("data.csv") %>%
  select(-c(X,id)) %>%
  mutate(across("diagnosis", str_replace, "B", "0")) %>%
  mutate(across("diagnosis", str_replace, "M", "1"))

# Randomize the rows so it isn't "in order." Don't want to bias the model by choosing too many of one outcome.
set.seed(2347253)
data_random <- data[sample(1:nrow(data)), ]

# Now select our test and train data, but exclude diagnosis.
train_data <- data_random[1:455, 2:ncol(data_random)]
test_data <- data_random[456:569, 2:ncol(data_random)]

# Save diagnosis for comparison afterwards.
train_labels <- data_random[1:455,1]
test_labels <- data_random[456:569,1]


##########################
### VECTORIZE THE DATA ###
##########################

# Vectorization function
vectorize_sequences <- function(sequences, dimension = 10000) {

  # Create an all-zero matrix of shape (len(sequences), dimension)
  results <- matrix(0, nrow = nrow(sequences), ncol = dimension)
 
  for (i in 1:length(sequences))
    # Sets specific indices of results[i] to 1s
    results[i, sequences[[i]]] <- 1
  
  results
}

# Our vectorized data sets
vx_train <- vectorize_sequences(train_data)
vx_test <- vectorize_sequences(test_data)

# Our vectorized labels
vy_train <- as.numeric(train_labels)
vy_test <- as.numeric(test_labels)


################################
### BUILD THE NEURAL NETWORK ###
################################

# Make the layers
library(keras)
model <- keras_model_sequential() %>% 
  layer_dense(units = 16, activation = "relu", input_shape = c(10000)) %>% 
  layer_dense(units = 16, activation = "relu") %>% 
  layer_dense(units = 1, activation = "sigmoid")

# Pick optimizer, loss function, and metrics
model %>% compile(
  optimizer = optimizer_rmsprop(learning_rate = 0.001),
  loss = loss_binary_crossentropy,
  metrics = c(metric_binary_accuracy(), metric_recall(), metric_precision())
) 

# Fit the model
model %>% fit(vx_train, vy_train, epochs = 4, batch_size = 512)

# Make predictions
results <- model %>% evaluate(vx_test, vy_test)

# Predict from training to evaluate over-fitting
results_2 <- model %>% evaluate(vx_train, vy_train)


###########################
### RESULTS AND METRICS ###
###########################

# Compare metrics, both pretty abysmal
results   # Validation
results_2 # Training

# Make sure to calculate F1 as well
f1 <- (2*as.numeric(results[3])*as.numeric(results[4]))/(as.numeric(results[3])+as.numeric(results[4]))
f1_2 <- (2*as.numeric(results_2[3])*as.numeric(results_2[4]))/(as.numeric(results_2[3])+as.numeric(results_2[4]))
f1 # Validation
f1_2 #Training