import pandas as pd

df = pd.read_csv("./Alternate-Vote.csv")
pd.set_option('display.max_rows', None)

df = df[["Areas", "% Yes", "% No", "Turnout"]]
df["Percentage Yes"] = (df["% Yes"]).str.replace("%", "", regex=False)
df["Percentage No"] = (df["% No"]).str.replace("%", "", regex=False)
df["Percentage Turnout"] = (df["Turnout"]).str.replace("%", "", regex=False)
df = df.drop(["% Yes", "% No", "Turnout"], axis=1)

df.to_csv("./AV-Formatted.csv", index=False)
