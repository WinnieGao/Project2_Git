#' @title CVgeneric
#' @description train data using a classifier and compute the performance of the classifier
#' @param classifier a classification model
#' @param training_feature the feature used to train data
#' @param training_label the label of classification
#' @param K number of folds to use in cross-validation
#' @param loss_function a function used to evaluate performance of the classifier
#' @param method 1,2 the index of two splitting method
#' @return a array with K objects. performance calculated by loss_function across K folds

CVgeneric <- function(classifier, training_feature, training_label, K, loss_function, method) {
  bin = matrix(list(), nrow = 1, ncol = K)
  for (i in 1:23) {
    bin[[1, i %% K + 1]] = c(bin[[1, i %% K + 1]], i)
  }
  error = c()
  train_data = train_val_data
  train_data$check = rep(FALSE, nrow(train_data))
  for (i in 1:K) {
    for (j in bin[i]) {
      if (method == 2) {
        x_index = (j - 1) %/% 5 + 1
        y_index = (j - 1) %% 5 + 1
        for (k in 1:length(x_index)) {
          lower_x = x_cut[x_index[k]]
          upper_x = x_cut[x_index[k] + 1]
          lower_y = y_cut[y_index[k]]
          upper_y = y_cut[y_index[k] + 1]
          train_data[train_data$x_coord >= lower_x & train_data$x_coord < upper_x & train_data$y_coord >= lower_y & train_data$y_coord < upper_y, "check"] = TRUE
        }
      }else {
        y_index = j
        for (k in 1:length(y_index)) {
          lower_y = y_cut[y_index[k]]
          upper_y = y_cut[y_index[k] + 1]
          train_data[train_data$y_coord >= lower_y & train_data$y_coord < upper_y, "check"] = TRUE
        }
      }
    }
    CV_val = train_data[!train_data$check, ]
    CV_train = train_data[train_data$check, ]
    currFormula = as.formula(paste(training_label, "~", 
                                   paste(training_feature, collapse = "+"), sep = ""))
    if (identical(classifier, glm)) {
      model = classifier(currFormula, data = CV_train)
      y_prob = predict(model, CV_val, type = "response")
      y = CV_val[, training_label]
      y_hat = rep(-1, length(y_prob))
      y_hat[y_prob > 0.5] = 1
      error = c(error, loss_function(y_hat, y))
    }
    if (identical(classifier, lda)) {
      model = classifier(currFormula, data = CV_train)
      y_prob = predict(model, CV_val)
      y = CV_val[, training_label]
      y_hat = y_prob$class
      error = c(error, loss_function(y_hat, y))
    }
    if (identical(classifier, qda)) {
      model = classifier(currFormula, data = CV_train)
      y_prob = predict(model, CV_val)
      y = CV_val[, training_label]
      y_hat = y_prob$class
      error = c(error, loss_function(y_hat, y))
    }
    if (identical(classifier, knn)) {
      knn.pred = classifier(CV_train[, training_feature], CV_val[, training_feature], CV_train[, training_label], k = 3)
      error = c(error, loss_function(knn.pred, CV_val[, training_label]))
    }
    if (identical(classifier, svm)) {
      model = classifier(currFormula, data = CV_train, type = "C-classification", kernel = "linear", cost = 1)
      y_hat = predict(model, CV_val)
      y = CV_val[, training_label]
      error = c(error, loss_function(y_hat, y))
    }
  }
  return(error)
}