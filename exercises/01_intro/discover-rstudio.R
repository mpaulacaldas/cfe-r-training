# select the line below and click "Run", on the top left
# where does the result show up?
1 + 1

# let's run another line. this time, place your cursor somewhere
# in the line below (it can be at the end, middle or bottom) and hit
# Ctrl + Enter
# what showed up in the Console?
# what happens if you click in "my_table" in the Environment pane?
my_table <- data.frame(
  name = c("maria paula", "jolien"),
  iso3 = c("COL", "BEL")
  )

# run the code below using the keyboard short cut again
# what happens in the Help pane?
# what are the main parts in the documentation of data.frame?
?data.frame
help(data.frame) # an alternative

# go to the Packages pane **before** running the following line.
# look for ggplot2. is it ticked or unticked? what happens after
# you run the lines below?
library(ggplot2)
data("diamonds")
ggplot(diamonds, aes(carat, price)) +
  geom_hex()

# in the top menu, go to Session -> Restart R
# what message appears in the Console?
# what changes in the Environment pane? in the Packages pane?

# now, click on "Source" in the top-right corner of this script.
# what happens?

# Re-start R again. This time with the shortcut: Ctrl + Shift + F10
