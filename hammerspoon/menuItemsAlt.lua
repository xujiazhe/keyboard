app = hs.application.frontmostApplication()
menus = app:getMenuItems()

menuPath1 = {"Edit", "Spelling and Grammar", "Check Spelling While Typing"}
menuPath2 = {"Edit", "Spelling and Grammar", "Check Grammar With Spelling"}
menuPath3 = {"Edit", "Spelling and Grammar", "Correct Spelling Automatically"}

subMenu ={"Edit", "Spelling and Grammar"}
app:selectMenuItem(subMenu)
app:findMenuItem(subMenu).ticked

app:selectMenuItem(menuPath1)
app:selectMenuItem(menuPath1)
app:selectMenuItem({"Edit"})
app:findMenuItem(menuPath1).ticked
app:getMenuItems()[1].AXTitle

