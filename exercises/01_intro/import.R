# Before we start, re-start the R session! This will clear any data from memory
# and detach any packages. The shortcut is Ctrl + Shift + F10.

# These are the libraries we will use today. You need to load them to have
# access to their functions. It's a convention to list them at the beginning of
# scripts. To execute the lines, you can use the shortcut Ctrl + Enter
library(readr)
library(readxl)


# Read and view a dta file ------------------------------------------------

# Why does this fail? Read the error message. What did we forget? If you're
# stuck, scroll to the bottom of the script and see Hint 1
colombia <- read_dta("births-colombia.dta")


# Read a CSV from the web -------------------------------------------------

url_chile <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto32/Defunciones_std.csv"

# Let's read the first few rows of the data
chile_head <- read_csv(
  url_chile,
  n_max = ... # replace the ... with a number between 5 and 10
  )

# Look at the message that was printed in the Console. What does it tell you?
# Now print the table by running the code below . What is written below the column names?
chile_head

# Now, the column names of the data don't seem very useful for operations. Let's
# change them directly during import.

# First, write the names you would like to have in the new data below.
better_names <- c(
  ...,
  ...,
  ...,
  ...,
  ...,
  "date"
  )

# Let's try to read the full data set again now. Where would you put the
# "better_names" vector to change the names during import? Have a look at the
# function documentation, in the "Arguments" section.
?read_csv
chile <- read_csv(
  url_chile,
  col_names = ...,
  skip = 1 # Why do we need this?
  )


# Read sheets from an Excel spreadsheet -----------------------------------

# Why does this fail?
germany_fail <- read_excel("deaths-deu.xlsx")

# Try reading the second sheet. Fill the path to the file between the "".
#
# Protip: place the cursor inside the "" and press tab, navigate to the
# German file with the up-and-down arrow keys, then press tab again
germany_sheet2 <- read_excel("", sheet = 2)

# Inspect the data with View() or by printing it to the Console. What argument
# would you have added to the code above to get rid of the lines at the
# beginning without a lot of information?

# Let's see how many sheets the German spreasheet has.
excel_sheets("")

# Read the BL_2016_2021_Monate_AG_Ins sheet on your own. How many lines would
# you skip?
... <- ...(...)


# Cheat with the IDE: tricky encodings ------------------------------------

# Let's attempt a first read of the data. Have a look at the second column
japan_gibberish <- read_csv("deaths-japan.csv", skip = 2)
japan_gibberish
View(japan_gibberish)

# This is known as an encoding problem. Let's try to find the encoding of the
# original file. For this, head to the "Files" pane in the RStudio IDE and click
# on the "deaths-japan.csv" file, then on "Import dataset". Press on the
# "Configure..." button that is on the bottom left quadrant. There, in the
# "Encoding" box, try a couple of different encodings until you find the right
# one. (PS: If you're stuck, see Hint 2)

# Finish configuring the import, and copy the code preview below


# Save data ---------------------------------------------------------------

# Choose one of the datasets we saw today and save it to an RDS file
...(...)


# Hints -------------------------------------------------------------------

# Hint 1: There is a missing library at the top. Take a look at the slides if
# you can't remember which one.
#
# Hint 2: The encoding name has a J and sounds like a keyboard shortcut.
