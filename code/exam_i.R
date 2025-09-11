# Tidyverse Exam – Data Manipulation in R (using `mtcars` dataset)

# tidyverse ---------------------------------------------------------------

# Use `df_mtcars` for Questions 1 - 10
library(tidyverse)
df_mtcars <- as_tibble(mtcars,
                       rownames = "model")

# 1. Filter rows where number of cylinders (`cyl`) is 6
# Write code to create a new data frame that only includes rows where `cyl == 6`.
# Assign to: `mtcars_cyl6`
mtcars_cyl6 <- mtcars %>% filter(cyl == 6)

# 2. Filter rows where number of gears (`gear`) is either 3 or 5
# Use `%in%` to filter the `df_mtcars` dataset for these two `gear` values.
# Assign to: `mtcars_g35`
mtcars_gear_3_5 <- mtcars %>% filter(gear == 3, gear == 5)
# 3. Filter rows where miles per gallon (`mpg`) is greater than 25
# Create a subset of `df_mtcars` where `mpg > 25`.
# Assign to: `mtcars_mpg25`
mtcars_mpg_gt25 <- mtcars %>% filter(mpg > 25)
# 4. Filter rows where weight (`wt`) is less than 2.5 AND number of cylinders (`cyl`) is 4
# Combine logical conditions using `&`.
# Assign to: `mtcars_light_cyl4`
mtcars_light_cyl4 <- mtcars %>% filter(wt < 2.5, cyl ==4)
# 5. Sort `df_mtcars` by horsepower (`hp`) in ascending order
# Use `arrange()` to sort the data.
# Assign to: `mtcars_hp`
mtcars_sorted_hp <- mtcars %>% arrange(hp)

# 6. Sort `df_mtcars` by quarter mile time (`qsec`) in descending order
# Use `desc()` inside `arrange()`.
# Assign to: `mtcars_qsec`
mtcars_sorted_qsec_desc <- mtcars %>% arrange(desc(qsec))
# 7. Exclude the `drat` column
# Use `select()` with `-` (minus sign) to remove the column.
# Assign to: `mtcars_no_drat`
mtcars_no_drat <- mtcars %>% select(-drat)

# 8. Add a new column `ptw` that equals the ratio of horsepower (`hp`) to weight (`wt`) (`hp / wt`)
# Use `mutate()` to add the new column.
# Assign to: `mtcars_with_ptw`


mtcars_with_ptw <- mtcars %>% mutate(ptw = hp / wt)

  
# 9. Identify the car `model` with the highest `ptw` among cars with six cylinders (`cyl == 6`).
# Hint: Use `mtcars_with_ptw` and a chain of `filter()` and `arrange()` with `%>%`.
# Write the car model here: YOUR ANSWER
 mtcars_with_ptw %>% filter(cyl == 6) %>% arrange()
##Mazda RX4

# 10. Group by number of gears (`gear`) and summarize minimum & maximum values of `mpg`
# Use `group_by()` and `summarize()` to calculate minimum & maximum values of `mpg` within each group.
# Minimum and maximum values of each group should be represented as separate columns.
# Function `min()` returns the minimum value in a vector.
# Function `max()` returns the maximum value in a vector.
# Assign to: `mtcars_mpg_by_gear`
 
 mtcars_mean_mpg_by_gear <- mtcars %>% group_by(gear) %>% summarise(avg.mpg = mean(mpg))
# ggplot ------------------------------------------------------------------
 
 # Visualization in R (using iris dataset)
 
 # 1. Simple scatter plot of Sepal.Length vs Sepal.Width using ggplot()
 # Assign to: plot_scatter
 # Write code to create a basic scatter plot with Sepal.Length on the y-axis and Sepal.Width on the x-axis.
 
 
 
 plot_scatter <- ggplot(data = iris, mapping = aes(x = Sepal.Length, y = Sepal.Width)) + geom_point()
 plot_scatter
 
 # 2. Scatter plot colored by Species
 # Assign to: plot_scatter_color
 # Write code to create a scatter plot with points colored by Species.
 
 plot_scatter_color <- ggplot(data = iris, aes(x=Species, y=Sepal.Length,fill=Species)) + geom_point(color= "red") 
 plot_scatter_color
 
 
 
 # 3. Histogram of Sepal.Width with binwidth = 0.5
 # Assign to: plot_histogram_binwidth
 # Write code to plot a histogram with binwidth set to 0.5.
 
 plot_histogram_binwidth <- iris %>% ggplot(aes(x=Sepal.Length, fill=Species)) + geom_histogram(bins = 50)
 
 # Visualization in R (using PlantGrowth dataset)
 plot_histogram_binwidth
 
 
 # 4. Boxplot of weight grouped by group
 # Assign to: plot_pg_boxplot_basic
 # Write code to draw a boxplot of weight across different treatment groups in PlantGrowth.
 
 plot_pg_boxplot_basic <-  PlantGrowth %>% ggplot(aes(x = group, y = weight)) + geom_boxplot()
 plot_pg_boxplot_basic
 
 # 5. Boxplot of weight grouped by group, filled by group
 # Assign to: plot_pg_boxplot_fill
 # Write code to draw a boxplot of weight grouped by group and filled by group.
 
 plot_pg_boxplot_fill <- PlantGrowth %>% ggplot(aes(x = group, y = weight, fill = group)) + geom_boxplot()
 plot_pg_boxplot_fill
 